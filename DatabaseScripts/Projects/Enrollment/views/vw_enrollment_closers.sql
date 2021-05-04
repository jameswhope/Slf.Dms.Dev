IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_enrollment_closers')
	BEGIN
		DROP VIEW vw_enrollment_closers
	END
GO


create view vw_enrollment_closers
as

select a.LeadApplicantID, a.LeadAuditID, a.NewValue [CloserID]
from tblleadaudit a
join (
	-- get the first closer assigned to this lead
	select min(a.leadauditid) [leadauditid]
	from tblleadapplicant l
	join tblLeadAudit a on a.leadapplicantid = l.leadapplicantid
		and a.leadfield = 'RepID'
	join tblUser u on u.userid = a.newvalue
		and u.usergroupid = 25 -- CID Closer
	group by l.leadapplicantid
) c
on c.leadauditid = a.leadauditid 


