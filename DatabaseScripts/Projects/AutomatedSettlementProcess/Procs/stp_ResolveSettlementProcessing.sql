IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ResolveSettlementProcessing')
	BEGIN
		DROP  Procedure  stp_ResolveSettlementProcessing
	END

GO

CREATE Procedure [dbo].[stp_ResolveSettlementProcessing]
(	
	@PaymentId int,
	@SettlementId int,	
	@Note varchar(max),			
	@CreatedBy int,
	@Reference varchar(20),
	@CheckNumber int,
	@CheckAmount money,
	@RegisterId int,
	@FeeRegisterId int
)

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DECLARE @Return INT
			,@InTran BIT			
			,@SettlementMatter INT			
			,@ClientId INT
			,@AccountId INT
			,@NegotiationStatus INT
			,@Result VARCHAR(255)
			,@MatterStatusId INT
			,@MatterSubStatusId INT
			,@MatterStatusCodeID INT
			,@FirmId INT
			,@ApprovedNote varchar(max)
			,@RecipientAccount varchar(50)
			,@RecipientName varchar(250)
			,@DeliveryMethod varchar(50)
			,@CreatedDate datetime
			,@IsPaymentArrangement bit;
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   
	SELECT @SettlementMatter = MatterId, @ClientId = ClientId, @AccountId = CreditorAccountId, @CreatedDate = Created,
	@IsPaymentArrangement = IsPaymentArrangement
	FROM tblSettlements WHERE SettlementId = @SettlementId;

	SELECT @RecipientAccount = ci.AccountNumber, @RecipientName = cr.Name 
	FROM tblAccount a inner join
	tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
	tblCreditor cr ON cr.CreditorId = ci.CreditorId
	WHERE a.AccountId = @AccountId

	SET @FirmId = (SELECT CompanyId FROM tblClient WHERE ClientId = @ClientId);

	SELECT @DeliveryMethod = DeliveryMethod FROM tblAccount_PaymentProcessing WHERE PaymentProcessingId = @PaymentId;
	
	if (@IsPaymentArrangement = 1 AND
 		Exists(Select PmtScheduleId from tblPaymentSchedule Where Deleted Is Null And SettlementId = @SettlementId And RegisterId Is Null))
		SELECT @MatterStatusId = 3, @MatterSubStatusId = 96, @MatterStatusCodeId = 57;	
 	ELSE
		SELECT @MatterStatusId = 4, @MatterSubStatusId = 65, @MatterStatusCodeId = 37;

	SET @ApprovedNote = (SELECT 'settled account '+ cr.[Name] + ' #' + SUBSTRING(ci.AccountNumber, len(ci.AccountNumber) - 3, 4) + ' for client '+ p.FirstName + ' ' + p.LastName + ' for $' + Convert(varchar(10),s.SettlementAmount)
									from tblSettlements s
							inner join tblClient c On c.ClientId = s.ClientId
							inner join tblPerson p On p.PersonId = c.PrimaryPersonId
							inner join tblAccount a On a.AccountId = s.CreditorAccountId
							inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
							inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId 
							where SettlementId = @SettlementId)
 
	IF @SettlementMatter IS NULL SET @Return = -2 --matter does not exist	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY			
			
			EXEC @Return = stp_ResolveSettlementMatter @SettlementId, @Note, @ApprovedNote, @CreatedBy, @ClientId, null, @AccountId, 
							null, null, null, null, null, @MatterStatusCodeId, @MatterStatusId, @MatterSubStatusId, 0, 0,1;
			
			
			IF @DeliveryMethod <> 'chk' BEGIN
				UPDATE tblAccount_PaymentProcessing SET 
				ProcessedDate = getdate() ,
				CheckNumber = @CheckNumber
				WHERE PaymentProcessingId = @PaymentId;
			END

			UPDATE tblAccount_PaymentProcessing SET 
				Processed = 1, 
				ReferenceNumber = @Reference,
				CheckAmount = @CheckAmount,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE PaymentProcessingId = @PaymentId;

			UPDATE tblAccount SET
				Settled = getdate(),
				SettledBy = @CreatedBy,
				AccountStatusId = 54
			WHERE AccountId = @AccountId;
			
			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(139, @AccountId, getdate(), getdate(), @CreatedBy, 0);
				
			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(140, @AccountId, @CreatedBy, getdate(), @CreatedBy, 0);
				
			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(127, @AccountId, 54, getdate(), @CreatedBy, 0);

			UPDATE tblSettlementTrackerImports
			SET [Status] = 'SA',
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy,
				Paid = getdate(),
				days = DATEDIFF(day, @CreatedDate, getdate())
			WHERE SettlementId =@SettlementId;

			INSERT INTO tblFirmRegister(RegisterId, FirmId, ProcessedDate, 
										 RequestType, FeeRegisterId,
										Amount, CheckNumber, ReferenceNumber, 
										Cleared, Created, CreatedBy, LastModified, LastModifiedBy,
										RecipientAccountNumber, RecipientName, DataType)
			VALUES(@RegisterId, @FirmId, getdate(),
					  'Settlement', @FeeRegisterId,
					 @CheckAmount, @CheckNumber, @Reference,
					 0, getdate(), @CreatedBy, getdate(),@CreatedBy,
					 @RecipientAccount, @RecipientName, 'DEBITS')

			--resolve client alert
			UPDATE tblclientalerts
			SET Resolved=getdate(),
				ResolvedBy = @CreatedBy
			WHERE AlertRelationType = 'tblSettlements' 
			and resolved is null 
			and alertrelationid =@SettlementId;	


			IF @Return <> 0 BEGIN
				SET @Return = -3
			END	

			IF @InTran = 0 BEGIN
				IF @Return = 0 COMMIT ELSE ROLLBACK;
			END
		END TRY
		BEGIN CATCH
			SET @Return = -1;
			IF @InTran = 0 ROLLBACK;
		END CATCH
	END
	
	RETURN @Return
END
GO




