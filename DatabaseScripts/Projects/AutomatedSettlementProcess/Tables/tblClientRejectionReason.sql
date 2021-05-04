IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientRejectionReason')
	BEGIN
		DROP  Table tblClientRejectionReason
	END
GO

CREATE TABLE [dbo].[tblClientRejectionReason](
	[ReasonId] [int] IDENTITY(1,1) NOT NULL,
	[ReasonName] [varchar](50) NOT NULL,
	[ReasonDesc] [varchar](100) NULL,
 CONSTRAINT [PK_tblClientRejectionReason] PRIMARY KEY CLUSTERED 
(
	[ReasonId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblClientRejectionReason] UNIQUE NONCLUSTERED 
(
	[ReasonName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


GRANT SELECT ON tblClientRejectionReason TO PUBLIC

GO

