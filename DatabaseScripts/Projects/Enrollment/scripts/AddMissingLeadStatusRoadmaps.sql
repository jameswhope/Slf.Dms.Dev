
-- these should match
select count(*) from tblleadapplicant

select count(*)
from (
	select l.leadapplicantid, l.statusid, max(r.created)[statuscreated]
	from tblleadapplicant l
	join tblleadstatusroadmap r on r.leadapplicantid = l.leadapplicantid and r.leadstatusid = l.statusid
	group by l.leadapplicantid, l.statusid
) d


-- insert a created status for all leads that dont have any roadmaps
insert tblleadstatusroadmap (LeadApplicantID,LeadStatusID,Reason,Created,CreatedBy,LastModified,LastModifiedBy)
select leadapplicantid, 16, 'Applicant Created.',created,1265,created,1265
from tblleadapplicant
where leadapplicantid not in (select distinct leadapplicantid from tblleadstatusroadmap)


insert tblleadstatusroadmap (LeadApplicantID,LeadStatusID,Reason,Created,CreatedBy,LastModified,LastModifiedBy)
select leadapplicantid , statusid, 'Applicant Status Changed.', lastmodified,lastmodifiedbyid, lastmodified,lastmodifiedbyid
from tblleadapplicant
where leadapplicantid not in (
	select distinct l.leadapplicantid
	from tblleadapplicant l
	join tblleadstatusroadmap r on r.leadapplicantid = l.leadapplicantid and r.leadstatusid = l.statusid
)


-- not sure why these were getting inserted every time save was clicked. not needed. these leads already have another 
-- roadmap for statusid 10 where the reason is Status Changed and have a parent roadmapid
-- commented out in App_Code\LeadProcessorHelper from inserting further dups
delete from tblleadstatusroadmap
where reason = 'In Process'
and leadstatusid = 10

 