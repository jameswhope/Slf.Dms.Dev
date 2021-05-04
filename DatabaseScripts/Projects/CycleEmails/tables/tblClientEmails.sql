
if object_id('tblClientEmails') is null begin 
	CREATE TABLE [dbo].[tblClientEmails]
	(
		[ClientEmailID] [int] IDENTITY(1,1) NOT NULL,
		[ClientID] [int] NOT NULL,
		[Email] [varchar](100) NOT NULL,
		[Subject] [varchar](1000) NOT NULL,
		[Body] [varchar](max) NULL,
		[Type] [varchar](30) NULL,
		[DateSent] [datetime] default(getdate()) NOT NULL,
		[SentBy] [int] NULL,
		[DateRead] [datetime] NULL,
		primary key (ClientEmailID),
		foreign key (ClientID) references tblClient(ClientID) on delete cascade
	)
end