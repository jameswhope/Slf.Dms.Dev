
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_leaddocuments')
	BEGIN
		DROP  Procedure  stp_enrollment_leaddocuments
	END
GO

create procedure stp_enrollment_leaddocuments
(
	@leadApplicantID int,
	@expirationDays int = 30
)
as
begin
	-- update expired docs
	-- could hit assuresign web service instead to check on and expire docs
	update tblleaddocuments
	set currentstatus = 'Expired'
	where leadapplicantid = @leadApplicantID
	and completed is null
	and submitted < dateadd(d,-@expirationDays,getdate())
	and currentstatus <> 'Expired'

	-- get doc info
	select isnull(documentid,'NA')[documentid], submitted, u.firstname + ' ' + u.lastname [submittedby], signatoryemail, currentstatus, completed,isnull(dt.displayname,'NA')[DocumentName]
	from tblleaddocuments d
	left join tbluser u on u.userid = d.submittedby
	left join tbldocumenttype dt on dt.documenttypeid = d.documenttypeid
	where d.leadapplicantid = @leadApplicantID
		and d.documenttypeid in (222,345) -- LSA, Verification Recorded Call
	order by d.submitted desc

end
go
 