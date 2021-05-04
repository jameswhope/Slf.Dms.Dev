--drop table tblDialerCall
IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerCall')
	BEGIN
		Create Table tblDialerCall(
			CallMadeId int identity (1,1) not null Primary Key,
			ClientId int not null,
			PhoneId int not null,
			Started datetime not null default Getdate(),
			Ended datetime null,
			ResultId int null,
			Exception varchar(max) null,
			ReasonId int not null,
			WorkGroupQueueId int Not null,
			CallIdKey varchar(50) null,
			RetryAfter datetime null,
			AnsweredDate datetime null,
			AnsweredBy int null,
			LastModified datetime null,
			LastModifiedBy int null,
			CreatedBy int not null default 30
		)
		
	END
GO


