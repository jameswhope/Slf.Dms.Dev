IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentReasonHeader')
	BEGIN
		drop table tblHarassmentReasonHeader
	END


	CREATE TABLE [dbo].[tblHarassmentReasonHeader](
			[ReasonHeaderID] [int] IDENTITY(1,1) NOT NULL,
			[ReasonHeaderValue] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[ReasonHeaderOrder] [int] NULL,
			[ReasonHeaderDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		 CONSTRAINT [PK_tblHarassmentReasonHeader] PRIMARY KEY CLUSTERED 
		(
			[ReasonHeaderID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

		set Identity_insert tblHarassmentReasonHeader ON
		insert into tblHarassmentReasonHeader (reasonheaderid,Reasonheadervalue,reasonheaderorder, reasonheaderdescription) values (1,'I spoke to the person who called.',1,'spoke')
		insert into tblHarassmentReasonHeader (reasonheaderid,Reasonheadervalue,reasonheaderorder, reasonheaderdescription) values (2,'The person who called left a message.',2,'message')
		insert into tblHarassmentReasonHeader (reasonheaderid,Reasonheadervalue,reasonheaderorder, reasonheaderdescription) values (3,'Received Mail.',3,'mail')
		insert into tblHarassmentReasonHeader (reasonheaderid,Reasonheadervalue,reasonheaderorder, reasonheaderdescription) values (4,'The person came to my door.',4,'door')
		set Identity_insert tblHarassmentReasonHeader OFF