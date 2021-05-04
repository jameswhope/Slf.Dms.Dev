IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCheckPrintingInfo')
	BEGIN
		DROP  Procedure  stp_InsertCheckPrintingInfo
	END

GO

--the xml is of the form <Checks><Check SettlementID = "123"  PrintedBy = "234" Printed = "06/14/2010" IsPrinted="0"/><Settlement id = "234" /></Checks>

CREATE Procedure [dbo].[stp_InsertCheckPrintingInfo]
(
@PaymentProcessingId Int,
@MatterId INT,
@BatchId INT,
@isPrinted BIT,
@CheckNumber INT,
@UserId INT,
@DateString nvarchar(6),
@DocId nvarchar(15),
@SubFolder nvarchar(150)
)

AS
BEGIN
	DECLARE @Return INT
			,@InTran BIT			
			,@Note VARCHAR(MAX)
			,@ClientId INT
			,@AccountId INT
			,@UserName VARCHAR(50)
			,@NoteId INT
			,@SettlementId INT;
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @UserId);
		   
	SELECT @ClientId = m.ClientId, @AccountId = ci.AccountId
	FROM tblMatter m inner join
	tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId
	WHERE m.MatterId = @MatterId ;

	SELECT @SettlementId = SettlementId FROM tblSettlements WHERE MatterId = @MatterId;
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY
			/**********  Start Region to assign relations to Settlement Chcek document     **********/
			INSERT INTO tblDocScan(DocId, ReceivedDate, Created, CreatedBy)
			VALUES(@DocId, getdate(), getdate(), @UserId)

			INSERT INTO tblDocRelation(ClientId, RelationId, RelationType, DocTypeId, DocId, DateString, SubFolder, RelatedDate, RelatedBy, DeletedFlag)
			VALUES(@ClientId, @AccountId, 'account', 'D9011', @DocId, @DateString, @SubFolder, getdate(), @UserId, 0);

			UPDATE tblAccount_PaymentProcessing SET 
					CheckNumber = @CheckNumber
				WHERE PaymentProcessingId = @PaymentProcessingId;
	
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
				WHERE PaymentProcessingId = @PaymentProcessingId;
			END

			INSERT INTO tblSettlement_CheckPrint(MatterId, BatchId, PrintedBy, PrintedDate, IsPrinted)
			VALUES( @MatterId, @BatchId, @UserId, getdate(), @isPrinted)

			SELECT @Note = (@UserName + ' successfully printed a settlement check for amount ' + convert(varchar(20),CheckAmount) +' on ' + convert(varchar(20),getdate()))
				FROM tblAccount_PaymentProcessing WHERE PaymentProcessingId = @PaymentProcessingId;

			EXEC @Return = [stp_InsertNoteForSettlementMatter] @ClientId, @MatterId, @AccountId, @UserId, null, @Note, 
							'D9011', @DocId, @DateString, @SubFolder, @NoteId output;

			INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
				VALUES(@SettlementId, 36, @NoteId, @UserId, getdate())
			
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


