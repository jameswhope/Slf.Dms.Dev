
if object_id('tblBulkEmailPrint') is null begin
	CREATE TABLE [dbo].[tblBulkEmailPrint]
	(
		[BulkEmailPrintID] [int] IDENTITY(1,1) NOT NULL,
		[SentByUID] [int] NOT NULL,
		[SentOn] [datetime] NOT NULL CONSTRAINT [DF_tblBulkEmailPrint_SentOn]  DEFAULT (getdate()),
		[SentTo] [varchar](150) NOT NULL,
		[ListName] [varchar](150) NOT NULL,
		[RelayTo] [varchar](150) NULL,
		[RelayFrom] [varchar](150) NULL,
		[RelaySubject] [varchar](150) NULL,
		[RelayNote] [varchar](max) NULL,
		[RelayExpires] [int] NULL,
		[RelayFilePath] [varchar](max) NULL,
		[RelayBatchGUID] [varchar](max) NULL,
		[RelayPassCode] [nvarchar](50) NULL
	)
end