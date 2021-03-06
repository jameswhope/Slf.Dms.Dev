/****** Object:  Table [dbo].[_tblGiganticQuery]    Script Date: 11/19/2007 11:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tblGiganticQuery](
	[GiganticQueryID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[CurrentAmount] [money] NOT NULL,
	[RetainerPercent] [money] NOT NULL,
	[RetainerAmount] [money] NOT NULL,
	[WeightedAmount] [money] NOT NULL,
	[TotalRetainer] [money] NOT NULL,
	[TotalDeposits] [money] NOT NULL,
	[PaidToWeighted] [money] NOT NULL,
	[DepositRemainingWeighted] [money] NOT NULL,
	[PaidToRetainer] [money] NOT NULL,
	[DepositRemainingRetainer] [money] NOT NULL
) ON [PRIMARY]
GO
