
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_enrollment_LSA_complete')
	BEGIN
		DROP  VIEW vw_enrollment_LSA_complete
	END
GO

create view vw_enrollment_LSA_complete 
as

select LeadApplicantID, max(completed) [Completed]
from tblleaddocuments
where documenttypeid in (6,222) -- LSA
group by leadapplicantid 
	
