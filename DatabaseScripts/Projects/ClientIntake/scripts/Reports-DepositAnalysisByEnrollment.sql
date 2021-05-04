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
		if not exists(select * from tblFunction where FullName = 'Client Intake-Reports-Deposits By Enrollment Date')
		begin
			INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
			VALUES('Deposits By Enrollment Date', @parentid, 'Client Intake-Reports-Deposits By Enrollment Date', 0, 0)
		end
	end
	
	
end