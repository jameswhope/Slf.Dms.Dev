IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MarkCancellationAsCompleted')
	BEGIN
		DROP  Procedure  stp_MarkCancellationAsCompleted
	END

GO

CREATE Procedure stp_MarkCancellationAsCompleted
(	
	@MatterId int,	
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
			,@ClientId INT
			,@ReasonId INT
			,@StatusId INT
			,@MatterStatusId INT
			,@MatterSubStatusId INT
			,@MatterStatusCodeID INT
			,@FirmId INT
			,@Status VARCHAR(50)
			,@ApprovedNote varchar(max)
			,@RecipientAccount varchar(50)
			,@UserName VARCHAR(50)
			,@RecipientName varchar(250);			
		   
	SELECT @ClientId = cl.ClientId, @ReasonId = cs.CancellationSubReasonId, @RecipientAccount = c.AccountNumber,
			@RecipientName =( p.FirstName + ' ' + p.LastName), @FirmId = c.CompanyId
	FROM tblCancellation cl inner join
		 tblCancellationReasonSummary cs ON cs.MatterId = cl.MatterId inner join
		 tblClient c ON c.ClientId = cl.ClientId inner join
		 tblPerson p ON p.PersonId = c.PrimaryPersonId
	WHERE cl.MatterId = @MatterId;

	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@StatusId = (CASE WHEN @ReasonId = 35 THEN 18 ELSE 17 END)
		   ,@Status = (SELECT [Name] FROM tblClientStatus WHERE ClientStatusId = @StatusId)
		   ,@MatterStatusId = 4
		   ,@MatterSubStatusId = (CASE WHEN @ReasonId = 35 THEN (SELECT MatterSubStatusId FROM tblMatterSubStatus
														 WHERE MatterSubStatus = 'Client Completed')
									ELSE (SELECT MatterSubStatusId FROM tblMatterSubStatus
														 WHERE MatterSubStatus = 'Client Cancelled') END)
		   ,@MatterStatusCodeId = (CASE WHEN @ReasonId = 35 THEN (SELECT MatterStatusCodeId FROM tblMatterStatusCode
														 WHERE MatterStatusCode = 'COMP')
									ELSE (SELECT MatterStatusCodeId FROM tblMatterStatusCode
														 WHERE MatterStatusCode = 'CAN') END)
		   ,@UserName = (SELECT FirstName + ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
		   ,@ApprovedNote = (SELECT @RecipientName + ' has been marked as ' + @Status + ' by ' + @UserName);


	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY			
			
			UPDATE tblMatter SET
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusId = @MatterStatusId,
				MatterStatusCodeId = @MatterStatusCodeId
			WHERE MatterId = @MatterId
			
			UPDATE tblAccount_PaymentProcessing SET 
			ProcessedDate = getdate() ,
			CheckNumber = @CheckNumber
			WHERE MatterId = @MatterId and DeliveryMethod <> 'C';

			UPDATE tblAccount_PaymentProcessing SET 
				Processed = 1, 
				ReferenceNumber = @Reference,
				CheckAmount = @CheckAmount,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE MatterId = @MatterId;

			UPDATE tblClient SET CurrentClientStatusId = @StatusId WHERE ClientId = @ClientId;

			INSERT INTO tblAudit(AuditColumnId, PK, [Value], UC, DC, Deleted)
			VALUES(52, @ClientId, @StatusId, @CreatedBy, getdate(), 0);

			UPDATE tblClientBankAccount SET [Disabled] = getdate(), DisabledBy = @CreatedBy WHERE ClientId = @ClientId;

			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, null, @ApprovedNote,null,null, null,null,null;

			IF @Note is not null BEGIN
				EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, null, @Note,null,null, null,null,null;
			END
	
			
			IF @CheckAmount > 0 BEGIN
				INSERT INTO tblFirmRegister(RegisterId, FirmId, ProcessedDate, 
											 RequestType, FeeRegisterId,
											Amount, CheckNumber, ReferenceNumber, 
											Cleared, Created, CreatedBy, LastModified, LastModifiedBy,
											RecipientAccountNumber, RecipientName, DataType)
				VALUES(@RegisterId, @FirmId, getdate(),
						  'Cancellation', @FeeRegisterId,
						 @CheckAmount, @CheckNumber, @Reference,
						 0, getdate(), @CreatedBy, getdate(),@CreatedBy,
						 @RecipientAccount, @RecipientName, 'DEBITS')
			END

			INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, Created, CreatedBy)
			VALUES(@MatterId, @MatterStatusCodeId, getdate(), @CreatedBy);

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

