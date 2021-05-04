 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientBankAccount')
 BEGIN
	IF col_length('tblClientBankAccount', 'Disabled') is null
		Alter table tblClientBankAccount Add Disabled Datetime null  
	IF col_length('tblClientBankAccount', 'DisabledBy') is null
		Alter table tblClientBankAccount Add DisabledBy int null  		
END
GO