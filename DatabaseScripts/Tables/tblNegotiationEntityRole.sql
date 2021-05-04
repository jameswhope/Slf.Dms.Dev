/****** Object:  Table [dbo].[tblNegotiationEntityRole]    Script Date: 01/28/2008 13:18:20 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationEntityRole')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationEntityRole](
	[NegotiationEntityRoleID] [int] IDENTITY(1,1) NOT NULL,
	[NegotiationEntityID] [int] NOT NULL,
	[NegotiationRoleID] [int] NOT NULL
) ON [PRIMARY]
')
END
GO