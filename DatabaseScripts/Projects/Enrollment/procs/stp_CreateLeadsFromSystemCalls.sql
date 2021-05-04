IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CreateLeadsFromSystemCalls')
	BEGIN
		DROP  Procedure  stp_CreateLeadsFromSystemCalls
	END

GO

CREATE Procedure stp_CreateLeadsFromSystemCalls
AS
BEGIN
declare @firstname nvarchar(100), @lastname nvarchar(100)
declare @leadphone nvarchar(20), @StateId int , @LeadSourceId int, @CompanyId int, @ProductID int
declare  @Cost money, @CallIdKey varchar(50), @repid int
declare @lastrun datetime

SELECT top 1 @lastrun = cast(stuff(stuff(stuff(convert(varchar,run_date)+right('0'+convert(varchar,run_time), 6),9,0,' '),12,0,':'),15,0,':') as datetime) 
FROM     msdb.dbo.sysjobhistory h 
         INNER JOIN msdb.dbo.sysjobs j ON h.job_id = j.job_id 
WHERE   j.[name] = 'Create Leads from System Calls'
and step_name = '(Job outcome)'
and run_status = 1
order by run_date desc, run_time  desc

declare new_leads_cursor cursor For
select  
'' as firstname, 
'' as lastname, 
right(c.remotenumberfmt, 14) as leadphone, 
isnull(w.stateid,0) as stateid, 
p.defaultsourceid , 
isnull(s.companyid,0) as companyid, 
p.productid, 
p.cost, 
d.callidkey
from "DMF-SQL-0001".I3_CIC.dbo.calldetail c
inner join tblcalldnis d on c.callid = d.callidkey
inner join tblleadproducts p on d.dnis = p.productcode
left join tblleadapplicant l on (l.callidkey = d.callidkey or right(c.remotenumberfmt, 14) = l.leadphone or right(c.remotenumberfmt, 14) = l.homephone or right(c.remotenumberfmt, 14) = l.cellphone)
left join vw_areacode_state w on w.areacode = c.remotenumberlocomp1
left join tblstate s on w.stateid = s.stateid
left join tblcalllog g on g.callidkey = d.callidkey and g.eventname = 'pickup'
where (c.stationid = 'system' or c.localname='system' or g.callidkey is null) 
and c.calldirection = 'inbound'
and c.initiateddate > dateadd(hour, -2, @lastrun)
and p.isdnis=1 and p.active=1
and cast(convert(varchar ,c.initiateddate, 110)  + ' ' + isnull(p.starttime,'12:00 AM') as datetime) < = c.initiateddate  and cast(convert(varchar ,c.initiateddate, 110)  + ' ' + isnull(p.endtime, '11:59:59.999 PM') as datetime) >  c.initiateddate   
and l.leadapplicantid is null
and c.localname <> 'Fax Server'
order by c.initiateddate 

Open new_leads_cursor

Fetch Next From new_leads_cursor 
Into @firstname, @lastname, @leadphone, @StateId, @LeadSourceId, @CompanyId, @ProductID, @Cost, @CallIdKey

WHILE @@FETCH_STATUS = 0
BEGIN
	If Not Exists(Select Top 1 leadapplicantid from tblleadapplicant where @leadphone=leadphone or @leadphone=homephone or @leadphone=cellphone or @callidkey=callidkey)
	Begin

		select top 1 @repid = userid from tblrgrreps order by lastleadassignedto	

		if @repid is null
			select @repid = 0
		else
			update tblrgrreps set lastleadassignedto=getdate() where userid=@repid

		insert into tblleadapplicant(FirstName, LastName, LeadPhone, StateId, LeadSourceId, CompanyId, StatusId, ProductID, Cost, CallIdKey, created, createdbyid, repid)
		values(@firstname, @lastname, @leadphone, @stateid, @LeadSourceid , @companyid, 16, @productid, @cost, @callidkey, getdate(), 29, @repid)
	End


	Fetch Next From new_leads_cursor 
	Into @firstname, @lastname, @leadphone, @StateId, @LeadSourceId, @CompanyId, @ProductID, @Cost, @CallIdKey

END

close new_leads_cursor
deallocate new_leads_cursor

END


GO
 