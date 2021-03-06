/****** Object:  Table [dbo].[tblRegisterPaymentDeposit]    Script Date: 11/19/2007 11:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRegisterPaymentDeposit](
	[RegisterPaymentDepositID] [int] IDENTITY(1,1) NOT NULL,
	[RegisterPaymentID] [int] NOT NULL,
	[DepositRegisterID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Voided] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPaymentDeposit_Voided]  DEFAULT (0),
	[Bounced] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPaymentDeposit_Bounced]  DEFAULT (0),
 CONSTRAINT [PK_tblRegisterPaymentDeposit] PRIMARY KEY CLUSTERED 
(
	[RegisterPaymentDepositID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblRegisterPaymentDeposit_7_1102626971__K6_K5_K3_4] ON [dbo].[tblRegisterPaymentDeposit] 
(
	[Bounced] ASC,
	[Voided] ASC,
	[DepositRegisterID] ASC
)
INCLUDE ( [Amount]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
