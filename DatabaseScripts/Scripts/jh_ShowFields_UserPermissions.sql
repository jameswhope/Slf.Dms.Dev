
/*
	Defines new user permissions for the Settlement Attorneys interface. Work Item: 437

	Admin Menu
		Settings
			Structural
				Settlement Attorneys
					Banking Information
						Show Fields
					FTP Information
						Show Fields
*/
if not exists (select 1 from tblFunction where [Name] = 'Structural') begin
	declare @ParentFunctionId int, @BankingFunctionId int, @FtpFunctionId int

	select @ParentFunctionId = FunctionId from tblFunction where [FullName] = 'Admin-Settings'

	-- Structural
	insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
	values (@ParentFunctionId,'Structural','Admin-Settings-Structural',0,0)
	
	select @ParentFunctionId = scope_identity()

		-- Settlement Attorneys
		insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
		values (@ParentFunctionId,'Settlement Attorneys','Admin-Settings-Structural-Settlement Attorneys',0,0)

		select @ParentFunctionId = scope_identity()

			-- Banking Information
			insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
			values (@ParentFunctionId,'Banking Information','Admin-Settings-Structural-Settlement Attorneys-Banking Information',0,0)

			select @BankingFunctionId = scope_identity()

				-- Show Fields
				insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
				values (@BankingFunctionId,'Show Fields','Admin-Settings-Structural-Settlement Attorneys-Banking Information-Show Fields',0,0)

			-- FTP Information
			insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
			values (@ParentFunctionId,'FTP Information','Admin-Settings-Structural-Settlement Attorneys-FTP Information',0,0)

			select @FtpFunctionId = scope_identity()

				-- Show Fields
				insert tblFunction (ParentFunctionId,[Name],FullName,IsSystem,IsOperation) 
				values (@FtpFunctionId,'Show Fields','Admin-Settings-Structural-Settlement Attorneys-FTP Information-Show Fields',0,0)

end