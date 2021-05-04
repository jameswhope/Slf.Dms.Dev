IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciOverwriteListRule')
	BEGIN
		CREATE TABLE [dbo].[tblViciOverwriteListRule](
		[OverwriteRuleId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		[ViciListId] [int] NOT NULL,
		[ReturnValueQuery] [varchar](max) NOT NULL,
		[Active] [bit] NOT NULL DEFAULT 0,
		[PriorityOrder] [int] NOT NULL DEFAULT 0,
		[Fields] [varchar](1000) NULL)
	END
GO

