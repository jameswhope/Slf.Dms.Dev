create procedure [dbo].[stp_enrollment_leaddocuments_griddisplay]
	@leadApplicantID int
as

begin
	-- get doc info
	select isnull(documentid,'NA')[documentid], submitted, u.firstname + ' ' + u.lastname [submittedby], signatoryemail, currentstatus, completed,isnull(dt.displayname,'NA')[DocumentName]
	from tblleaddocuments d
	left join tbluser u on u.userid = d.submittedby
	left join tbldocumenttype dt on dt.documenttypeid = d.documenttypeid
	where d.leadapplicantid = @leadApplicantID
		and d.documenttypeid in (6,222) -- LSA
	order by d.submitted desc
end 

go