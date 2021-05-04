
alter view vw_enrollment_orig_rep
as


select l.LeadApplicantID, isnull(origrepid,repid) [OrigRepID]
from tblleadapplicant l
left join (
	select a.leadapplicantid, case when a.previousvalue > 1 then a.previousvalue else a.newvalue end [OrigRepID]
	from tblleadaudit a
	join (
		select min(leadauditid) [leadauditid] 
		from tblleadaudit 
		where leadfield = 'RepID'
		group by leadapplicantid
	) d on d.leadauditid = a.leadauditid
	where a.previousvalue > 1 or a.newvalue > 1
) o
on o.leadapplicantid = l.leadapplicantid


go