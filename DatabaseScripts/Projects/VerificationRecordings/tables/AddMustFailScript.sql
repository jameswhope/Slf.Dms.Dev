 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVerificationQuestion')
 BEGIN
	IF col_length('tblVerificationQuestion', 'FailWhenNo') is null
		Alter table tblVerificationQuestion Add FailWhenNo bit not null default 1  
END