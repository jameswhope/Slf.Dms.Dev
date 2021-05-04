IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCallRecording')
	BEGIN
		DROP  Procedure  stp_InsertCallRecording
	END

GO

CREATE Procedure stp_InsertCallRecording
@CallIdKey varchar(20),
@RecCallIdKey varchar(20) = null,
@RecFile varchar(1000) = null,
@Reference varchar(20) = null,
@ReferenceId int = null,
@DocTypeId nvarchar(50) = null,
@UserId int = null
AS
Begin
	Insert Into tblCallRecording(CallIdKey, RecCallIdKey, RecFile, Reference, ReferenceId, DocTypeId, Created, CreatedBy)
	Values (@CallIdKey, @RecCallIdKey, @RecFile, @Reference, @ReferenceId, @DocTypeId, GetDate(), @UserId)
	Select scope_identity()  
End
			

GO



