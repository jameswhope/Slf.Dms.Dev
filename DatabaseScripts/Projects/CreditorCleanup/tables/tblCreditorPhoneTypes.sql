/****** Object:  Table [dbo].[tblCreditorPhoneType]    Script Date: 03/17/2009 16:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCreditorPhoneType](
	[CreditorPhoneTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PhoneType] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblCreditorPhoneType] PRIMARY KEY CLUSTERED 
(
	[CreditorPhoneTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
 