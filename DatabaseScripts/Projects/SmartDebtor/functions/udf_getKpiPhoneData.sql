IF EXISTS (SELECT * FROM sysobjects WHERE type = 'IF' AND name = 'udf_getKpiPhoneData')
	BEGIN
		DROP  function  udf_getKpiPhoneData
	END

GO


create function [dbo].[udf_getKpiPhoneData]
(
@startDate datetime,
@endDate datetime
)
RETURNS table
as
RETURN
(
declare @tblDNIS table(forDate varchar(10),dnis varchar(4))
insert into @tblDNIS 
select convert(varchar(10),fordate,101),right(phone ,4)
from tblleadphonelist
where fordate >= @startdate
group by convert(varchar(10),fordate,101), right(phone ,4)
order by convert(varchar(10),fordate,101)

select [Type] = 'PHONE'
,[DNIS] = substring(cd.dnis,5,4)
,[I3CallIDKey] = cd.callid
,[LocalCallIDKey] = isnull(lc.callidkey,'')
,[StationID] = case when cd.stationid = 'System' then 'System' else '' end
,[Screen Pop]= cd.localname
,[initiated]= cd.ConnectedDate
,[initDay] = datename(day,cd.ConnectedDate)
,[Created] = isnull(lc.created,'')
,[Status] = isnull(ls.description,'')
,[Full Name] = isnull(la.fullname,'')
,[City] = isnull(la.city,'')
,[State] = isnull(st.name,'')
,Concerns = isnull(con.description,'')
,LawFirm = isnull(comp.ShortCoName,'')
,Associate = isnull(u2.firstname +' ' + u2.lastname,'')
,Rep = isnull(u.firstname + ' ' + u.lastname,'')
,[Total Debt] = isnull(calc.totaldebt,0)
,[RemoteNumber] = cd.remoteNumber 
,[HoldDuration] = cd.HoldDurationSeconds 
,[LeadStatusId] = la.statusid 
,[FirstAppointmentDate] = case when not FirstAppointmentDate is null then 1 else 0 end 
,[LeadCreatedDate] = la.Created 
,[LeadSourceID]=la.LeadSourceID 
from [DMF-SQL-0001].i3_cic.dbo.calldetail cd 
left join tblleadcall lc on lc.callidkey = cd.callid 
left join tblleadapplicant la on la.leadapplicantid = lc.leadapplicantid 
left join tblleadstatus ls on la.statusid = ls.statusid 
left join tblstate st on la.stateid = st.stateid 
left join tblcompany comp on la.companyid = comp.companyid 
left join tblleadconcerns con on la.concernsid = con.concernsid 
left join tbluser u on repid = u.userid 
left join tbluser u2 on createdbyid = u2.userid 
left join tblleadcalculator calc on lc.leadapplicantid = calc.leadapplicantid 
left join @tblDNIS td on td.fordate = cd.ConnectedDate and td.dnis = substring(cd.dnis,charindex(':',cd.dnis)+1,4)
where cd.dnis is not null and  not la.leadsourceid in (5,7,8)  
and calldirection ='inbound' and calltype ='external' 
and cd.ConnectedDate between @startdate and @enddate
and cd.InteractionType = 0 
)




