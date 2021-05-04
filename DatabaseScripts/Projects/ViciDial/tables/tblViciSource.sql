 drop table tblViciSource
 
 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciSource')
 BEGIN	
	Create Table tblViciSource(
		SourceId varchar(50) not null Primary Key Clustered,
		SourceName varchar(50) not null,
		DefaultPage varchar(100) null
	)
 END
 
 GO
 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciSource')
 BEGIN
	Delete  from tblViciSource
 	Insert  into tblViciSource(SourceId, SourceName, DefaultPage) Values ('CID', 'Leads', '~/clients/enrollment/default.aspx')
 END