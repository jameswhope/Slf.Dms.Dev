IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getLeadDepositAnalysis')
	BEGIN
		DROP  Procedure  stp_enrollment_getLeadDepositAnalysis
	END

GO

CREATE procedure [dbo].[stp_enrollment_getLeadDepositAnalysis]
@fromdate datetime, 
@todate datetime,
@agencyid int = -1
As
begin

--Detals
select 
l.leadapplicantid,
p.firstname + ' ' + p.lastname as [clientname],
m.ShortCoName as [lawfirm],
convert(varchar(10),l.created,101) as [leadcreated], 
convert(varchar(10),c.created,101) as [clientcreated], 
pr.productcode,
isnull(l.sourcecampaign,'') as [sourcecampaign],
ls.[name] as [Source],
[debtcount] = (select count(*) from tblLeadCreditorInstance where leadapplicantid = l.leadapplicantid),
[debtamount] = (select sum(balance) from tblLeadCreditorInstance where leadapplicantid = l.leadapplicantid), 
initialdraftdate as [FirstDeposit],
depositamount = (select top 1 depositamount from tblclientdepositday where deleteddate is null and clientid = vw.clientid),
depositday = (select top 1 depositday from tblclientdepositday where deleteddate is null and clientid = vw.clientid),
depositmethod = (select top 1 depositmethod from tblclientdepositday where deleteddate is null and clientid = vw.clientid),
[gooddepositscount] = (select count(*) from tblregister where entrytypeid = 3 and bounce is null and void is null and clientid = vw.clientid),
[totalgooddeposits] = (select coalesce(sum(amount),0) from tblregister where entrytypeid = 3 and bounce is null and void is null and clientid = vw.clientid),
[bonceddepositscount] = (select count(*) from tblregister where entrytypeid = 3 and bounce is not null and clientid = vw.clientid),
[totalbounceddeposits] = (select coalesce(sum(amount),0) from tblregister where entrytypeid = 3 and bounce is not null and clientid = vw.clientid),
[totalinitialfees] = (select abs(coalesce(sum(amount) ,0)) from tblregister where bounce is null and void is null and entrytypeid between 50 and 57 and clientid = vw.clientid and c.currentclientstatusid = 14),
[paidinitialfees] = (select coalesce(sum(p.amount) ,0) from tblregisterpayment p where p.voided = 0 and p.bounced = 0 and p.feeregisterid in (select registerid from tblregister where entrytypeid between 50 and 57 and clientid = vw.clientid and c.currentclientstatusid = 14)),
c.AgentName as [agent],
cs.[name] as [status]
into #analysisdetail
from tblleadapplicant l
inner join vw_leadapplicant_client vw on vw.leadapplicantid = l.leadapplicantid
inner join tblclient c on c.clientid = vw.clientid
inner join tblleadsources ls on ls.leadsourceid = l.leadsourceid
inner join tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
inner join tblleadproducts pr on l.productid = pr.productid 
inner join tblleadvendors v on v.vendorid = pr.vendorid
inner join tblperson p on p.personid = c.primarypersonid
inner join tblcompany m on m.companyid = c.companyid
where 
c.created between @fromdate and @todate
and c.accept = 1
and (v.Internal = 0) 
and (v.AgencyID = @agencyid or IsNull(@agencyid,-1) < 1)

--By Month

Select 
[YearMonth] = convert(varchar(7),cast(a.clientcreated as datetime),111),
[ClientCount] = count(a.leadapplicantid),
[AvgDebtCount] = AVG(a.debtcount),
[AvgDebtAmount] = AVG(a.debtamount),
[AvgDepositAmount] = AVG(a.depositamount),
[TotalFeeOwedLeft] = SUM(a.totalinitialfees - a.paidinitialfees),
[PctClearDeposits] = (cast(SUM(case when a.gooddepositscount > 0 then 1 else 0 end) as float) / NULLIF(COUNT(*),0)),
[PctActive] = (cast(SUM(case when Lower(a.[status]) = 'active' then 1 else 0 end) as float) / NULLIF(COUNT(*),0))
from #analysisdetail a
Group by convert(varchar(7),cast(a.clientcreated as datetime),111)
Order by 1 desc

--By Day

Select 
[ClientCreated] = a.clientcreated,
[YearMonth] = convert(varchar(7),cast(a.clientcreated as datetime),111),
[ClientCount] = count(a.leadapplicantid),
[AvgDebtCount] = AVG(a.debtcount),
[AvgDebtAmount] = AVG(a.debtamount),
[AvgDepositAmount] = AVG(a.depositamount),
[TotalFeeOwedLeft] = SUM(a.totalinitialfees - a.paidinitialfees),
[PctClearDeposits] = (cast(SUM(case when a.gooddepositscount > 0 then 1 else 0 end) as float) / NULLIF(COUNT(*),0)),
[PctActive] = (cast(SUM(case when Lower(a.[status]) = 'active' then 1 else 0 end) as float) / NULLIF(COUNT(*),0))
from #analysisdetail a
Group by a.clientcreated, convert(varchar(7),cast(a.clientcreated as datetime),111)

--Total
select a.* from #analysisdetail a
order by a.clientcreated

drop table #analysisdetail 

end


