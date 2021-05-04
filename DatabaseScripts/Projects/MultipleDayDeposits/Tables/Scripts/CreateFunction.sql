 EXEC
('
declare @functionid int
declare @parentfunctionid int

select @functionid = functionid from tblfunction where [name] = ''Finances''

if (@functionid is null)
begin
	insert into  tblfunction(parentfunctionid, [name], fullname, description, issystem, isoperation)
	values (null, ''Finances'', ''Clients-Client Single Record-Finances'', null, 0, 0)
	select @functionid = scope_identity()
	Print ''Function Clients-Client Single Record-Finances. Id = '' + convert(varchar,@functionid)
end
else
	Print ''Function Clients-Client Single Record-Finances exists already. Id = '' + convert(varchar,@functionid)
	
select @parentfunctionid = @functionid
select @functionid = null
select @functionid = functionid from tblfunction where [name] = ''ACH''

if (@functionid is null)
begin
	insert into  tblfunction(parentfunctionid, [name], fullname, description, issystem, isoperation)
	values (@parentfunctionid, ''ACH'', ''Clients-Client Single Record-Finances-ACH'', null, 0, 0)
	select @functionid = scope_identity()
	Print ''Function Clients-Client Single Record-Finances-ACH. Id = '' + convert(varchar,@functionid)
end
else
	Print ''Function ACH exists already. Id = '' + convert(varchar,@functionid)
	
select @parentfunctionid = @functionid
select @functionid = null
select @functionid = functionid from tblfunction where [name] = ''Convert To Multi''

if (@functionid is null)
begin
	insert into  tblfunction(parentfunctionid, [name], fullname, description, issystem, isoperation)
	values (@parentfunctionid, ''Convert To Multi'', ''Clients-Client Single Record-Finances-ACH-Convert To Multi'', null, 0, 0)
	select @functionid = scope_identity()
	Print ''Function Clients-Client Single Record-Finances-ACH-Convert To Multi. Id = '' + convert(varchar,@functionid)
end
else
	Print ''Function Convert To Multi exists already. Id = '' + convert(varchar,@functionid)

')