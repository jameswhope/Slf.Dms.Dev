/****** Object:  Table [dbo].[tblRoutingNumber]    Script Date: 11/19/2007 11:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRoutingNumber](
	[RoutingNumber] [varchar](50) NOT NULL,
	[OfficeCode] [varchar](50) NULL,
	[ServicingFRBNumber] [varchar](50) NULL,
	[RecordTypeCode] [tinyint] NULL,
	[ChangeDate] [varchar](50) NULL,
	[NewRoutingNumber] [varchar](50) NULL,
	[CustomerName] [varchar](50) NOT NULL,
	[Address] [varchar](50) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[StateCode] [varchar](50) NOT NULL,
	[ZipCode] [varchar](50) NOT NULL,
	[ZipCodeExtension] [varchar](50) NULL,
	[AreaCode] [varchar](50) NULL,
	[PhonePrefix] [varchar](50) NULL,
	[PhoneSuffix] [varchar](50) NULL,
	[InstitutionStatus] [varchar](50) NULL,
	[DataViewCode] [varchar](50) NULL,
	[Filler] [varchar](50) NULL,
	[InsertDate] [datetime] NULL CONSTRAINT [DF_ACHRoutingNumbers_insertDate]  DEFAULT (getdate()),
	[Active] [smallint] NOT NULL CONSTRAINT [DF_ACHRoutingNumbers_active]  DEFAULT (1),
 CONSTRAINT [PK_tblRoutingNumber] PRIMARY KEY CLUSTERED 
(
	[RoutingNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
