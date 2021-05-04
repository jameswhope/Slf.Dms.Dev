/****** Object:  Table [dbo].[tblMatterPhoneEntry]    Script Date: 02/24/2010 07:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMatterPhoneEntry](
	[MatterPhoneEntryID] [int] IDENTITY(1,1) NOT NULL,
	[PhoneEntry] [varchar](100) NULL,
	[PhoneEntryDesc] [varchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDatetime] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_tblMattterPhoneEntry] PRIMARY KEY CLUSTERED 
(
	[MatterPhoneEntryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Default [DF_tblMatterPhoneEntry_CreatedDatetime]    Script Date: 02/24/2010 07:11:14 ******/
ALTER TABLE [dbo].[tblMatterPhoneEntry] ADD  CONSTRAINT [DF_tblMatterPhoneEntry_CreatedDatetime]  DEFAULT (getdate()) FOR [CreatedDatetime]
GO
/****** Object:  Default [DF_tblMattterPhoneEntry_IsActive]    Script Date: 02/24/2010 07:11:14 ******/
ALTER TABLE [dbo].[tblMatterPhoneEntry] ADD  CONSTRAINT [DF_tblMattterPhoneEntry_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO