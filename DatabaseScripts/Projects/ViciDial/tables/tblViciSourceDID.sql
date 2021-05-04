drop table tblViciSourceDID
 
 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciSourceDID')
 BEGIN	
	Create Table tblViciSourceDID(
		SourceId varchar(50) not null,
		DID varchar(20) not null
	)
 END
 
 GO
 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciSourceDID')
 BEGIN
	Delete  from tblViciSourceDID
 	Insert  into tblViciSourceDID(SourceId, DID) Values ('CID', '9095817437')
 	Insert  into tblViciSourceDID(SourceId, DID) Values ('CID', '9519344650')
 	Insert  into tblViciSourceDID(SourceId, DID) Values ('CID', '9519684375')
 END