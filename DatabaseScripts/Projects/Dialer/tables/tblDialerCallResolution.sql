--drop table tblDialerCallResolution
IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerCallResolution')
	BEGIN
		CREATE TABLE tblDialerCallResolution
		(
		   CallResolutionId int not null identity(1,1) Primary Key,
		   CallMadeId int not null,
		   ReasonId int not null,
		   TableName varchar(50) null,
		   FieldName varchar(50) null,
		   FieldValue varchar(20) null,
		   Created datetime not null default GetDate(),
		   CreatedBy int not null,
		   Expiration datetime null,
		   RecordingId int null,
		   LastModified datetime not null,
		   LastModifiedBy int not null
		)
	END
GO

