/****** Object:  Table [dbo].[tblCommBatchTransfer]    Script Date: 11/19/2007 11:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCommBatchTransfer](
	[CommBatchTransferID] [int] IDENTITY(1,1) NOT NULL,
	[CommBatchID] [int] NOT NULL,
	[CommRecID] [int] NOT NULL,
	[ParentCommRecID] [int] NULL,
	[Order] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[TransferAmount] [money] NULL,
	[CheckNumber] [varchar](50) NULL,
	[CheckDate] [datetime] NULL,
	[CheckBy] [int] NULL,
 CONSTRAINT [PK_tblCommBatchTransfer] PRIMARY KEY CLUSTERED 
(
	[CommBatchTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
