/*
	Defines permissions for the Verification tabs

	Home Menu
		Verification
			New CID Clients
			My CID Clients
			Assigned CID Clients
			CID Transfer History
*/
if not exists (select 1 from tblFunction where [Name] = 'Verification') begin
	declare @ParentFunctionId int

	select @ParentFunctionId = FunctionId from tblFunction where [FullName] = 'Home'

	-- Verification
	insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
	values (@ParentFunctionId,'Verification','Home-Verification',0,0)
	
	select @ParentFunctionId = scope_identity()

		-- New CID Clients
		insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
		values (@ParentFunctionId,'New CID Clients','Home-Verification-New CID Clients',0,0)

		-- My CID Clients
		insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
		values (@ParentFunctionId,'My CID Clients','Home-Verification-My CID Clients',0,0)

		-- Assigned CID Clients
		insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
		values (@ParentFunctionId,'Assigned CID Clients','Home-Verification-Assigned CID Clients',0,0)

		-- CID Transfer History
		insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
		values (@ParentFunctionId,'CID Transfer History','Home-Verification-CID Transfer History',0,0)
		
		-- Verification History
		insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
		values (@ParentFunctionId,'Verification History','Home-Verification-Verification History',0,0)
end 