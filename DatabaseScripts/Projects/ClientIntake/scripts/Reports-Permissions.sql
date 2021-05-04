declare @rootparentid int, @parentid int

select @rootparentid = functionid from tblFunction where FullName = 'Client Intake'

if @rootparentid is not null  
begin
	select @parentid = functionid from tblFunction where FullName = 'Client Intake-Reports'

	if @parentid is null
	 begin
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('Reports', @rootparentid, 'Client Intake-Reports', 0, 0)
		
		select @parentid =  scope_identity()
	end
	
	if @parentid is not null
	begin
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('Pending Clients', @parentid, 'Client Intake-Reports-Pending Clients', 0, 0)
		
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('Lead Dashboard by Reps', @parentid, 'Client Intake-Reports-Lead Dashboard by Reps', 0, 0)
		
		INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
		VALUES('Deposit Analysis', @parentid, 'Client Intake-Reports-Deposit Analysis', 0, 0)
	end
	
	
end