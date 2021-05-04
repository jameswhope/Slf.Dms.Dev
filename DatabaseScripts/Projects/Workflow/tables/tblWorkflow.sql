IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblWorkflow')
	BEGIN
		DROP  Table tblWorkflow
	END
GO

CREATE TABLE [dbo].[tblWorkflow](
	[WorkFlowID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[WorkFlowName] [varchar](500) NOT NULL,
	[WorkFlowStepName] [varchar](500) NULL,
	[WorkFlowTaskID] [numeric](18, 0) NOT NULL,
	[WorkFlowSequence] [numeric](18, 0) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL

) ON [PRIMARY]
GO


GRANT SELECT ON tblWorkflow TO PUBLIC

GO

