declare @rootparentid int, @parentid int

select @rootparentid = functionid from tblFunction where FullName = 'Client Intake'

if @rootparentid is not null  
begin
	select @parentid = functionid from tblFunction where FullName = 'Client Intake-Credit Report'

	if @parentid is null
	 begin
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('Credit Report', @rootparentid, 'Client Intake-Credit Report', 0, 0)
		
		select @parentid =  scope_identity()
	end
	
end