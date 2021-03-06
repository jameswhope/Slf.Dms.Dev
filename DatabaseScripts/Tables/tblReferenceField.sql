/****** Object:  Table [dbo].[tblReferenceField]    Script Date: 11/19/2007 11:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblReferenceField](
	[ReferenceFieldID] [int] NOT NULL,
	[ReferenceID] [int] NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[Caption] [varchar](50) NULL,
	[Field] [varchar](50) NOT NULL,
	[Definition] [varchar](255) NULL,
	[Join] [varchar](255) NULL,
	[Type] [varchar](50) NULL,
	[Multi] [bit] NOT NULL CONSTRAINT [DF_tblReferenceField_Multi]  DEFAULT (0),
	[MultiOrder] [int] NOT NULL CONSTRAINT [DF_tblReferenceField_Order]  DEFAULT (0),
	[MultiFormat] [varchar](50) NULL,
	[Width] [varchar](50) NULL,
	[Align] [varchar](50) NULL,
	[Single] [bit] NOT NULL CONSTRAINT [DF_tblReferenceField_Single]  DEFAULT (0),
	[SingleOrder] [int] NOT NULL CONSTRAINT [DF_tblReferenceField_MultiOrder1]  DEFAULT (0),
	[SingleFormat] [varchar](50) NULL,
	[Editable] [bit] NOT NULL CONSTRAINT [DF_tblReferenceField_Editable]  DEFAULT (0),
	[Required] [bit] NOT NULL CONSTRAINT [DF_tblReferenceField_Required]  DEFAULT (0),
	[Validate] [varchar](50) NULL,
	[Attributes] [varchar](1000) NULL,
	[Input] [varchar](10) NULL,
	[IMMask] [varchar](50) NULL,
	[DDLSource] [varchar](1000) NULL,
	[DDLValue] [varchar](50) NULL,
	[DDLText] [varchar](50) NULL,
	[FieldToSave] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
