
declare @functionid int
declare @parentfunctionid int

-- void register permissions
select @functionid = functionid from tblfunction where [name] = 'Clients Menu'

set @parentfunctionid = @functionid
set @functionid = null

select @functionid = functionid from tblfunction where [name] = 'Enrollment-Phone List'

if (@functionid is null) begin
	insert tblfunction (parentfunctionid, [name], fullname, description, issystem, isoperation)
	values (@parentfunctionid, 'Enrollment-Phone List', 'Clients-Enrollment-Phone List', null, 0, 0)
end 