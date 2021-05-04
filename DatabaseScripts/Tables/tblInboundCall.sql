IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblInboundCall')
	BEGIN
		CREATE TABLE tblInboundCall
		(
		   InboundCallId bigint identity(1,1) Primary key,
		   ClientId int,
		   UserId int,
		   CallId bigint,
		   CallTime datetime default GetDate() 
		)
	END
GO

