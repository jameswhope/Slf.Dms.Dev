IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTUSettings')
	BEGIN
		Create Table tblTUSettings(
			SettingId int not null Identity(1,1) Primary Key,
			[Name] varchar(30) not null,
			Created datetime not null default GetDate(),
			SubscriberCode varchar(20) not null,
			SubscriberPassword varchar(20) not null,
			ServiceUrl varchar(255) not null,
			IsTest bit not null default 1,
			Certificate varchar(20) not null,
			Active bit not null default 0,
			AccountName varchar(255) not null,
		)
		
		Insert Into tblTUSettings([Name], SubscriberCode, SubscriberPassword, ServiceUrl, IsTest, Certificate, Active, AccountName)
		Values ('TransUnion Test', '0622P4317945', 'JJ54', 'https://netaccess-test.transunion.com', 1, 'LAWOFFI4', 1 , 'LAW OFC OF T K MCKNIGHT')
		
		Insert Into tblTUSettings([Name], SubscriberCode, SubscriberPassword, ServiceUrl, IsTest, Certificate, Active, AccountName)
		Values ('TransUnion Production', '1201P2696421', 'X12N', 'https://netaccess.transunion.com', 0, 'LAWOFFI4', 1, 'THOMAS KERNS MCKNIGHT LLP' )
	END
GO

 