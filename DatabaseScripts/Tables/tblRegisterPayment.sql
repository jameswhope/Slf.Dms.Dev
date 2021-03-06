/****** Object:  Table [dbo].[tblRegisterPayment]    Script Date: 11/19/2007 11:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRegisterPayment](
	[RegisterPaymentId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[FeeRegisterId] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Voided] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPayment_Voided]  DEFAULT (0),
	[Bounced] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPayment_Bounced]  DEFAULT (0),
	[PFOBalance] [money] NOT NULL CONSTRAINT [DF_tblRegisterPayment_PFOBalance]  DEFAULT (0),
	[SDABalance] [money] NOT NULL CONSTRAINT [DF_tblRegisterPayment_SDABalance]  DEFAULT (0),
 CONSTRAINT [PK_tblRegisterPayment] PRIMARY KEY CLUSTERED 
(
	[RegisterPaymentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblRegisterPayment_7_1134627085__K3_K5_K6_2_4] ON [dbo].[tblRegisterPayment] 
(
	[FeeRegisterId] ASC,
	[Voided] ASC,
	[Bounced] ASC
)
INCLUDE ( [PaymentDate],
[Amount]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
