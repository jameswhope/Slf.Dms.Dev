IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDashboardItem')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblDashboardItem](
	[DashboardItemID] [int] IDENTITY(1,1) NOT NULL,
	[DesignXML] [xml] NOT NULL,
	[SQLParamXML] [xml] NOT NULL,
	[ClientWidth] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientHeight] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

	')
END
GO
