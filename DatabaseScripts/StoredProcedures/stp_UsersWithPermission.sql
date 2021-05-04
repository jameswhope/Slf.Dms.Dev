
create procedure stp_UsersWithPermission
(
	@FullFunctionName varchar(50)
)
as
begin


select u.userid, r.username, r.firstname, r.lastname
from tbluserpermission u 
join tblpermission p on p.permissionid = u.permissionid and p.value = 1
join tblfunction f on f.functionid = p.functionid and f.fullname = @FullFunctionName 
join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' 
join tbluser r on r.userid = u.userid and r.locked = 0

union

select u.userid, u.username, u.firstname, u.lastname
from tblgrouppermission g 
join tblpermission p on p.permissionid = g.permissionid and p.value = 1
join tblfunction f on f.functionid = p.functionid and f.fullname = @FullFunctionName 
join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' 
join tbluser u on u.usergroupid = g.usergroupid and u.locked = 0

order by firstname 


end
go