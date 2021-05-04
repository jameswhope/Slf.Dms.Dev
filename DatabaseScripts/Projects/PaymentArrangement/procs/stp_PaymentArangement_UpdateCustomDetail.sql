IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_UpdateCustomDetail')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_UpdateCustomDetail
	END

GO

CREATE PROCEDURE stp_PaymentArrangement_UpdateCustomDetail
(
@PADetailId	int,
@PaymentDueDate datetime,
@PaymentAmount	money, 
@userid			int
)
AS
BEGIN
	Update tblPACAlcDetail set 
	lastmodified = getdate(),
	lastmodifiedby = @userid,
	paymentduedate = @PaymentDueDate,
	paymentamount = @PaymentAmount
	Where padetailid = @PADetailId 
END
