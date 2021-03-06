
/****** Object:  Table [dbo].[tblMatterTimeExpense]    Script Date: 02/24/2010 09:27:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMatterTimeExpense](
	[MatterTimeExpenseId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NULL,
	[TimeExpenseDatetime] [datetime] NULL,
	[TimeExpenseDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillableTime] [decimal](4, 2) NULL,
	[BillRate] [money] NULL,
	[AttorneyId] [int] NULL,
	[CreateDatetime] [datetime] NULL,
	[Createdby] [int] NULL,
	[Note] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntryTypeId] [int] NULL,
 CONSTRAINT [PK_tblMatterTimeExpense] PRIMARY KEY CLUSTERED 
(
	[MatterTimeExpenseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF