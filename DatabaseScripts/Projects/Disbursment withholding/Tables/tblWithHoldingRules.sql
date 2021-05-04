IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblWithHoldingRules')
	BEGIN
		DROP  Table tblWithHoldingRules
	END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblWithHoldingRules]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblWithHoldingRules](
	[WithholdingRuleID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[Description] [varchar](50) NULL,
	[Reason] [varchar](150) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Percentage] [numeric](18, 2) NOT NULL,
	[Amount] [money] NOT NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/*
GRANT SELECT ON tblWithHoldingRules TO PUBLIC

GO
*/
