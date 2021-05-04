
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_DeleteCalculatorSession')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_DeleteCalculatorSession
	END

GO

CREATE PROCEDURE stp_PaymentArrangement_DeleteCalculatorSession
(
@PASessionID int,
@userid	 int
)
AS
BEGIN

	update tblPACAlcdetail set 
	deleted = GetDate(),
	deletedby = @userid
	Where pasessionid  = @PASessionID
	
	update tblPACAlc set 
	deleted = GetDate(),
	deletedby = @userid
	Where pasessionid  = @PASessionID
	
END





