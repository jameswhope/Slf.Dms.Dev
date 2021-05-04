
if exists (select * from sysobjects where name = 'stp_GetCommRecAccessUsers')
	drop procedure stp_GetCommRecAccessUsers
go

create procedure stp_GetCommRecAccessUsers
as
begin

select -1 [userid], '' [user]
union
select distinct u.userid, u.firstname + ' ' + u.lastname
from tbluser u
join tblusercommrecaccess ua on ua.userid = u.userid
order by [user]


end
go 