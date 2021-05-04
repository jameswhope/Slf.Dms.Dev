IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentlReasonType')
	BEGIN
		drop table tblHarassmentlReasonType
	END

	CREATE TABLE [dbo].[tblHarassmentlReasonType](
			[ReasonTypeID] [int] IDENTITY(1,1) NOT NULL,
			[ReasonType] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		 CONSTRAINT [PK_tblHarassmentlReasonType] PRIMARY KEY CLUSTERED 
		(
			[ReasonTypeID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

		set Identity_insert tblHarassmentlReasonType ON
		INSERT INTO [tblHarassmentlReasonType] (ReasonTypeID,[ReasonType]) VALUES (1,'RADIO')
		INSERT INTO [tblHarassmentlReasonType] (ReasonTypeID,[ReasonType]) VALUES (2,'TEXT')
		INSERT INTO [tblHarassmentlReasonType] (ReasonTypeID,[ReasonType]) VALUES (3,'DATE')
		INSERT INTO [tblHarassmentlReasonType] (ReasonTypeID,[ReasonType]) VALUES (4,'MULTITEXT')
		INSERT INTO [tblHarassmentlReasonType] (ReasonTypeID,[ReasonType]) VALUES (5,'CHECK')
		INSERT INTO [tblHarassmentlReasonType] (ReasonTypeID,[ReasonType]) VALUES (6,'CHECKHEADER')
		set Identity_insert tblHarassmentlReasonType OFF