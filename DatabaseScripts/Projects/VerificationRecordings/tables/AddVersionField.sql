 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVerificationQuestion')
 BEGIN
	IF col_length('tblVerificationQuestion', 'VersionId') is null
		Alter table tblVerificationQuestion Add VersionId int not null default 1  
END