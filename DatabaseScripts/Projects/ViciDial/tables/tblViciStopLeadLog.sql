 drop table tblViciStopLeadRequestLog;
 
 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciStopLeadRequestLog')
 BEGIN
	CREATE TABLE  tblViciStopLeadRequestLog(
		LogId [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		LeadId [int] NOT NULL,
		SourceId Varchar(50) NOT NULL,
		Created [datetime] NOT NULL Default GetDate(),
		LastModified [datetime] NOT NULL Default GetDate(),
		RequestingProcess varchar(100) NOT NULL,
		Processed [datetime] NULL,
		Stopped bit NOT NULL Default 0,
		Note varchar(255) 
)	
  END