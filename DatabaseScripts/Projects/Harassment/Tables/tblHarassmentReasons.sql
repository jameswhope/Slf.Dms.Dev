IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentReasons')
	BEGIN
		drop table tblHarassmentReasons 	
	END
	
	CREATE TABLE [dbo].[tblHarassmentReasons](
			[ReasonID] [int] IDENTITY(1,1) NOT NULL,
			[ReasonTypeID] [int] NULL,
			[ReasonHeaderID] [int] NULL,
			[ReasonOrder] [int] NULL,
			[Reason] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[ReasonLevel] [int] NULL,
		 CONSTRAINT [PK_tblReasons] PRIMARY KEY CLUSTERED 
		(
			[ReasonID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	
	
	set Identity_insert tblHarassmentReasons ON
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (1,1,3,1,'By Postcard',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (2,4,4,1,'Describe in Full Detail Contact with Creditor',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (3,2,1,1,'Individual Calling',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (4,6,19,1,'Employer',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (5,1,3,2,'Using words or symbols on the outside of the envelope they indicated they were trying to collect a debt.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (6,1,3,3,'That looked like it was from a court or attorney but was not.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (7,6,19,2,'Co-Workers',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (8,6,19,3,'Neighbors',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (9,6,19,4,'Friends',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (10,6,19,5,'Family Members',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (11,5,1,2,'Identified themselves as a bill collector.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (12,5,1,3,'Claimed to be law enforcement or conencted with federal, state or local government.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (13,5,1,4,'Claimed to be an Attorney or with an Attorney''s office.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (14,5,1,5,'Claimed to be employed by a Credit Bureau.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (15,5,1,6,'Other:',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (16,2,4,1,'Contacted Persons Name ',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (17,6,0,1,'Collector is calling you at home (before 8am or after 9pm).',1)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (18,6,0,2,'Collector is calling you at work.',1)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (19,6,0,3,'Collector is contacting third-parties with information regarding your debt(s).',1)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (20,6,0,4,'Collector is using abusive language.',1)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (21,6,0,5,'Collector is threatening you.',1)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (22,6,0,6,'Collector is Harassing you in another manner.',1)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (23,2,20,1,'Used obscene or profane language.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (24,6,21,1,'Used or threatened to use violence.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (25,6,21,2,'Harmed or threatened to harm you or another person (body, property or reputation).',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (26,6,21,3,'Threatened to sell your debt to a third party.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (27,6,21,4,'Threatened criminal prosecution if you did not give them a post dated check.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (28,6,21,5,'Threatened to take unlawful actions against you before judgement is taken.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (29,6,28,1,'Arrest',3)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (30,6,28,2,'Seizure of Property',3)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (31,6,28,3,'Job Loss',3)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (32,6,28,4,'Garnishment',3)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (33,6,22,1,'Said you committed a crime.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (34,6,22,2,'Published your name as a person who does not pay bills.',2)
	INSERT INTO [tblHarassmentReasons] (reasonid,[ReasonTypeID],[ReasonHeaderID],[ReasonOrder],[Reason],[ReasonLevel]) VALUES (35,6,22,3,'Listed your debt for sale to the public.',2)
	set Identity_insert tblHarassmentReasons OFF


