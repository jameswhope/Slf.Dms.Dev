
/* Adding a user account that will only see clients added from 1/1/2008 to present */
if not exists (select 1 from tblUser where username = 'debtchoice08') begin
	declare @OrigUserID int, @UserID int, @CompanyIds varchar(20)

	select @OrigUserID = UserID from tblUser where username = 'debtchoice'

	insert tblUser (username, [password], firstname, lastname, emailaddress, superuser, locked, temporary, [system], created, createdby, lastmodified, lastmodifiedby, usertypeid, usergroupid, commrecid)
	select 'debtchoice08', [password], firstname, lastname, emailaddress, superuser, locked, temporary, [system], getdate(), createdby, getdate(), lastmodifiedby, usertypeid, usergroupid, commrecid
	from tblUser
	where UserId = @OrigUserId

	select @UserID = scope_identity()
	select @CompanyIds = CompanyIds from tblUserCompany where UserId = @OrigUserId

	insert tblUserCompany (UserID, CompanyIds) 
	values (@UserID, @CompanyIds)

	insert tblUserPermission (UserId, PermissionId)
	select @UserID, PermissionId
	from tblUserPermission
	where UserId = @OrigUserID
end
