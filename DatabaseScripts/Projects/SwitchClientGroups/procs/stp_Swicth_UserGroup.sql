IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Switch_UserGroup')
	BEGIN
		DROP  Procedure  stp_Switch_UserGroup
	END

GO

CREATE Procedure stp_Switch_UserGroup
@UserId int,
@UserGroupId int,
@ByUserId int
AS
Update tblUser Set
UserGroupId = @UserGroupId,
LastModified = GetDate(),
LastModifiedBy = @ByUserId
Where UserId = @UserId

GO

 

