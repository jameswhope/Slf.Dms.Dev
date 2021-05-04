
CREATE TABLE [dbo].[tblBadEmails]
(
	[Email] [varchar](100) NOT NULL,
	[Source] [varchar](100) NULL,
	[PubId] [varchar](50) NULL,
	[Added] [datetime] NOT NULL CONSTRAINT [DF__tblBadEma__Added__6B7230A1]  DEFAULT (getdate())
)