/****** Object:  Table [dbo].[tblACH]    Script Date: 11/19/2007 11:02:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblACH](
	[ACHID] [int] IDENTITY(1,1) NOT NULL,
	[Address] [varchar](255) NULL,
	[ChangeDate] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[CustomerName] [varchar](255) NULL,
	[InstitutionStatusCode] [varchar](255) NULL,
	[NewRoutingNumber] [varchar](255) NULL,
	[OfficeCode] [varchar](255) NULL,
	[RecordTypeCode] [varchar](255) NULL,
	[RoutingNumber] [varchar](255) NULL,
	[ServicingFRBNumber] [varchar](255) NULL,
	[StateCode] [varchar](255) NULL,
	[TelephoneAreaCode] [varchar](255) NULL,
	[TelephonePrefixNumber] [varchar](255) NULL,
	[TelephoneSuffixNumber] [varchar](255) NULL,
	[ZipCode] [varchar](255) NULL,
	[ZipCodeExtension] [varchar](255) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblACH] PRIMARY KEY CLUSTERED 
(
	[ACHID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
