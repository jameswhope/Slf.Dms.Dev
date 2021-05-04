IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Switch_SetDefaultUserGroup')
	BEGIN
		DROP  Procedure  stp_Switch_SetDefaultUserGroup
	END

GO

CREATE Procedure stp_Switch_SetDefaultUserGroup
@UserId int,
@DefaultGroupId int,
@ByUserId int
AS
Begin
Update tblUserGroups Set
IsDefaultGroup  = Case When UserGroupId = @DefaultGroupId Then 1 Else 0 End,
LastModified = GetDate(),
LastModifiedBy = @ByUserId
Where  UserID = @UserId
End

GO

 
