 drop table tblViciDialerInsertLog;
 
 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciDialerInsertLog')
 BEGIN
	CREATE TABLE  tblViciDialerInsertLog(
		LogId [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		LeadId [int] NOT NULL,
		SourceId Varchar(50) NOT NULL,
		Created [datetime] NOT NULL Default GetDate(),
		ListId [int] NOT NULL,
		ViciCampaignId [varchar](8) NOT NULL,
		Action [varchar](10) NOT NULL)	
  END