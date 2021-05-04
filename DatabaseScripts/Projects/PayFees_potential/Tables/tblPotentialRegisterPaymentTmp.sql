
CREATE TABLE [dbo].[tblPotentialRegisterPaymentTmp]
(
	[RegisterPaymentId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[FeeRegisterId] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	--[Voided] [bit] NOT NULL CONSTRAINT [DF_tblPotentialRegisterPaymentTmp_Voided]  DEFAULT ((0)),
	--[Bounced] [bit] NOT NULL CONSTRAINT [DF_tblPotentialRegisterPaymentTmp_Bounced]  DEFAULT ((0)),
	[PFOBalance] [money] NOT NULL CONSTRAINT [DF_tblPotentialRegisterPaymentTmp_PFOBalance]  DEFAULT ((0)),
	[SDABalance] [money] NOT NULL CONSTRAINT [DF_tblPotentialRegisterPaymentTmp_SDABalance]  DEFAULT ((0)),
	[Clear] [datetime] NULL
 CONSTRAINT [PK_tblPotentialRegisterPaymentTmp] PRIMARY KEY CLUSTERED 
(
	[RegisterPaymentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
 