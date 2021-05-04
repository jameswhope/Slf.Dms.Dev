IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Switch_UserGroups_Insert')
	BEGIN
		DROP  procedure stp_Switch_UserGroups_Insert
	END
GO

CREATE procedure stp_Switch_UserGroups_Insert
   @UserId int,
   @UserGroupId int,
   @IsDefaultGroup int,
   @ByUserId int
AS
Insert into tblUserGroups(UserId, UserGroupId, IsDefaultGroup, Created, CreatedBy, LastModified, LastModifiedBy)
Values (@UserId, @UserGroupId, @IsDefaultGroup, GetDate(), @ByUserId, GetDate(), @ByUserId)

GO

