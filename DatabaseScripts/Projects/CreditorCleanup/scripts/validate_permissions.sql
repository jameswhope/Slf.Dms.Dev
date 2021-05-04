
declare @functionid int
declare @parentfunctionid int

-- void register permissions
select @functionid = functionid from tblfunction where [name] = 'Home Menu'

set @parentfunctionid = @functionid
set @functionid = null

select @functionid = functionid from tblfunction where [name] = 'Home-Validate Creditors'

if (@functionid is null) begin
	insert tblfunction (parentfunctionid, [name], fullname, description, issystem, isoperation)
	values (@parentfunctionid, 'Validate Creditors', 'Home-Validate Creditors', null, 0, 0)
end  