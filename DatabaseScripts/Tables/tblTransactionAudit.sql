/****** Object:  Table [dbo].[tblTransactionAudit]    Script Date: 11/19/2007 11:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransactionAudit](
	[TransactionAuditID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NOT NULL,
	[Amount] [money] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL
) ON [PRIMARY]
GO
