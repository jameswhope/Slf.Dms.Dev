/****** Object:  Table [dbo].[tblCommChargeback]    Script Date: 11/19/2007 11:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCommChargeback](
	[CommChargebackID] [int] IDENTITY(1,1) NOT NULL,
	[CommPayID] [int] NULL,
	[ChargebackDate] [datetime] NOT NULL,
	[RegisterPaymentID] [int] NOT NULL,
	[CommStructID] [int] NOT NULL,
	[Percent] [money] NOT NULL,
	[Amount] [money] NOT NULL,
	[CommBatchID] [int] NULL,
 CONSTRAINT [PK_tblCommChargeback] PRIMARY KEY CLUSTERED 
(
	[CommChargebackID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
