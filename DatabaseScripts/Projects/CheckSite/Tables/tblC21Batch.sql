IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblC21Batch')
	BEGIN
		CREATE TABLE tblC21Batch
		(BatchId varchar(50) not null Primary Key,
		 Created Datetime not null,
		 RequestBeginDate Datetime not null,
		 RequestEndDate Datetime not null
		) 
	END
GO
 
