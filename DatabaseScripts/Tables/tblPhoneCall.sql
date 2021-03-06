/****** Object:  Table [dbo].[tblPhoneCall]    Script Date: 11/19/2007 11:04:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPhoneCall](
	[PhoneCallID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Direction] [bit] NOT NULL,
	[Subject] [varchar](255) NOT NULL,
	[Body] [varchar](5000) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
 CONSTRAINT [PK_tblPhoneCall] PRIMARY KEY CLUSTERED 
(
	[PhoneCallID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
