drop table tblAstCallLog
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAstCallLog')
	BEGIN
		CREATE  Table tblAstCallLog(
			CallId int not null identity(1,1) primary key clustered,
			Created datetime not null default GetDate(),
			UserId int not null,
			Phonenumber varchar(20) not null,
			CallIdKey varchar(50) null,
			BridgePeer varchar(50) null,
			Inbound bit not null default 0,
			RefType varchar(50) null,
			RefId int null,
			RefDate datetime null,
			RefBy int null,
			PhoneSystem varchar(50) null,
			CallerId varchar(20) null
		)
	END
GO

CREATE NONCLUSTERED INDEX [IX_tblAstCallLog] ON [dbo].[tblAstCallLog] 
(
	[CallId] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

