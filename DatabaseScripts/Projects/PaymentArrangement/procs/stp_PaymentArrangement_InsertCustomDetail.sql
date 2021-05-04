IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_InsertCustomDetail')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_InsertCustomDetail
	END

GO

CREATE PROCEDURE stp_PaymentArrangement_InsertCustomDetail
(
@PASessionId	int,
@PaymentDueDate datetime,
@PaymentAmount	money, 
@userid			int
)
AS
BEGIN
	insert into tblPACAlcDetail (createdby,lastmodifiedby,pasessionid,paymentduedate,paymentamount)
	values (@userid,@userid,@PASessionId,@PaymentDueDate,@PaymentAmount)

	select scope_identity()
END


 


