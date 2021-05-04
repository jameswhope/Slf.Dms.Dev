/****** Object:  Table [dbo].[tblNegotiationEntityGroup]    Script Date: 01/28/2008 13:17:46 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationEntityGroup')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationEntityGroup](
	[NegotiationEntityGroupID] [int] IDENTITY(1,1) NOT NULL,
	[NegotiationEntityID] [int] NOT NULL,
	[NegotiationGroupID] [int] NOT NULL
) ON [PRIMARY]
')
END
GO