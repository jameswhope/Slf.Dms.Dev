 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PayExtraFees2TSLF')
	BEGIN
		DROP  Procedure  stp_PayExtraFees2TSLF
	END

GO

CREATE Procedure stp_PayExtraFees2TSLF
@PayFromCommRecID int
,@PayToCommRecID int
,@RunByUserID int = 28
,@RunDate datetime
AS
BEGIN  

DECLARE @transid int
	,@BalDue decimal(18,2)
	,@OriginalAmount decimal(18,2)
	,@TransactionAmount decimal(18,2)
	,@ReferenceTable nvarchar(25)
	,@NewTransactionID int
	,@NewCommRecID int
	,@NewCommRecName nvarchar(255)
	,@NewCommRecAcct bigint
	,@NewCommRecRoute int
	,@NewCommRecType nvarchar(2)
	,@CompanyId int
	,@NRComRecId int
	,@TrustId int
	,@ErrorMessage nvarchar(MAX) 
	,@ErrorSeverity int 
	,@ErrorState int
	


SET @BalDue = (SELECT TOP(1) BalanceDue FROM tblTMLF2TSLF ORDER BY RecordID DESC)
SELECT @NewCommRecID = @PayTocommRecID
	, @NewCommRecName = Display
	, @NewCommRecAcct = AccountNumber
	, @NewCommRecRoute = RoutingNumber
	, @NewCommRecType = case when [Type] is null then 'C' else [Type] end
FROM tblCommRec where CommRecID = @PayToCommRecID

IF @BalDue > 0
BEGIN -- IF STMT
	DECLARE ModTrans_nr2 CURSOR FOR 
	SELECT NachaRegisterID 
		FROM tblNachaRegister2 
		WHERE COMMRECID =  @PayFromCommRecID 
		AND NACHAFILEID = -1 
		AND ACCOUNTNUMBER = (SELECT ACCOUNTNUMBER FROM TBLCOMMREC WHERE COMMRECID = @PayFromCommRecID) 
		--AND NOTES is null
		AND AMOUNT > 0
		AND CREATED >= '2014-01-01'
		ORDER BY NachaRegisterID 

	OPEN ModTrans_nr2

	FETCH NEXT FROM ModTrans_nr2 INTO @transid
	WHILE @@FETCH_STATUS = 0
	BEGIN -- CURSOR
		BEGIN TRY
		BEGIN TRANSACTION tx_ModRecord_nr2
			SET @ReferenceTable = 'tblNachaRegister2'
			SELECT @OriginalAmount = amount, @CompanyId = Companyid, @TrustId = TrustId from tblNachaRegister2 where nacharegisterid = @transid
			IF @OriginalAmount > @BalDue
				BEGIN
					SET @TransactionAmount = @BalDue*-1
					INSERT INTO tblTMLF2TSLF (TransactionDate, TransactionType,RefTable,RefTableID,OriginalCommRecID,OriginalAmount,NewAmount,TransactionAmount,BalanceDue,PaidtoCommRecID,CreatedBy)
					SELECT Created, 'Payment', @ReferenceTable, @transid, CommRecID, Amount,@OriginalAmount+@TransactionAmount,@TransactionAmount,@BalDue, @newCommRecID,@RunByUserID from tblNachaRegister2 where NachaRegisterID = @transId
					SET @NewTransactionID = scope_identity()
					UPDATE tblTMLF2TSLF SET BalanceDue = BalanceDue+TransactionAmount where RecordID = @NewTransactionID
					UPDATE tblNachaRegister2 SET Amount = @OriginalAmount+@TransactionAmount, NOTES = 'MODIFIED: SEE tblTMLF2TSLF' WHERE nacharegisterid = @transid
					INSERT INTO tblNachaRegister2 (NachaFileID,CompanyId,Created,flow,commrecid,Name,AccountNumber,RoutingNumber, Notes, Amount, IsPersonal, TrustId, IsAttorney, [Type])
						values (-1,@CompanyId,@RunDate,'debit',@NewCommRecID, @newCommRecName,@newCommRecAcct, @NewCommRecRoute, 'INSERTED BY TMLF2TSLF PROC', abs(@TransactionAmount), 0, @TrustId, 0, @NewCommRecType)
					SET @BalDue = (SELECT TOP(1) BalanceDue FROM tblTMLF2TSLF ORDER BY RECORDID DESC)
				END
			ELSE
				BEGIN -- tblNachaRegister2 amount <= the amount owed to TSLF
					SET @TransactionAmount = @OriginalAmount*-1
					INSERT INTO tblTMLF2TSLF (TransactionDate, TransactionType,RefTable,RefTableID,OriginalCommRecID,OriginalAmount,NewAmount,TransactionAmount,BalanceDue,PaidtoCommRecID,CreatedBy)
						SELECT Created, 'Payment', @ReferenceTable, @transid, CommRecID, Amount,0,@TransactionAmount,@BalDue, @newCommRecID,@RunByUserID from tblNachaRegister2 where NachaRegisterID = @transId
					SET @NewTransactionID = scope_identity()
					UPDATE tblTMLF2TSLF SET BalanceDue = BalanceDue+TransactionAmount where RecordID = @NewTransactionID
					UPDATE tblNachaRegister2 SET CommRecID = @newCommRecID, name=@newCommRecName, AccountNumber = @newCommRecAcct, RoutingNumber = @NewCommRecRoute, NOTES = 'MODIFIED: SEE tblTMLF2TSLF' WHERE nacharegisterid = @transid
				END
		COMMIT TRANSACTION tx_ModRecord_NR2
		SET @BalDue = (SELECT TOP(1) BalanceDue FROM tblTMLF2TSLF ORDER BY RECORDID DESC)
		IF @BalDue = 0 
			BREAK;
		END TRY
		BEGIN CATCH
			SELECT @ErrorSeverity = ERROR_SEVERITY(),@errorState = ERROR_STATE(), @ErrorMessage = ERROR_MESSAGE() 

			if @@TRANCOUNT > 0
				ROLLBACK TRANSACTION tx_ModRecord_nr2;
				
			CLOSE ModTrans_nr2;
			DEALLOCATE ModTrans_nr2;

			RAISERROR(@errorMessage, @errorSeverity, @errorState) 
			RETURN -1
		END CATCH;

	FETCH NEXT FROM ModTrans_nr2 INTO @transid

	END -- CURSOR
	CLOSE ModTrans_nr2;
	DEALLOCATE ModTrans_nr2;
