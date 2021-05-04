IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'Clear')
	alter table tblRegisterPayment add  [Clear] datetime null 
GO
IF not exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'ClearBy')
	alter table tblRegisterPayment add  [ClearBy] int null 
GO

