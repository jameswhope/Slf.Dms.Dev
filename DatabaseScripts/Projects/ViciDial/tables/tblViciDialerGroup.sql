IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciDialerGroup')
	BEGIN
		CREATE TABLE [dbo].[tblViciDialerGroup](
		[DialerGroupId] [int] NOT NULL Primary Key Clustered,
		[DialerName] [varchar](50) NOT NULL,
		[Active] [bit] NOT NULL Default 0,
		[ParallelProcessing] [bit] NOT NULL Default 0)
	END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciDialerGroup')
	BEGIN
		Insert Into tblViciDialerGroup(DialerGroupId, DialerName, Active, ParallelProcessing)
		Values (2,'DMS',1,1)
	END
GO

