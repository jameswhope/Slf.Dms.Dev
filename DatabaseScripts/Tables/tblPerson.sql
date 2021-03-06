/****** Object:  Table [dbo].[tblPerson]    Script Date: 11/19/2007 11:04:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPerson](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[SSN] [varchar](50) NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Gender] [varchar](1) NULL,
	[DateOfBirth] [datetime] NULL,
	[LanguageID] [int] NOT NULL,
	[EmailAddress] [varchar](50) NULL,
	[Street] [varchar](255) NULL,
	[Street2] [varchar](255) NULL,
	[City] [varchar](50) NULL,
	[StateID] [int] NULL,
	[ZipCode] [varchar](50) NULL,
	[Relationship] [varchar](50) NOT NULL,
	[CanAuthorize] [bit] NOT NULL CONSTRAINT [DF_tblPerson_CanAuthorize]  DEFAULT (0),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[WebCity] [varchar](50) NULL,
	[WebStateID] [int] NULL,
	[WebZipCode] [varchar](50) NULL,
	[WebAreaCode] [varchar](50) NULL,
	[WebTimeZoneID] [int] NULL,
	[ThirdParty] [bit] NOT NULL CONSTRAINT [DF_tblPerson_ThirdParty]  DEFAULT (0),
 CONSTRAINT [PK_tblPerson] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
