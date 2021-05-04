--Creates the function Home-Agency Scenarios and activates the view permission  for user type agencies 
EXEC
('
declare @functionid int
select @functionid = functionid from tblfunction where [name] = ''Home-Agency Scenarios''

if (@functionid is null)
begin
	insert into  tblfunction(parentfunctionid, [name], fullname, description, issystem, isoperation)
	values (null, ''Home-Agency Scenarios'', ''Home-Agency Scenarios'', null, 0, 0)
	select @functionid = scope_identity()
	Print ''Function Home-Agency Scenarios added. Id = '' + convert(varchar,@functionid)
end
else
	Print ''Function Home-Agency Scenarios exists already. Id = '' + convert(varchar,@functionid)

declare @permissionid int

select @permissionid=permissionid from tblpermission 
where functionid = @functionid
and permissiontypeid=1
and permissionid in (select permissionid from tblgrouppermission where usertypeid=2 and  usergroupid is null)
	
	
if (@permissionid is null)
begin
	insert into tblpermission (permissiontypeid, [value], functionid) values (1,1,@functionid)
	select @permissionid = scope_identity()
	Print ''Permission added. Id = '' + convert(varchar,@permissionid)
	insert into tblgrouppermission (usertypeid, usergroupid, permissionid) values (2,null,@permissionid)
	Print ''Group permission added. Id = '' + convert(varchar, scope_identity())
end 
else
begin
 update tblpermission set
 value = 1
 where permissionid = @permissionid
 Print ''Permission activated. Id = '' + convert(varchar,@permissionid)
end
')