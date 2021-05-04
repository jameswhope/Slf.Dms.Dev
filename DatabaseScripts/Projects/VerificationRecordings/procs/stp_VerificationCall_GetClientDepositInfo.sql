IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_GetClientData2')
	BEGIN
		DROP  Procedure  stp_VerificationCall_GetClientData2
	END

GO

CREATE Procedure stp_VerificationCall_GetClientData2
@ClientID int
AS
BEGIN

declare 
@totaldebt money,
@depositamount money,
@depositday varchar(100),
@depositmethod varchar(20),
@maintenancefee money,
@settfeepct decimal,
@bankaccountnumber varchar(100),
@bankname varchar(255)

select @totaldebt = sum(a.currentamount) from tblaccount a where a.clientid = @clientid and a.accountstatusid not in (54,55) and a.removed is null

if (exists(select clientid from tblclient where multideposit = 1 and clientid  = @clientid))
	begin
		select @maintenancefee =  monthlyfee, @settfeepct = SettlementFeePercentage*100	from tblclient where clientid = @clientid
		Select @depositamount = sum(d.DepositAmount) From tblClientDepositDay d Where d.DeletedDate is Null and d.ClientId=@ClientId
		
		Select top 1 @depositmethod =  depositmethod, @bankaccountnumber=b.accountnumber,@bankname=rn.customername From tblClientDepositDay d 
		left join tblclientbankaccount b on b.bankaccountid = d.bankaccountid
		left join tblroutingnumber rn on rn.routingnumber = b.routingnumber
		Where d.DeletedDate is Null and d.ClientId=@ClientId
		
		select @depositday = (Select convert(varchar,d.DepositDay) + ',' From tblClientDepositDay d Where d.DeletedDate is Null and d.ClientId=@ClientId FOR XML PATH(''))
		
	end
else
	select @depositday = convert(varchar,isnull(depositday,1)), @depositamount = depositamount, @depositmethod = depositmethod, @maintenancefee =  monthlyfee, @settfeepct = SettlementFeePercentage*100, @bankaccountnumber = bankaccountnumber, @bankname = bankname
	from tblclient
	where clientid = @clientid
	
Select 
[TotalDebt] = @totaldebt,
[MonthlyDepositAmount] = @depositamount,
[DepositMethod] = @depositmethod,
[DepositDay] = @depositday,
[MaintenanceFee] = @maintenancefee,
[SettlementFeePct] = @settfeepct,
[BankAccountNumber] = @bankaccountnumber,
[BankName] = @bankname

END

