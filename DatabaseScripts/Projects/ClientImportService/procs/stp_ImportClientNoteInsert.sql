IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportClientNoteInsert')
	BEGIN
		DROP  Procedure  stp_ImportClientNoteInsert
	END

GO

CREATE Procedure stp_ImportClientNoteInsert
@Subject varchar(255) = null,
@Value varchar(5000),
@Created datetime,
@CreatedBy int,
@LastModified datetime,
@LastModifiedBy int,
@OldTable varchar(50) = null,
@OldId int = null,
@ClientId int 
AS
BEGIN

Insert Into tblNote(Subject, Value, Created, CreatedBy, LastModified, LastModifiedBy, OldTable, OldId, ClientID )
Values (@Subject, @Value, @Created, @CreatedBy, @LastModified, @LastModifiedBy, @OldTable, @OldId, @ClientID)
Select Scope_identity()
END

GO
