IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentDeclineReasons')
	BEGIN
		CREATE TABLE [tblHarassmentDeclineReasons](
		[HarassmentDeclineReasonID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
		[DeclineReasonDescription] [varchar](100) NULL,
		 CONSTRAINT [PK_tblHarassmentDeclineReasons] PRIMARY KEY CLUSTERED 
		(
			[HarassmentDeclineReasonID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	
	END
GO


GRANT SELECT ON tblHarassmentDeclineReasons TO PUBLIC

GO


INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Original Creditor')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Multiple Accounts UD')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('LOR < 14 days')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('No LOR')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('1 Call Only')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Client Cancelled')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Unable to Verify Creditor')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Not Harassment')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Current Litigation')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Missing Information on Intake')
INSERT INTO [tblHarassmentDeclineReasons]([DeclineReasonDescription])VALUES('Pending LC')

