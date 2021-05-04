IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCommRecGroup')
	BEGIN
		CREATE TABLE  tblCommRecGroup (
			 CommRecGroupId   int  IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
			 CommRecGroupName   varchar(50) NOT NULL,
			 ParentCommRecGroupId  int null
		)  
	END
GO

