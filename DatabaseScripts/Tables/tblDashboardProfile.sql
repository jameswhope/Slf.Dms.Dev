IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDashboardProfile')
	BEGIN
		PRINT 'DO NOTHING'
	END
ELSE
EXEC ('
CREATE TABLE [dbo].[tblDashboardProfile](
	[DashboardProfileID] [int] IDENTITY(1,1) NOT NULL,
	[DashboardItemID] [int] NOT NULL,
	[Scenario] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserID] [int] NOT NULL,
	[ClientX] [int] NOT NULL,
	[ClientY] [int] NOT NULL
) ON [PRIMARY]

')
GO
