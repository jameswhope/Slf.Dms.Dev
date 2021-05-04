
CREATE TABLE [dbo].[tblPotentialRegisterPaymentDepositTmp]
(
	[RegisterPaymentDepositID] [int] IDENTITY(1,1) NOT NULL,
	[RegisterPaymentID] [int] NOT NULL,
	[DepositRegisterID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	--[Voided] [bit] NOT NULL CONSTRAINT [DF_tblPotentialRegisterPaymentDepositTmp_Voided]  DEFAULT ((0)),
	--[Bounced] [bit] NOT NULL CONSTRAINT [DF_tblPotentialRegisterPaymentDepositTmp_Bounced]  DEFAULT ((0)),
	CONSTRAINT [PK_tblPotentialRegisterPaymentDepositTmp] PRIMARY KEY CLUSTERED 
	(
		[RegisterPaymentDepositID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
 