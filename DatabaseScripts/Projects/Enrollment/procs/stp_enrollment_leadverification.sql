
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_leadverification')
	BEGIN
		DROP  Procedure  stp_enrollment_leadverification
	END
GO

create procedure stp_enrollment_leadverification
(
	@leadApplicantID int
)
as
begin

	select submitted, u.firstname + ' ' + u.lastname [submittedby], left(accessnumber,3)+'-'+substring(accessnumber,4,3)+'-'+right(accessnumber,4) [accessnumber], pvn, confnum, completed
	from tblleadverification v
	left join tbluser u on u.userid = v.submittedby
	where v.leadapplicantid = @leadApplicantID
	order by v.submitted desc

end
go
  