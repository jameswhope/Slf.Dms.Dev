IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CollectGCACredits')
	BEGIN
		DROP  Procedure  stp_CollectGCACredits
	END
GO

CREATE Procedure [dbo].[stp_CollectGCACredits]
as

insert tblNachaRegister2 (
	   Name,AccountNumber,RoutingNumber,[Type],Amount,IsPersonal,CompanyID,ShadowStoreID,ClientID,TrustID,RegisterID,RegisterPaymentID,Flow)
select 
	   Name,AccountNumber,RoutingNumber,[Type],Amount,IsPersonal,CompanyID,ShadowStoreID,ClientID,TrustID,RegisterID,RegisterPaymentID,Flow
from (
	select r.display[name],r.accountnumber,r.routingnumber,isnull(r.[type],'C')[type],rp.amount,0[ispersonal],n.companyid,n.shadowstoreid,n.clientid,n.trustid,n.registerid,n.registerpaymentid,'credit'[flow]
	from tblnacharegister2 n
	join vw_ClientTrustConvDate t on t.clientid = n.clientid
		and t.trustid = n.trustid
		and t.origtrustid = 20
	join vw_ClientCompanyConvDate c on c.clientid = n.clientid
		and c.companyid = n.companyid
	join tblcommrec r on r.companyid = c.origcompanyid
		and r.istrust = 1
	join tblregisterpayment rp on rp.registerpaymentid = n.registerpaymentid 
		and rp.voided = 1
		and rp.paymentdate < t.converted
	where n.flow = 'credit'
	and n.registerpaymentid not in (
		select registerpaymentid
		from tblnacharegister2
		where flow = 'debit'
		and registerpaymentid > 0
	)
) d
where not exists (select 1 from tblnacharegister2 nr2 where nr2.name = d.name 
		and nr2.registerpaymentid = d.registerpaymentid	
		and nr2.flow = d.flow)