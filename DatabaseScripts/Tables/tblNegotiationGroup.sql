/****** Object:  Table [dbo].[tblNegotiationGroup]    Script Date: 01/28/2008 13:21:09 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationGroup')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationGroup](
	[NegotiationGroupID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
')
END
GO