IF OBJECT_ID ('dbo.tr_tblPhoneCall', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_tblPhoneCall
GO

CREATE TRIGGER dbo.tr_PhoneCall
   ON dbo.tblPhoneCall
   AFTER INSERT, UPDATE
   NOT FOR REPLICATION
AS 
BEGIN
	declare @UserID int, @UserGroupID int, @PhoneCallID int

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		-- update
		select @PhoneCallID = PhoneCallID, @UserID = LastModifiedBy
		from deleted
	end
	else begin
		select @PhoneCallID = PhoneCallID, @UserID = LastModifiedBy
		from inserted
	end
	
	-- Get current group the last mod user currently belongs to and store it in the PhoneCall
	select @UserGroupID = UserGroupID from tblUser where UserID = @UserID
	
	update tblPhoneCall set UserGroupID = @UserGroupID where PhoneCallID = @PhoneCallID

END
GO  