IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getCloser')
	BEGIN
		DROP  Procedure  stp_enrollment_getCloser
	END
GO

create procedure stp_enrollment_getCloser
(
	@leadapplicantid int
)
as
begin

declare @leadauditid int

-- get the first closer assigned to this lead
select @leadauditid = min(a.leadauditid)
from tblleadapplicant l
join tblLeadAudit a on a.leadapplicantid = l.leadapplicantid
	and a.leadfield = 'RepID'
join tblUser u on u.userid = a.newvalue
	and u.usergroupid = 25 -- CID Closer
where l.leadapplicantid = @leadapplicantid
group by l.leadapplicantid

-- output
select a.leadauditid, u.userid [closerId], u.firstname + ' ' + left(u.lastname,1) + '.' [closer]
from tblleadaudit a
join tbluser u on u.userid = a.newvalue
where a.leadauditid = @leadauditid


end
go