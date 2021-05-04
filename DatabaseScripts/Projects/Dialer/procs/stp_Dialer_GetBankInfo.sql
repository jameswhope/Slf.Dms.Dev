IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetBankInfo')
	BEGIN
		DROP  Procedure  stp_Dialer_GetBankInfo
	END

GO

CREATE Procedure stp_Dialer_GetBankInfo
@ClientId int
AS
select BankName = isnull(BankName,''), BankRoutingNumber = isnull(BankRoutingNumber,''), BankAccountNumber = isnull(BankAccountNumber,''), BankType= Case When lower(BankType) = 's' Then 'Saving' else 'Checking' end from tblclient 
where clientid = @ClientId and  multideposit = 0 
UNION  
select isnull(br.customername,''), isnull(ba.routingnumber,''), isnull(ba.accountnumber,''), Case When lower(ba.BankType) = 's' Then 'Saving' else 'Checking' end from tblclientbankaccount ba
Left join tblroutingnumber br on br.routingnumber = ba.routingnumber
where ba.disabled is null
and ba.clientid = @ClientId

GO

 
