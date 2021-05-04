 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_InsertCalculatorSession')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_InsertCalculatorSession
	END

GO

CREATE PROCEDURE stp_PaymentArrangement_InsertCalculatorSession
(
@ClientID                            int,
@AccountID                           int,
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
	select pasessionid 
	into #calcids
	from tblPACAlc where deleted is null and clientid = @ClientID and accountid = @AccountID 
	--Delete previous calculators
	update tblPACAlcdetail set 
	deleted = GetDate(),
	deletedby = @userid
	Where pasessionid  in (select pasessionid from #calcids)
	update tblPACAlc set 
	deleted = GetDate(),
	deletedby = @userid
	Where pasessionid  in (select pasessionid from #calcids)
	--Insert New Calculator
	drop table #calcids
	insert into tblPACAlc	(createdby,lastmodifiedby,clientid,
							accountid,settlementamount,startdate,
							plantype,lumpsumamount,installmentmethod,
							installmentamount,installmentcount)
	values (@userid,@userid,@ClientID,
			@AccountID,@SettlementAmount,@StartDate,
			@PlanType,@LumpSumAmount,@InstallmentMethod,
			@InstallmentAmount,@InstallmentCount)

	select scope_identity()
END


GO

GRANT EXEC ON stp_paymentarrangement_InsertUpdate TO PUBLIC

GO


