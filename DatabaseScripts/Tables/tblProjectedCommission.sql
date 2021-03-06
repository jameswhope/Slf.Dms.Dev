/****** Object:  Table [dbo].[tblProjectedCommission]    Script Date: 11/19/2007 11:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectedCommission](
	[ProjectedCommissionId] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[CommRecID] [int] NOT NULL,
	[FeePaymentAmount] [money] NOT NULL,
	[Percent] [float] NOT NULL,
	[CommissionEarned] [money] NOT NULL,
	[EntryTypeId] [int] NOT NULL,
	[IsMCA] [bit] NULL,
	[Month] [tinyint] NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_tblProjectedCommission] PRIMARY KEY CLUSTERED 
(
	[ProjectedCommissionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
