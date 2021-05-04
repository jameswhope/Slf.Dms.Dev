--drop table tblCreditorCleanupLog
--go
IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCreditorCleanupLog')
	BEGIN
		CREATE TABLE tblCreditorCleanupLog
		(ChangeId int not null Identity(1,1) Primary Key,
		 NewValue int Not null,
		 OldValue int Null,
		 TableName varchar(50) not null,
		 FieldName varchar(50) not null,
		 KeyId int Not Null,
		 [When] datetime not null default getdate(),
		 [By] int not null  	 
		)
END
GO

