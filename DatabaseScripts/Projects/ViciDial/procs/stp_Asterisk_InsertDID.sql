IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Asterisk_InsertDID')
	BEGIN
		DROP  Procedure  stp_Asterisk_InsertDID
	END

GO
/*
Script to add a DID to the System
*/
CREATE Procedure stp_Asterisk_InsertDID
@DID varchar(10),
@Department varchar(50),
@ViciSource varchar(50) = Null,
@BlackListAction int = 1,
@AnonymousAction int = 2,
@TollFreeNumber varchar(10) = NULL,
@UserId int = 30
AS
BEGIN

Declare @DepartmentId int

IF (@DID IS NULL OR LEN(@DID) <> 10 OR ISNUMERIC(@DID) <> 1)
BEGIN
	PRINT 'INVALID DID ' + isnull(@DID,'NONE') + '. DID HAS TO BE A 10 DIGIT NUMBER'
	RETURN -1
END

IF Not exists(Select DepartmentId from tblDepartment Where DepartmentName = @Department)
BEGIN
	PRINT 'INVALID DEPARTMENT ' + isnull(@Department,'NONE');
	RETURN -1
END
	Select @DepartmentId = DepartmentId from tblDepartment Where DepartmentName = @Department
	
	--DELETE IF EXISTS
	exec stp_Asterisk_DeleteDID @DID

	--CREATE
	Insert Into "DMF-SQL-0005".asterisk.dbo.tblDID(DID, AnonymousAction, BlackListAction) Values(@DID,@AnonymousAction,@BlackListAction)

	if (@TollFreeNumber is not null and LEN(RIGHT(@TollFreeNumber,10))=10)
		Insert Into "DMF-SQL-0005".asterisk.dbo.tblDIDTollFreeXref(DID, TollFreeNumber) values (@DID, RIGHT(@TollFreeNumber,10))
		
	Insert into tblDepartmentDID(DepartmentID, DID, CreatedBy) Values (@DepartmentId, @DID, @UserId)
	
	If Exists(Select SourceId from tblViciSource Where SourceId = @ViciSource)
		Insert Into tblViciSourceDID(SourceId, DID) Values (@ViciSource, @DID)
	Else
		PRINT 'Vici Source ' + isnull(@ViciSource, 'NONE') + ' Does not exists. ViciSource-DID relation not created.'

END

GO



