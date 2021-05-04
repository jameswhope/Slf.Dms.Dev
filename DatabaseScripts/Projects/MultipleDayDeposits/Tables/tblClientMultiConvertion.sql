IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientMultiConvertion')
	BEGIN
		 CREATE TABLE tblClientMultiConvertion
		 (ConvertionId int identity(1,1) Primary Key,
		  ClientID int not null,
		  Result varchar(20) not null,
		  Note varchar(max) null,
		  ConvertedDate datetime not null,
		  ConvertedBy int not null
		  )
	END
GO



 