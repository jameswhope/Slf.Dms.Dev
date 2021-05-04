IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentClient')
	BEGIN
		CREATE TABLE [dbo].[tblHarassmentClient](
			[ClientSubmissionID] [int] IDENTITY(1,1) NOT NULL,
			[ClientID] [int] NULL,
			[PersonID] [int] NULL,
			[ClientAccountNumber] [int] NULL,
			[ClientState] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[DateFormSubmitted] [datetime] NOT NULL CONSTRAINT [DF_tblHarassmentClient_DateFormSubmitted]  DEFAULT (getdate()),
			[OriginalCreditorID] [int] NULL,
			[SuedByCreditor] [bit] NULL,
			[CurrentCreditorID] [int] NULL,
			[Created] [datetime] NOT NULL CONSTRAINT [DF_tblHarassmentClient_Created]  DEFAULT (getdate()),
			[CreatedBy] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Method] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[NoticeOfRepMailDate] [datetime] NULL CONSTRAINT [DF_tblHarassmentClient_NoticeOfRepMailDate]  DEFAULT (NULL),
			[NoticeOfCeaseAndDesist] [datetime] NULL CONSTRAINT [DF_tblHarassmentClient_NoticeOfCeaseAndDesist]  DEFAULT (NULL),
			[CreditorUnAuthorizedCharges] [bit] NOT NULL CONSTRAINT [DF_tblHarassmentClient_CreditorUnAuthorizedCharges]  DEFAULT ((0)),
			[IndividualCallingName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[IndividualCallingIdentity] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[IndividualCallingPhone] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[IndividualCallingDateOfCall] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[IndividualCallingNumTimesCalled] [numeric](18, 0) NULL,
			[IndividualCallingTimeOfCall] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		 CONSTRAINT [PK_tblClientHarassment] PRIMARY KEY CLUSTERED 
		(
			[ClientSubmissionID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END

ALTER TABLE [tblHarassmentClient] ALTER COLUMN [IndividualCallingDateOfCall] varchar(500)
ALTER TABLE [tblHarassmentClient] ALTER COLUMN [IndividualCallingTimeOfCall] varchar(500)
ALTER TABLE [tblHarassmentClient] ADD [IndividualCallingNumberDialed] varchar(50) NULL

ALTER TABLE [tblHarassmentClient] ADD [HarassmentStatusID] [int] NULL
ALTER TABLE [tblHarassmentClient] ADD [HarassmentStatusDate] [datetime] NULL
ALTER TABLE tblHarassmentClient Add HarassmentDeclineReasonID int null
ALTER TABLE tblHarassmentClient Add CreditorAccountID int null
