-- drop Table tblDialerCallReasonType
IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerCallReasonType')
	BEGIN
		 CREATE TABLE tblDialerCallReasonType
		(
		   ReasonId int not null Primary Key,
		   Description varchar(255) not null,
		   Priority int not null,
		   DefaultExpiration int not null,
		   WorkGroupQueueId int not null,
		   Active bit not null default 1,
		   PhoneTypeId int not null default 46,
		   GetClientsSP varchar(100)
		)
	END
GO


