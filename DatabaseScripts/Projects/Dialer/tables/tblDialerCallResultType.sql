IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerCallResultType')
	BEGIN
		 CREATE TABLE tblDialerCallResultType
		(
		   ResultTypeId int not null Primary Key,
		   Result varchar(50) not null,
		   Description varchar(255)Not Null,
		   DefaultExpiration int not null 
		)
	END
GO
