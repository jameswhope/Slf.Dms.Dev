 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_UpdateCalculatorSession')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_UpdateCalculatorSession
	END

GO

CREATE PROCEDURE stp_PaymentArrangement_UpdateCalculatorSession
(
@PASessionID                       int,
@SettlementAmount				     money,
@StartDate                           datetime = null,
@PlanType                            int,
@LumpSumAmount                       money = null,
@InstallmentMethod					 int = null,
@InstallmentAmount					 money = null,
@InstallmentCount					 int = null,
@userid	                             int
)
AS
BEGIN
	Update tblPACAlc Set
	lastmodified = GetDate(),
	lastmodifiedby = @userid,
	SettlementAmount = @SettlementAmount,
	StartDate = @StartDate,
	PlanType = @PlanType,
	LumpSumAmount = @LumpSumAmount,
	InstallmentMethod = @InstallmentMethod,
	InstallmentAmount = @InstallmentAmount,
	InstallmentCount = @InstallmentCount
	Where pasessionid = @PASessionID
END


GO

GRANT EXEC ON stp_paymentarrangement_InsertUpdate TO PUBLIC

GO


