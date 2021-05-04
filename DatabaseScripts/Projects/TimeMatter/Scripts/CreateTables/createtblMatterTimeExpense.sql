 

/*** add tblMatterTimeExpense for storing time expense entry  ****/
/*** Revision 01/06/2010 ****/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblMatterTimeExpense')
BEGIN
 

CREATE TABLE [dbo].[tblMatterTimeExpense](
	[MatterTimeExpenseId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NULL,
	[TimeExpenseDatetime] [datetime] NULL,
	[TimeExpenseDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillableTime] [decimal](2, 0) NULL,
	[BillRate] [money] NULL,
	[AttorneyId] [int] NULL,
	[CreateDatetime] [datetime] NULL,
	[Createdby] [int] NULL,
	[Note] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblMatterTimeExpense] PRIMARY KEY CLUSTERED 
(
	[MatterTimeExpenseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



END