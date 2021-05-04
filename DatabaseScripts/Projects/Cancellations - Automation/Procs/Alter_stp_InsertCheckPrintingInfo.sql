IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCheckPrintingInfo')
	BEGIN
		DROP  Procedure  stp_InsertCheckPrintingInfo
	END

GO

CREATE Procedure [dbo].[stp_InsertCheckPrintingInfo]
(
@MatterId INT,
@BatchId INT,
@isPrinted BIT,
@CheckNumber INT,
@UserId INT,
@DateString nvarchar(6),
@DocId nvarchar(15),
@SubFolder nvarchar(150) = null,
@DocTypeId nvarchar(20)
)

AS
BEGIN
	DECLARE @Return INT
			,@InTran BIT			
			,@Note VARCHAR(MAX)
			,@ClientId INT
			,@MatterTypeId INT
			,@AccountId INT
			,@UserName VARCHAR(50)
			,@NoteId INT
			,@SettlementId INT
			,@CreditorName VARCHAR(100);
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @UserId);
		   
	SELECT @ClientId = m.ClientId, @AccountId = ci.AccountId, @MatterTypeId = m.MatterTypeId, @CreditorName = cr.[Name]
	FROM tblMatter m left join
	tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId left join
	tblCreditor cr ON cr.CreditorId = ci.CreditorId
	WHERE m.MatterId = @MatterId ;
	
	IF @MatterTypeId = 3 BEGIN
		SELECT @SettlementId = SettlementId FROM tblSettlements WHERE MatterId = @MatterId;
	END
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY
			/**********  Start Region to assign relations to Settlement Chcek document     **********/
			INSERT INTO tblDocScan(DocId, ReceivedDate, Created, CreatedBy)
			VALUES(@DocId, getdate(), getdate(), @UserId)
			
			UPDATE tblAccount_PaymentProcessing SET 
					CheckNumber = @CheckNumber
				WHERE MatterId = @MatterId;
	
			/**********  End Region to assign relations to Settlement Chcek document     **********/
			
			IF @isPrinted = 1 BEGIN
				UPDATE tblMatter SET MatterStatusId = 3,
									 MatterStatusCodeId = 36,
									 MatterSubStatusId = 64
				WHERE MatterId = @MatterId

				UPDATE tblAccount_PaymentProcessing SET 
					BatchId = @BatchId,
					ProcessedDate = getdate(),
					IsCheckPrinted = 1,
					LastModifiedBy = @UserId,
					LastModified = getdate()
				WHERE MatterId = @MatterId;

				SELECT @Note = (@UserName + ' successfully printed a check for amount ' + convert(varchar(20),CheckAmount) +' on ' + convert(varchar(20),getdate()))
				FROM tblAccount_PaymentProcessing WHERE MatterId = @MatterId;

				EXEC @Return = [stp_InsertNoteForSettlementMatter] @ClientId, @MatterId, @AccountId, @UserId, null, @Note, 
							@DocTypeId, @DocId, @DateString, @SubFolder, @NoteId output;

				IF @MatterTypeId = 3 BEGIN
					INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
					VALUES(@SettlementId, 36, @NoteId, @UserId, getdate())
				END
				ELSE IF @MatterTypeId = 4 BEGIN
					INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
					VALUES(@MatterId, 36, @UserId, getdate())
				END
			END

			INSERT INTO tblSettlement_CheckPrint(MatterId, BatchId, PrintedBy, PrintedDate, IsPrinted)
			VALUES( @MatterId, @BatchId, @UserId, getdate(), @isPrinted)			

			IF @MatterTypeId = 3 BEGIN
				if not exists (SELECT 1 FROM tblAccount_DeliveryInfo WHERE MatterId = @MatterId) begin
					INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState, 
									DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail, PayableTo, AttentionTo, 
									ContactName)
					SELECT @MatterId, sd.[Address], sd.City, sd.[State], sd.Zip, sd.ContactNumber, NULL, sd.EmailAddress, 
								(case when sd.PayableTo is null or len(sd.PayableTo) = 0 Then @CreditorName else sd.PayableTo end),
								 sd.AttentionTo, sd.ContactName
					FROM tblSettlements_DeliveryAddresses sd
				end
			
			END
			
			IF @InTran = 0 BEGIN
				IF @Return = 0 COMMIT ELSE ROLLBACK
			END
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



