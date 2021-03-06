/****** Object:  Table [dbo].[tblQuerySetting]    Script Date: 11/19/2007 11:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblQuerySetting](
	[QuerySettingID] [int] IDENTITY(1,1) NOT NULL,
	[ClassName] [varchar](255) NOT NULL,
	[UserID] [int] NOT NULL,
	[Object] [varchar](255) NOT NULL,
	[SettingType] [varchar](50) NOT NULL,
	[Value] [varchar](8000) NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblQuerySetting_Created]  DEFAULT (getdate()),
 CONSTRAINT [PK_tblQuerySettings] PRIMARY KEY CLUSTERED 
(
	[QuerySettingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value,Attribute,Style,Store' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblQuerySetting', @level2type=N'COLUMN',@level2name=N'SettingType'
GO
