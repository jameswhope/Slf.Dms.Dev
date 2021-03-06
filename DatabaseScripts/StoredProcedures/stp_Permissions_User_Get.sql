/****** Object:  StoredProcedure [dbo].[stp_Permissions_User_Get]    Script Date: 11/19/2007 15:27:29 ******/
DROP PROCEDURE [dbo].[stp_Permissions_User_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_Permissions_User_Get]
	(
		@userid int
	)

as

/*
level definition:
	0 - user level
	1 - group level
	2 - user type level
*/

declare @usertypeid int
set @usertypeid=(select usertypeid from tbluser where userid=@userid)

--get all permissions for this user
select
	tblfunction.parentfunctionid,
	tblpermission.*,
	0 as [level] 
from
	tbluserpermission inner join
	tblpermission on tbluserpermission.permissionid=tblpermission.permissionid inner join
	tblfunction on tblpermission.functionid=tblfunction.functionid
where
	tbluserpermission.userid=@userid 

union

--get all permissions for this usertype/group combination
select
	tblfunction.parentfunctionid,
	tblpermission.*,
	1 as [level]
from
	tblgrouppermission inner join
	tblpermission on tblgrouppermission.permissionid=tblpermission.permissionid inner join
	tblfunction on tblpermission.functionid=tblfunction.functionid

where
	tblgrouppermission.usertypeid = @usertypeid and
	tblgrouppermission.usergroupid in --easily convertable to a one-to-many with users/groups
		(select usergroupid from tbluser where tbluser.userid=@userid and usergroupid is not null)

union

--get all permissions for this usertype (null group)
select
	tblfunction.parentfunctionid,
	tblpermission.*,
	2 as [level]
from
	tblgrouppermission inner join
	tblpermission on tblgrouppermission.permissionid=tblpermission.permissionid inner join
	tblfunction on tblpermission.functionid=tblfunction.functionid

where
	tblgrouppermission.usertypeid = @usertypeid and
	tblgrouppermission.usergroupid is null
GO
