/****** Object:  Table [dbo].[tblNegotiationEntity]    Script Date: 01/28/2008 13:17:15 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationEntity')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationEntity](
	[NegotiationEntityID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ParentNegotiationEntityID] [int] NULL,
	[ParentType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserID] [int] NULL,
	[ClientX] [int] NULL,
	[ClientY] [int] NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[Deleted] [bit] NULL CONSTRAINT [DF_tblNegotiationEntity_Deleted]  DEFAULT ((0))
) ON [PRIMARY]
')
END
GO