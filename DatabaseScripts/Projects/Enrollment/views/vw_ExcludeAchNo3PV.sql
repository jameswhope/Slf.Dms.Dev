IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_ExcludeAchNo3PV')
	BEGIN
		DROP  View vw_ExcludeAchNo3PV
	END
GO
--Careful. this view affect nightly processes
CREATE View vw_ExcludeAchNo3PV AS
select c.clientid, c.currentclientstatusid from tblclient c
inner join dbo.vw_LeadApplicant_Client a on a.clientid = c.clientid
left join vw_enrollment_Ver_complete v on v.leadapplicantid = a.leadapplicantid
inner join tblleadapplicant l on l.leadapplicantid = a.leadapplicantid
where c.serviceimportid is not null
and v.completed is null
and c.VWUWResolved is null
and l.statusid <> 7 --Do not include old clients

GO
