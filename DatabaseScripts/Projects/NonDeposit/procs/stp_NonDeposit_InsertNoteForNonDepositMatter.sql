IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertNoteForNonDepositMatter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_InsertNoteForNonDepositMatter
	END

GO

CREATE Procedure stp_NonDeposit_InsertNoteForNonDepositMatter
(
	@ClientId int,
	@MatterId int = null,
	@CreatedBy int,
	@TaskId int = null,
	@Note varchar(max),
	@DocTypeId nvarchar(15) = null,
	@DocId nvarchar(15) = null,
	@DateString nvarchar(6) = null,
	@SubFolder nvarchar(150) = null,
	@ReturnNoteId int output
)
AS
BEGIN
	DECLARE @Return INT
			,@NoteId INT					
			,@UserGroupId INT;
		

	SELECT @Return = 0,
		   @UserGroupId = (SELECT UserGroupId FROM tblUser WHERE UserId = @CreatedBy)

	BEGIN TRY
		--Insert note for client approval 
		INSERT INTO tblNote([Value], ClientId, Created, CreatedBy, LastModified, LastModifiedBy, UserGroupId)
		VALUES(@note,@ClientId, getDate(), @CreatedBy, getdate(), @CreatedBy, @UserGroupId)
			
		--associate with client, matter 
		SET @NoteId = SCOPE_IDENTITY();

		INSERT INTO tblNoteRelation(NoteId, RelationTypeId, RelationId)
		VALUES(@NoteId, 1, @ClientId)

		IF @MatterId is not null BEGIN
			INSERT INTO tblNoteRelation(NoteId, RelationTypeId, RelationId)
			VALUES(@NoteId, 19, @MatterId)
		END
		
		IF @TaskId is not null BEGIN
			--Associate the note to the task
			INSERT INTO tblTaskNote(NoteId, TaskId, Created, CreatedBy, LastModified, LastModifiedBy)
			VALUES(@NoteId, @TaskId, getdate(), @CreatedBy,getdate(), @CreatedBy)
		END

		IF @DocId is not null and @DocTypeId is not null and @DateString is not null BEGIN

			INSERT INTO tblDocRelation(ClientId, RelationId, RelationType, DocTypeId, DocId, 
							DateString, SubFolder, RelatedDate, RelatedBy, DeletedFlag)
			VALUES(@ClientId, @NoteId, 'note', @DocTypeId, @DocId, @DateString, @SubFolder, getdate(), @CreatedBy, 0)	
		END

		IF @DocId is not null and @DocTypeId is not null and @DateString is not null and @MatterId is not null BEGIN
			INSERT INTO tblDocRelation(ClientId, RelationId, RelationType, DocTypeId, DocId, 
							DateString, SubFolder, RelatedDate, RelatedBy, DeletedFlag)
			VALUES(@ClientId, @MatterId, 'matter', @DocTypeId, @DocId, @DateString, @SubFolder, getdate(), @CreatedBy, 0)
		END

		SET @ReturnNoteId = @NoteId
	END TRY
	BEGIN CATCH
		Print 'NOTE ' + ERROR_MESSAGE();
		SET @Return = -1;		
	END CATCH
		
	RETURN @Return;
END
GO



