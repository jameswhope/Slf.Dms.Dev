/****** Object:  Table [dbo].[tblTranVoidReason]    Script Date: 11/19/2007 11:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTranVoidReason](
	[TranVoidReasonID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayName] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL
) ON [PRIMARY]
GO
