IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Accounting_RejectPayment')
	BEGIN
		DROP  Procedure  stp_Accounting_RejectPayment
	END

GO

CREATE Procedure [dbo].[stp_Accounting_RejectPayment]
(
@ApproveXml XML,
@UserId INT
)

AS
BEGIN
	SET ARITHABORT ON;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DECLARE @InTran BIT
			,@Return INT
			,@PaymentExist BIT;

	SELECT @InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
			,@Return = 0
			,@PaymentExist = (CASE WHEN (SELECT count(*) FROM tblAccount_PaymentProcessing WHERE PaymentProcessingId IN(
								  SELECT ParamValues.ParamId.value('@PaymentId','int') 
	                     FROM @ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))) = 0 THEN 1 ELSE 0 END);

	--IF @PaymentExist = 0 SET @Return = -2;
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY

			UPDATE tblAccount_PaymentProcessing SET
				ApprovedDate = getdate(),
				ApprovedBy = @UserId,
				IsApproved = 0,
				LastModified = getdate(),
				LastModifiedBy = @UserId
			FROM tblAccount_PaymentProcessing acc WHERE acc.PaymentProcessingId IN
			(SELECT 
					ParamValues.ParamId.value('@PaymentId','int') AS PaymentId 	
			 FROM 
					@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))

			UPDATE tblMatter SET
				MatterStatusId = 2,
				MatterSubStatusId = 69,
				MatterStatusCodeId = 41,
				IsDeleted = 1
				FROM tblMatter m Inner Join
				tblAccount_PaymentProcessing acc ON acc.MatterId = m.MatterId and
				acc.PaymentProcessingId IN 
					(SELECT 
						ParamValues.ParamId.value('@PaymentId','int')			
					 FROM 
						@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))

			UPDATE tblAccount SET AccountStatusId = isnull(a.PreviousStatus, a.AccountStatusId) 
			FROM tblAccount a inner join
				 tblSettlements s ON s.CreditorAccountId = a.AccountID inner join
				 tblMatter m ON m.MatterId = s.MatterId inner join
				 tblAccount_PaymentProcessing acc ON acc.MatterId = m.MatterId and acc.PaymentProcessingId in
						(SELECT 
							ParamValues.ParamId.value('@PaymentId','int')			
						 FROM 
							@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))
							
			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
			SELECT 127, a.AccountID, a.AccountStatusId, getdate(), @UserId, 0
			FROM tblSettlements s inner join
				 tblAccount a ON a.AccountID = s.CreditorAccountId inner join
				 tblAccount_PaymentProcessing acc ON acc.MatterId = s.MatterId and acc.PaymentProcessingId in
						(SELECT 
							ParamValues.ParamId.value('@PaymentId','int')			
						 FROM 
							@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))

			UPDATE tblSettlementTrackerImports 
			SET [Status] = (SELECT Code FROM tblAccountStatus WHERE AccountStatusId = a.AccountStatusId),
				CancelDate = getdate(),
				CancelBy = @UserId,
				LastModified = getdate(),
				LastModifiedBy = @UserId 
			FROM tblSettlementTrackerImports ti inner join
				 tblSettlements s ON s.SettlementId  = ti.SettlementId inner join
				 tblAccount a ON a.AccountId = s.CreditorAccountId inner join				 
				 tblMatter m ON m.MatterId = s.MatterId inner join
				 tblAccount_PaymentProcessing acc ON acc.MatterId = m.MatterId and acc.PaymentProcessingId in
						(SELECT 
							ParamValues.ParamId.value('@PaymentId','int')			
						 FROM 
							@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))
				 

			INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, Created, CreatedBy)
			SELECT s.SettlementId, m.MatterStatusCodeId, getdate(), @UserId
			FROM tblAccount_PaymentProcessing acc inner join
			tblMatter m ON m.MatterId = acc.MatterId inner join
			tblSettlements s ON s.MatterId = m.MatterId

			IF @InTran = 0 COMMIT
		END TRY
		BEGIN CATCH
			SET @Return = -1
			IF @InTran = 0 ROLLBACK
		END CATCH
	END	
	SET ARITHABORT OFF;
	RETURN @Return;			
END
GO

