IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Asterisk_DeleteDID')
	BEGIN
		DROP  Procedure  stp_Asterisk_DeleteDID
	END

GO

CREATE Procedure stp_Asterisk_DeleteDID
@DID varchar(10)
AS
BEGIN
	Delete from "DMF-SQL-0005".asterisk.dbo.tblDIDTollFreeXref Where DID = @DID
	Delete from "DMF-SQL-0005".asterisk.dbo.tblDID Where DID = @DID
	Delete from tblDepartmentDID Where DID = @DID
	Delete from tblViciSourceDID Where DID = @DID
END

GO

 
