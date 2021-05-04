IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Accounting_RejectPayment')
	BEGIN
		DROP  Procedure  stp_Accounting_RejectPayment
	END

GO

CREATE procedure [dbo].[stp_Accounting_RejectPayment]
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
			,@PaymentExist BIT
			,@MatterId INT;

	DECLARE @Payments TABLE( PaymentId INT, MatterId INT, RequestType VARCHAR(50));

	SELECT @InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
			,@Return = 0;		
	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY			
			INSERT INTO @Payments(PaymentId, MatterId, RequestType)
			SELECT 
					acc.PaymentProcessingId AS PaymentId , acc.MatterId, acc.RequestType	
			FROM tblAccount_PaymentProcessing acc WHERE acc.PaymentProcessingId IN
			(SELECT 
					ParamValues.ParamId.value('@PaymentId','int') AS PaymentId 	
			 FROM 
					@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))

			UPDATE tblAccount_PaymentProcessing SET
				ApprovedDate = getdate(),
				ApprovedBy = @UserId,
				IsApproved = 0,
				LastModified = getdate(),
				LastModifiedBy = @UserId
			FROM tblAccount_PaymentProcessing acc WHERE acc.PaymentProcessingId IN
			(SELECT PaymentId FROM @Payments)

			UPDATE tblMatter SET
				MatterStatusId = 2,
				MatterSubStatusId = 69,
				MatterStatusCodeId = 41
				FROM tblMatter WHERE MatterId in (SELECT MatterId FROM @Payments)

			IF (SELECT count(*) FROM @Payments WHERE RequestType = 'Settlement') > 0 BEGIN

				UPDATE tblAccount SET AccountStatusId = isnull(a.PreviousStatus, 51) 
				FROM tblMatter m left join
					 tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId left join
					 tblAccount a ON a.AccountId = ci.AccountId 
				WHERE m.MatterTypeId = 3 and MatterId in (SELECT MatterId FROM @Payments)
								
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				SELECT 127, a.AccountID, a.AccountStatusId, getdate(), @UserId, 0
				FROM tblMatter m left join
					 tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId left join
					 tblAccount a ON a.AccountId = ci.AccountId 
				WHERE m.MatterTypeId = 3 and MatterId in (SELECT MatterId FROM @Payments)

				UPDATE tblSettlementTrackerImports 
				SET [Status] = (SELECT Code FROM tblAccountStatus WHERE AccountStatusId = a.AccountStatusId),
					CancelDate = getdate(),
					CancelBy = @UserId,
					LastModified = getdate(),
					LastModifiedBy = @UserId 
				FROM tblMatter m left join
					 tblSettlements s ON s.MatterId = m.MatterId left join
					 tblSettlementTrackerImports ti ON ti.SettlementId = s.SettlementId left join
					 tblAccount a ON s.CreditorAccountId = a.AccountId
				WHERE
					m.MatterTypeId = 3 and m.MatterId in (SELECT MatterId FROM @Payments)

				INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, Created, CreatedBy)
				SELECT s.SettlementId, m.MatterStatusCodeId, getdate(), @UserId
				FROM tblMatter m left join
				tblSettlements s ON s.MatterId = m.MatterId
				WHERE m.MatterTypeId = 3 and m.MatterId in (SELECT MatterId FROM @Payments)	
				
				INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState, 
								DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail, PayableTo, AttentionTo, 
								ContactName)
				SELECT m.MatterId, sd.[Address], sd.City, sd.[State], sd.Zip, sd.ContactNumber, NULL, sd.EmailAddress, 
							(case when sd.PayableTo is null or len(sd.PayableTo) = 0 Then cr.[Name] else sd.PayableTo end),
							 sd.AttentionTo, sd.ContactName
				FROM tblMatter m left join 
					 tblSettlements s ON s.MatterId = m.MatterId left join
					 tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId left join
					 tblAccount a ON a.AccountId = s.CreditorAccountId left join
					 tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId left join
					 tblCreditor cr ON cr.CreditorId = ci.CreditorId
				WHERE m.MatterTypeId = 3 AND m.MatterId IN (SELECT MatterId FROM @Payments) AND NOT EXISTS(SELECT 1 FROM
					  tblAccount_DeliveryInfo WHERE MatterId in (SELECT MatterId FROM @Payments))

			END					

			IF (SELECT count(*) FROM @Payments WHERE RequestType = 'Cancellation') > 0 BEGIN
				INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, Created, CreatedBy)
				SELECT m.MatterId, m.MatterStatusCodeId, getdate(), @UserId
				FROM tblMatter m WHERE m.MatterTypeId = 4 
				and m.MatterId IN (SELECT MatterId FROM @Payments)

				declare cursor_CancelMatter cursor for
				select MatterId from @Payments WHERE RequestType = 'Cancellation' order by MatterId

				open cursor_CancelMatter

				fetch next from cursor_CancelMatter into @MatterId
				while @@fetch_status = 0 begin
					exec [stp_DeleteCancellationMatter] @MatterId
					fetch next from cursor_CancelMatter into @MatterId
				end

				close cursor_CancelMatter
				deallocate cursor_CancelMatter
			END

			DELETE FROM @Payments;

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



