IF OBJECT_ID ('dbo.tr_tblNote', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_tblNote
GO

CREATE TRIGGER dbo.tr_Note
   ON dbo.tblNote
   AFTER INSERT, UPDATE
   NOT FOR REPLICATION
AS 
BEGIN
	declare @UserID int, @UserGroupID int, @NoteID int

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		-- update
		select @NoteID = NoteID, @UserID = LastModifiedBy
		from deleted
	end
	else begin
		select @NoteID = NoteID, @UserID = LastModifiedBy
		from inserted
	end
	
	-- Get current group the last mod user currently belongs to and store it in the note
	select @UserGroupID = UserGroupID from tblUser where UserID = @UserID
	
	update tblNote set UserGroupID = @UserGroupID where NoteID = @NoteID

END
GO 