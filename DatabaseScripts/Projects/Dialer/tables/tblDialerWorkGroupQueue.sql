IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerWorkGroupQueue')
	BEGIN
		 CREATE TABLE tblDialerWorkGroupQueue(
		 QueueId int identity(1,1) not null Primary Key,
		 QueueName varchar(255) not null,
		 Extension varchar(10) not null,
		 Active bit not null default 0,
		 MaxLines  int not null default 1,
		 MaxAttempts int not null default 0,
		 CallStartDate datetime null default '1900-01-01 06:00:00',
		 CallStartTime datetime null default '1900-01-01 18:00:00',
		 CallEndTime datetime null,
		 DialerGroupId int not null default 1,
		 CallPerUserRatio int not null default 1
		) 
	END
GO
 