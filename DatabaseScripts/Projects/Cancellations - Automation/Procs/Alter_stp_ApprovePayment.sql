IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ApprovePayment')
	BEGIN
		DROP  Procedure  stp_ApprovePayment
	END

GO

CREATE Procedure stp_ApprovePayment
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
				IsApproved = 1,
				LastModified = getdate(),
				LastModifiedBy = @UserId,
				CheckNumber = a.CheckNumber
			FROM tblAccount_PaymentProcessing acc inner join
			(SELECT 
					ParamValues.ParamId.value('@PaymentId','int') AS PaymentId, 	
					ParamValues.ParamId.value('@CheckNumber','int')	AS CheckNumber
			 FROM 
					@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId)) a ON a.PaymentId = acc.PaymentProcessingId

			UPDATE tblMatter SET
				MatterStatusId = 3,
				MatterSubStatusId = (CASE 
									WHEN acc.DeliveryMethod = 'C' THEN 63
									WHEN acc.DeliveryMethod = 'P' THEN 66
									WHEN acc.DeliveryMethod = 'E' THEN 68
									ELSE 0
								  END),
				MatterStatusCodeId = (CASE 
									WHEN acc.DeliveryMethod = 'C' THEN 35
									WHEN acc.DeliveryMethod = 'P' THEN 39
									WHEN acc.DeliveryMethod = 'E' THEN 40
									ELSE 0
								  END)
				FROM tblMatter m Inner Join
				tblAccount_PaymentProcessing acc ON acc.MatterId = m.MatterId and
				acc.PaymentProcessingId IN 
					(SELECT 
						ParamValues.ParamId.value('@PaymentId','int')			
					 FROM 
						@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))

			INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, Created, CreatedBy)
			SELECT s.SettlementId, m.MatterStatusCodeId, getdate(), @UserId
			FROM tblAccount_PaymentProcessing acc inner join
			tblMatter m ON m.MatterId = acc.MatterId and m.MatterTypeId = 3 left join
			tblSettlements s ON s.MatterId = m.MatterId
			WHERE acc.PaymentProcessingId IN 
				(SELECT 
					ParamValues.ParamId.value('@PaymentId','int')			
				 FROM 
					@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))
					
			INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState, 
								DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail, PayableTo, AttentionTo, 
								ContactName)
				SELECT m.MatterId, sd.[Address], sd.City, sd.[State], sd.Zip, sd.ContactNumber, NULL, sd.EmailAddress, 
							(case when sd.PayableTo is null or len(sd.PayableTo) = 0 Then cr.[Name] else sd.PayableTo end),
							 sd.AttentionTo, sd.ContactName
				FROM tblAccount_PaymentProcessing acc inner join
					 tblMatter m ON m.MatterId = acc.MatterId and m.MatterTypeId = 3 and not exists(SELECT 1 FROM
								tblAccount_DeliveryInfo WHERE MatterId = m.MatterId) left join 
					 tblSettlements s ON s.MatterId = m.MatterId left join
					 tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId left join
					 tblAccount a ON a.AccountId = s.CreditorAccountId left join
					 tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId left join
					 tblCreditor cr ON cr.CreditorId = ci.CreditorId
				WHERE acc.PaymentProcessingId IN 
						(SELECT 
							ParamValues.ParamId.value('@PaymentId','int')			
						 FROM 
							@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId)) 
					  

			INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, Created, CreatedBy)
			SELECT acc.MatterId, m.MatterStatusCodeId, getdate(), @UserId
			FROM tblAccount_PaymentProcessing acc inner join
			tblMatter m ON m.MatterId = acc.MatterId and m.MatterTypeId = 4 
			WHERE acc.PaymentProcessingId IN 
				(SELECT 
					ParamValues.ParamId.value('@PaymentId','int')			
				 FROM 
					@ApproveXml.nodes('/Payments/Payment') AS ParamValues(ParamId))

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



