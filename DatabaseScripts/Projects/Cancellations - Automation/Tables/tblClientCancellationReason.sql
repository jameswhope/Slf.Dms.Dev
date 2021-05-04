IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientCancellationReason')
	BEGIN
		DROP  Table tblClientCancellationReason
	END
GO

CREATE TABLE [dbo].[tblClientCancellationReason](
	[CancellationReasonId] [int] IDENTITY(1,1) NOT NULL,
	[CancellationReason] [varchar](100) NOT NULL,
	[CancellationCode] [varchar](5) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_tblClientCancellationReason] PRIMARY KEY CLUSTERED 
(
	[CancellationReasonId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO


