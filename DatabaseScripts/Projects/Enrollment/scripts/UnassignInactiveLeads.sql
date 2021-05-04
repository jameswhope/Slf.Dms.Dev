
-- RUNS AS A SQL JOB


-- log audit trail
insert tblLeadAudit (LeadApplicantID, UserID, ModificationDate, LeadTable, ModificationType, LeadField, PreviousValue, NewValue)
select l.leadapplicantid, 1265, getdate(), 'tblLeadApplicant', 'Assign new Rep', 'RepID', l.repid, 1
from tblleadapplicant l
join vw_enrollment_CurrentStatusCreated v on v.leadapplicantid = l.leadapplicantid
	and v.currentstatusid in (12,8,1,9,13,15,14,2)
	and datediff(d,v.statuscreated,getdate()) > 5
join vw_enrollment_LastNoteCreated n on n.leadapplicantid = l.leadapplicantid
	and datediff(hour,n.lastnotecreated,getdate()) > 72
where l.repid > 0

-- unassign
update tblleadapplicant
set repid = null, lastmodified = getdate(), LastModifiedByID = 1265, LeadAssignedToDate = getdate()
from tblleadapplicant l
join vw_enrollment_CurrentStatusCreated v on v.leadapplicantid = l.leadapplicantid
	and v.currentstatusid in (12,8,1,9,13,15,14,2)
	and datediff(d,v.statuscreated,getdate()) > 5
join vw_enrollment_LastNoteCreated n on n.leadapplicantid = l.leadapplicantid
	and datediff(hour,n.lastnotecreated,getdate()) > 72
where l.repid > 0


 