﻿IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentData')
	BEGIN
		CREATE TABLE [dbo].[tblHarassmentData](
			[HarassmentID] [int] IDENTITY(1,1) NOT NULL,
			[ClientSubmissionID] [int] NULL,
			[HeaderID] [int] NULL,
			[ReasonTypeID] [int] NULL,
			[ReasonID] [int] NULL,
			[ReasonData] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		 CONSTRAINT [PK_tblHarassmentData] PRIMARY KEY CLUSTERED 
		(
			[HarassmentID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

	END
GO

