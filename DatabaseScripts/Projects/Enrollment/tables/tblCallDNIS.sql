IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCallDNIS')
	BEGIN
		 CREATE TABLE tblCallDNIS(
			[CallId] [bigint] IDENTITY(1,1) NOT NULL,
			[CallIdKey] [varchar](50) NULL,
			[DNIS] [varchar](50) NULL,
			[Created] [datetime] NOT NULL CONSTRAINT [DF_tblCallDNIS_Created]  DEFAULT (getdate())
		) ON [PRIMARY]
	END
GO
