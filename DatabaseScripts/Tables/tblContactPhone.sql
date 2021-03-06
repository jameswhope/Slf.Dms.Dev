/****** Object:  Table [dbo].[tblContactPhone]    Script Date: 11/19/2007 11:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblContactPhone](
	[ContactPhoneID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[PhoneID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblContactPhone] PRIMARY KEY CLUSTERED 
(
	[ContactPhoneID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
