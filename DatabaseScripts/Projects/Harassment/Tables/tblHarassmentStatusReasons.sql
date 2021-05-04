IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblHarassmentStatusReasons')
	BEGIN
		CREATE TABLE [tblHarassmentStatusReasons](
			[HarassmentStatusID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
			[StatusDescription] [varchar](100) NULL,
		 CONSTRAINT [PK_tblHarassmentStatusReasons] PRIMARY KEY CLUSTERED 
		(
			[HarassmentStatusID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
		
	END
GO



GRANT SELECT ON tblHarassmentStatusReasons TO PUBLIC
GO
/*
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Demand follow up')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Retainer follw up')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Send to LC')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Follow up with LC')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('SOL date')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Response Date')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Additional Creditors')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Attorney review')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Level')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Retainer Sent Date')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Decline letter date')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Disengage date')
INSERT INTO [tblHarassmentStatusReasons]([StatusDescription])VALUES('Cancelled client')
*/
delete from tblHarassmentStatusReasons;
GO
DBCC CHECKIDENT ('tblHarassmentStatusReasons', RESEED, 0);
GO
insert into tblHarassmentStatusReasons (StatusDescription) values('Decline Letter')
insert into tblHarassmentStatusReasons (StatusDescription) values('Demand Letter')
insert into tblHarassmentStatusReasons (StatusDescription) values('Add to Previous Submission')
insert into tblHarassmentStatusReasons (StatusDescription) values('Zwicker')
insert into tblHarassmentStatusReasons (StatusDescription) values('Territory')