END -- IF STMT

SET @BalDue = (SELECT TOP(1) BalanceDue FROM tblTMLF2TSLF ORDER BY RecordID DESC)

IF @BalDue > 0
BEGIN -- IF STMT
	DECLARE ModTrans_nr CURSOR FOR 
	SELECT NachaRegisterID 
		FROM tblNachaRegister 
		WHERE NACHAFILEID  is null
		AND ACCOUNTNUMBER = (SELECT ACCOUNTNUMBER FROM TBLCOMMREC WHERE COMMRECID = @PayFromCommRecID) 
		--AND NOTES is null
		AND AMOUNT > 0
		AND CREATED >= '2014-01-01'
		ORDER BY NachaRegisterID
		
	OPEN ModTrans_nr

	FETCH NEXT FROM ModTrans_nr INTO @transid
	WHILE @@FETCH_STATUS = 0
	BEGIN -- CURSOR
		BEGIN TRY
		BEGIN TRANSACTION tx_ModRecord_nr
			SET @ReferenceTable = 'tblNachaRegister'
			SELECT @OriginalAmount = amount, @CompanyId = CompanyId, @NRComRecId = CommRecId from tblNachaRegister where nacharegisterid = @transid
			IF @OriginalAmount > @BalDue
				BEGIN
					SET @TransactionAmount = @BalDue*-1
					INSERT INTO tblTMLF2TSLF (TransactionDate, TransactionType,RefTable,RefTableID,OriginalCommRecID,OriginalAmount,NewAmount,TransactionAmount,BalanceDue,PaidtoCommRecID,CreatedBy)
					SELECT Created, 'Payment', @ReferenceTable, @transid, CommRecID, Amount,@OriginalAmount+@TransactionAmount,@TransactionAmount,@BalDue, @NewCommRecID,@RunByUserID from tblNachaRegister where NachaRegisterID = @transId
					SET @NewTransactionID = scope_identity()
					UPDATE tblTMLF2TSLF SET BalanceDue = BalanceDue+TransactionAmount where RecordID = @NewTransactionID
					UPDATE tblNachaRegister SET Amount = @OriginalAmount+@TransactionAmount, NOTES = 'MODIFIED: SEE tblTMLF2TSLF' WHERE nacharegisterid = @transid
					INSERT INTO tblNachaRegister (NachaFileID,CompanyId,Created,Name,AccountNumber,RoutingNumber, Notes, Amount, [type], isPersonal,CommRecID, isDeclined, IsAttorney)
						values (NULL,@CompanyId,@RunDate,@newCommRecName,@newCommRecAcct, @NewCommRecRoute, 'INSERTED BY TMLF2TSLF PROC', abs(@TransactionAmount),@NewCommRecType,0,@NRComRecId,0,0)
				END
			ELSE
				BEGIN -- tblNachaRegister amount <= the amount owed to TSLF
					SET @TransactionAmount = @OriginalAmount*-1
					INSERT INTO tblTMLF2TSLF (TransactionDate, TransactionType,RefTable,RefTableID,OriginalCommRecID,OriginalAmount,NewAmount,TransactionAmount,BalanceDue,PaidtoCommRecID,CreatedBy)
						SELECT Created, 'Payment', @ReferenceTable, @transid, @PayFromCommRecID, Amount,0,@TransactionAmount,@BalDue, @newCommRecID,@RunByUserID from tblNachaRegister where NachaRegisterID = @transId
					SET @NewTransactionID = scope_identity()
					UPDATE tblTMLF2TSLF SET BalanceDue = BalanceDue+TransactionAmount where RecordID = @NewTransactionID
					UPDATE tblNachaRegister SET name=@newCommRecName, AccountNumber = @newCommRecAcct, RoutingNumber = @NewCommRecRoute, NOTES = 'MODIFIED: SEE tblTMLF2TSLF' WHERE nacharegisterid = @transid
					SET @BalDue = (SELECT TOP(1) BalanceDue FROM tblTMLF2TSLF ORDER BY RECORDID DESC)
				END
		COMMIT TRANSACTION tx_ModRecord_nr
		SET @BalDue = (SELECT TOP(1) BalanceDue FROM tblTMLF2TSLF ORDER BY RECORDID DESC)
		IF @BalDue = 0 
			BREAK;
		END TRY
		BEGIN CATCH
			SELECT @ErrorSeverity = ERROR_SEVERITY(),@errorState = ERROR_STATE(), @ErrorMessage = ERROR_MESSAGE() 

			if @@TRANCOUNT > 0
				ROLLBACK TRANSACTION tx_ModRecord_nr;
				
			CLOSE ModTrans_nr;
			DEALLOCATE ModTrans_nr;

			RAISERROR(@errorMessage, @errorSeverity, @errorState) 
			RETURN -1
		END CATCH;

	FETCH NEXT FROM ModTrans_nr INTO @transid
	
	END -- CURSOR
	CLOSE ModTrans_nr;
	DEALLOCATE ModTrans_nr;
END -- IF

END --PROC



