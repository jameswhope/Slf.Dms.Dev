IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ResolveManagerOverride')
	BEGIN
		DROP  Procedure  stp_ResolveManagerOverride
	END

GO

CREATE Procedure stp_ResolveManagerOverride
(	
	@SettlementId int,
	@IsApproved bit,
	@Note varchar(max),			
	@CreatedBy int	
)

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DECLARE @Return INT
			,@InTran BIT			
			,@SettlementMatter INT
			,@MatterStatusCodeId INT
			,@MatterSubStatusId INT
			,@MatterStatusId INT
			,@Active BIT
			,@IsDeleted BIT
			,@ApprovedNote VARCHAR(MAX)
			,@ClientId INT
			,@AccountId INT
			,@UserName VARCHAR(50)
			,@SettlementAmount MONEY
			,@DeliveryAmount MONEY
			,@DeliveryMethod VARCHAR(3)
			,@CheckAmount MONEY
			,@DueDate DATETIME
			,@AvailSDA MONEY
			,@CreditorName VARCHAR(100);
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy);
		   
	SELECT @SettlementMatter = MatterId, @ClientId = s.ClientId, @AccountId = CreditorAccountId, @DueDate = SettlementDueDate,
			@SettlementAmount = SettlementAmount, @DeliveryAmount = DeliveryAmount, @AvailSDA = isnull(AvailSDA,c.SDABalance),
			@DeliveryMethod = (CASE WHEN DeliveryMethod = 'chkbytel' THEN 'P' WHEN DeliveryMethod = 'chkbyemail' THEN 'E' ELSE 'C' END)
	FROM tblSettlements s
	JOIN tblClient c on c.clientid = s.clientid
	WHERE SettlementId = @SettlementId;

	SET @CreditorName = (SELECT cr.[Name] FROM tblAccount a inner join 
							tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
							tblCreditor cr ON cr.CreditorId = ci.CreditorId WHERE a.AccountId = @AccountId);

	SET @CheckAmount = (CASE WHEN (@DeliveryMethod = 'P' and @DeliveryAmount <> 15) THEN (@SettlementAmount + @DeliveryAmount) ELSE @SettlementAmount END);

	IF @IsApproved = 1 BEGIN
		SELECT @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Pending Accounting Approval'), 
			   @MatterStatusId = 3, 
			   @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Accounting Approval'),
			   @Active = 1 ,@IsDeleted = 0

		SET @ApprovedNote = (SELECT @UserName + ' approved shortage override for settlement between client '+ p.FirstName + ' ' + p.LastName + ' and creditor ' + cr.[Name] + ' #' + SUBSTRING(ci.AccountNumber, len(ci.AccountNumber) - 3, 4) + ' for $' + Convert(varchar(10),s.SettlementAmount) + ' with available balance of  ' + isnull(Convert(varchar(10),@AvailSDA),'NA')
									from tblSettlements s
							inner join tblClient c On c.ClientId = s.ClientId
							inner join tblPerson p On p.PersonId = c.PrimaryPersonId
							inner join tblAccount a On a.AccountId = s.CreditorAccountId
							inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
							inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId 
							where SettlementId = @SettlementId)
	END	
	ELSE BEGIN
		SELECT @MatterStatusCodeId = 33, @MatterStatusId = 2, @MatterSubStatusId = 61, @Active = 0
				,@IsDeleted = 1;

		SET @ApprovedNote = (SELECT @UserName + ' rejected shortage override for settlement between client '+ p.FirstName + ' ' + p.LastName + ' and creditor ' + cr.[Name] + ' #' + SUBSTRING(ci.AccountNumber, len(ci.AccountNumber) - 3, 4) + ' for $' + Convert(varchar(10),s.SettlementAmount) + ' with available balance of  ' + isnull(Convert(varchar(10),@AvailSDA),'NA')
									from tblSettlements s
							inner join tblClient c On c.ClientId = s.ClientId
							inner join tblPerson p On p.PersonId = c.PrimaryPersonId
							inner join tblAccount a On a.AccountId = s.CreditorAccountId
							inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
							inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId 
							where SettlementId = @SettlementId)
	END
		   
	IF @SettlementMatter IS NULL SET @Return = -2 --matter does not exist	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY	
			IF @IsApproved = 1 BEGIN
				--Insert the Settlement Roadmap
				INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
				VALUES(@SettlementId, 32, null, @CreatedBy, getdate())
			END

			if not exists (SELECT 1 FROM tblAccount_DeliveryInfo WHERE MatterId = @SettlementMatter) begin
				INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState, 
								DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail, PayableTo, AttentionTo, 
								ContactName)
				SELECT @SettlementMatter, sd.[Address], sd.City, sd.[State], sd.Zip, sd.ContactNumber, NULL, sd.EmailAddress, 
							(case when sd.PayableTo is null or len(sd.PayableTo) = 0 Then @CreditorName else sd.PayableTo end),
							 sd.AttentionTo, sd.ContactName
				FROM tblSettlements_DeliveryAddresses sd
			end
		
			EXEC @Return = stp_ResolveSettlementMatter @SettlementId, @Note, @ApprovedNote, @CreatedBy, @ClientId, null, @AccountId,
							null, null, null, null, null, @MatterStatusCodeId, @MatterStatusId, @MatterSubStatusId, @IsDeleted, @Active,@IsApproved;

			IF @IsApproved = 1 BEGIN
				INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
					VALUES(@SettlementMatter, @DueDate, @AvailSDA, 'Settlement', @CheckAmount, @DeliveryMethod, getdate(), @CreatedBy, getdate(), @CreatedBy, 0)
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


