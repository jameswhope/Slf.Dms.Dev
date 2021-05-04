 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'IF' AND name = 'udf_getKpiInternetData')
	BEGIN
		DROP  function  udf_getKpiInternetData
	END

GO

create function [dbo].[udf_getKpiInternetData]
(
@startDate datetime,
@endDate datetime
)
RETURNS table
as
RETURN
(
select [Type] = 'INTERNET',[DNIS] = '00000' ,[I3CallIDKey] = '00000' ,[LocalCallIDKey] = '*****',[StationID] = '00000' ,[Screen Pop]= '00000' 
,[initiated]= la.created,[initDay] = day(la.created),[Created] = la.created,[Status] = isnull(ls.description,''),[Full Name] = isnull(la.fullname,'')
,[City] = isnull(la.city,''),[State] = isnull(st.name,''),Concerns = isnull(con.description,''),LawFirm = isnull(comp.ShortCoName,'')
,Associate = isnull(u2.firstname +' ' + u2.lastname,''),Rep = isnull(u.firstname + ' ' + u.lastname,''),[Total Debt] = isnull(calc.totaldebt,0)
,[RemoteNumber] = '00000' ,[HoldDuration] = '00000' ,[LeadStatusId] = la.statusid 
,[FirstAppointmentDate] = case when not FirstAppointmentDate is null then 1 else 0 end ,[LeadCreatedDate] = la.Created ,[LeadSourceID]=la.LeadSourceID 
from tblleadapplicant la 
left join tblleadstatus ls on la.statusid = ls.statusid 
left join tblstate st on la.stateid = st.stateid 
left join tblcompany comp on la.companyid = comp.companyid 
left join tblleadconcerns con on la.concernsid = con.concernsid 
left join tbluser u on repid = u.userid 
left join tbluser u2 on createdbyid = u2.userid 
left join tblleadcalculator calc on la.leadapplicantid = calc.leadapplicantid 
where la.leadsourceid in (5,7,8)  
and la.Created between @startdate and @enddate
)




