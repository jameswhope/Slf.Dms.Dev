IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientExpenses')
	BEGIN
		DROP  Table tblClientExpenses
	END
GO

CREATE TABLE [dbo].[tblClientExpenses](
	[ClientExpenseID] [int] IDENTITY(1,1) NOT NULL,
	[ClientHardShipID] [int] NOT NULL,
	[ClientRelationTypeID] [int] NULL,
	[ClientExpenseTypeID] [int] NOT NULL,
	[ExpenseAmount] [money] NOT NULL CONSTRAINT [DF_tblClientExpenses_ExpenseAmount]  DEFAULT ((0.00)),
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblClientExpenses_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL CONSTRAINT [DF_tblClientExpenses_LastModified]  DEFAULT (getdate()),
	[LastModifiedBy] [int] NOT NULL,
	[Deleted] [datetime] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_tblClientExpenses] PRIMARY KEY CLUSTERED 
(
	[ClientExpenseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GRANT SELECT ON tblClientExpenses TO PUBLIC

