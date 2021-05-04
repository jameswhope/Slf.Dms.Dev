IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerGroup')
	BEGIN
		CREATE TABLE tblDialerGroup(
			DialerGroupId int not null Primary Key,
			DialerGroupName varchar(50) not null unique
		)

	END
GO

