IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDashboardPermission')
	BEGIN
		PRINT 'DO NOTHING'
	END
ELSE
EXEC ('
CREATE TABLE [dbo].[tblDashboardPermission](
	[DashboardPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[Scenario] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserParameterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserParameter] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DashboardItemID] [int] NOT NULL
) ON [PRIMARY]
')
GO
