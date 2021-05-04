IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_nondeposit')
	BEGIN
		DROP  Procedure  stp_nondeposit
	END

GO

CREATE Procedure stp_nondeposit
@daycount int,
@nodep bit,
@companies varchar(255) = null
As
Begin

Select @companies = isnull(@companies, '')

Declare @Where varchar(max)

Select @Where = ' AND (c.DepositStartDate is Null or c.DepositStartDate <= dateadd(day, -convert(int,' + convert(varchar, @daycount) + '), getdate()))'

if @nodep = 0
	Select @Where = @Where + ' OR dateadd(day, -convert(int,' + convert(varchar, @daycount) + '), getdate()) > d.maxdate) '
Else
	Select @Where = @Where + ') '

if @companies <> ''
	Select @Where = @Where + ' And c.companyid In (' + @companies + ') '

Exec ('SELECT c.clientid, 
	   a.name as [Agency],
	   c.Accountnumber, 
	   p.Firstname, p.Lastname, 
	   co.shortCoName as [LawFirm], 
	   DepositStartDate = convert(varchar,c.DepositStartDate, 110), 
	   DepositDayAmountMethod = Case When c.MultiDeposit = 0 Then cast(c.depositday as varchar) + ''/ $'' + cast(c.DepositAmount as varchar) + ''/ '' + c.DepositMethod 
	   Else (select distinct cast(cd.depositday as varchar) + ''/ $'' + cast(cd.DepositAmount as varchar) + ''/ '' + cd.DepositMethod +  '', '' 
	   from tblclientDepositDay cd where cd.clientid = c.clientid and cd.deleteddate is null For XML Path('''')) 
	   End, 
	   DepositCount = isnull(d.countR, 0),
	   ClearedCount = (Select count(registerid) from tblregister r where entrytypeid = 3 and clientid = c.clientid and (r.clear is not null or hold is null or (r.clear is null and r.hold <= getdate())) and (r.bounce is null)), 
	   LastDep = convert(varchar,d.maxdate, 110),
	   bounce = case when (select top 1 bounce from tblregister where registerid = d.maxregisterid) is null then '' '' else ''X'' end, 
	   d.maxregisterid as LastDepId, 
	   daysSince = datediff(day, d.maxdate, getdate()),
	   ActiveDate = convert(varchar,(Select max(Created) from tblroadmap where clientstatusid = 14 and clientid = c.clientid), 110)
FROM tblClient c 
INNER JOIN tblPerson p ON c.primarypersonid = p.personid 
INNER JOIN tblCompany co on co.CompanyId = c.companyid 
INNER JOIN tblAgency a ON c.agencyid = a.agencyid
left join 
(Select count(r.registerid) as CountR, max(r.transactiondate) as maxdate, max(registerid) as maxregisterid, r.clientid 
from tblregister r 
where r.entrytypeid = 3 
group by clientid) d on c.clientid = d.clientid
where c.currentclientstatusid in (10,14) 
and (isnull(d.countR,0) = 0 ' + @Where )		

End

Go
