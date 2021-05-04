IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientIncome')
	BEGIN
		DROP  Table tblClientIncome
	END
GO

CREATE TABLE [dbo].[tblClientIncome](
	[ClientIncomeID] [int] IDENTITY(1,1) NOT NULL,
	[ClientHardShipID] [int] NULL,
	[ClientRelationTypeID] [int] NULL,
	[IncomeTypeId] [int] NOT NULL,
	[JobDescription] [varchar](500) NULL,
	[IncomeAmount] [money] NOT NULL CONSTRAINT [DF_tblClientIncome_IncomeAmount]  DEFAULT ((0.00)),
	[FullTime] [bit] NOT NULL CONSTRAINT [DF_tblClientIncome_FullTime]  DEFAULT ((0)),
	[PartTime] [bit] NOT NULL CONSTRAINT [DF_tblClientIncome_PartTime]  DEFAULT ((0)),
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblClientIncome_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL CONSTRAINT [DF_tblClientIncome_LastModified]  DEFAULT (getdate()),
	[LastModifiedBy] [int] NOT NULL,
	[Deleted] [datetime] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_tblClientIncome] PRIMARY KEY CLUSTERED 
(
	[ClientIncomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT SELECT ON tblClientIncome TO PUBLIC

