IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationSessionLog')
	BEGIN
		DROP  Table tblNegotiationSessionLog
	END
GO

CREATE TABLE [dbo].[tblNegotiationSessionLog](
	[LogID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[NegotiationSessionGUID] [uniqueidentifier] NOT NULL,
	[UserID] [int] NOT NULL,
	[LogSubject] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogText] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblNegotiationSessionLog_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LogInserted] [datetime] NULL CONSTRAINT [DF_tblNegotiationSessionLog_LogInserted]  DEFAULT (NULL),
	[NoteID] [int] NULL
) ON [PRIMARY]
GO


GRANT SELECT ON tblNegotiationSessionLog TO PUBLIC

GO

