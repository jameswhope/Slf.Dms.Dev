
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_enrollment_Ver_complete')
	BEGIN
		DROP  VIEW vw_enrollment_Ver_complete
	END
GO

create view vw_enrollment_Ver_complete 
as
select ver.LeadApplicantID, 
completed = case when ver.RecFile is null then null else ver.completed end
from (
	select ld.LeadApplicantID, ld.completed, ld.RecFile, ranked = rank() over (partition by ld.leadapplicantid Order by ld.completed desc)  
	from (
		select l.LeadApplicantID, l.completed, 'dummy' as RecFile
		from tblleadverification l
		Union
		Select vw.LeadApplicantID, v.enddate, v.RecordedCallPath
		from tblverificationcall v
		inner join vw_LeadApplicant_Client vw on vw.clientid = v.clientid
		Union
		Select vc.LeadApplicantID, vc.enddate, vc.RecordedCallPath
		from tblverificationcall vc
		where vc.leadapplicantid > 0) ld) ver
where ver.ranked = 1
	
