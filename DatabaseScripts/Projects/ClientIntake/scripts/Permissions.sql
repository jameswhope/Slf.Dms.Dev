declare @rootparentid int, @parentid int

select @rootparentid = functionid from tblFunction where FullName = 'Client Intake'

if @rootparentid is not null  
begin
	select @parentid = functionid from tblFunction where FullName = 'Client Intake-List All Pipeline Leads'

	if @parentid is null
	 begin
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('List All Pipeline Leads', @rootparentid, 'Client Intake-List All Pipeline Leads', 0, 0)
		
		select @parentid =  scope_identity()
	end
	
	select @parentid = null
	
	select @parentid = functionid from tblFunction where FullName = 'Client Intake-Edit Lead Source'

	if @parentid is null
	 begin
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('Edit Lead Source', @rootparentid, 'Client Intake-Edit Lead Source', 0, 0)
		
		select @parentid =  scope_identity()
	end
end
