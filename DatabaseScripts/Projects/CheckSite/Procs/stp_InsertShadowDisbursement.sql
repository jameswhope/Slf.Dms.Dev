
if exists (select * from sysobjects where name = 'stp_InsertShadowDisbursement')
	drop procedure stp_InsertShadowDisbursement
go


CREATE PROCEDURE [dbo].[stp_InsertShadowDisbursement]
( 
	@RegisterID int,
	@Amount money
)
as
begin
-- shadow store -> disbusement account

declare @Name varchar(30), @TrustID int

select @TrustID = TrustID, @Name = [Name]
from tblTrust
where TrustID = 23


insert tblNachaRegister2 (NachaFileId, [Name], Amount, IsPersonal, CompanyID, ShadowStoreId, ClientID, TrustId, RegisterID, Created, Flow)
select -1, @Name, abs(@Amount), 0, c.CompanyID, c.AccountNumber, c.ClientID, c.TrustId, r.RegisterID, getdate(), 'debit'
from tblregister r
join tblclient c on c.clientid = r.clientid
where registerid = @RegisterID


end