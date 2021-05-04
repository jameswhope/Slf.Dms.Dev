IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_enrollment_CurrentStatusCreated')
	BEGIN
		DROP  View vw_enrollment_CurrentStatusCreated
	END
GO

CREATE View vw_enrollment_CurrentStatusCreated AS


	select l.leadapplicantid, l.statusid [currentstatusid], l.created [leadcreated], max(r.created)[statuscreated], min(r.created)[minstatuscreated]
	from tblleadapplicant l
	join tblleadstatusroadmap r on r.leadapplicantid = l.leadapplicantid and r.leadstatusid = l.statusid
	group by l.leadapplicantid, l.statusid, l.created


	/* for reference, these should match
	select count(*) from tblleadapplicant

	select count(*)
	from (
		select l.leadapplicantid, l.statusid
		from tblleadapplicant l
		join tblleadstatusroadmap r on r.leadapplicantid = l.leadapplicantid and r.leadstatusid = l.statusid
		group by l.leadapplicantid, l.statusid
	) d
	*/

GO

