/****** Object:  StoredProcedure [dbo].[stp_Permissions_UserPage_Get]    Script Date: 11/19/2007 15:27:31 ******/
DROP PROCEDURE [dbo].[stp_Permissions_UserPage_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_UserPage_Get]
	(
		@pagename nvarchar(255),
		@userid int
	)

as

select 
	tblcontrolfunction.functionid,
	tblcontrol.servername,
	tblcontrol.permissiontypeid,
	tblcontrol.action
into
	#tblpagefunctions
from
	tblpage inner join
	tblcontrol on tblpage.pageid=tblcontrol.pageid inner join
	tblcontrolfunction on tblcontrol.controlid=tblcontrolfunction.controlid
where
	tblpage.servername=@pagename


/*
level definition:
	0 - user level
	1 - group level
	2 - user type level
*/

declare @usertypeid int
set @usertypeid=(select usertypeid from tbluser where userid=@userid)

--get all permissions for this page/user combination
select
	tblfunction.parentfunctionid,
	tblpermission.*,
	0 as [level] 
from
	tbluserpermission inner join
	tblpermission on tbluserpermission.permissionid=tblpermission.permissionid inner join
	tblfunction on tblpermission.functionid=tblfunction.functionid
where
	tblfunction.functionid in (select functionid from #tblpagefunctions) and
	tbluserpermission.userid=@userid 

union

--get all permissions for this page/usertype/group combination
select
	tblfunction.parentfunctionid,
	tblpermission.*,
	1 as [level]
from
	tblgrouppermission inner join
	tblpermission on tblgrouppermission.permissionid=tblpermission.permissionid inner join
	tblfunction on tblpermission.functionid=tblfunction.functionid

where
	tblfunction.functionid in (select functionid from #tblpagefunctions) and
	--tblgrouppermission.usertypeid = @usertypeid and
	tblgrouppermission.usergroupid in --easily convertable to a one-to-many with users/groups
		(select usergroupid from tbluser where tbluser.userid=@userid and usergroupid is not null)

union

--get all permissions for this page/usertype combination (null group)
select
	tblfunction.parentfunctionid,
	tblpermission.*,
	2 as [level]
from
	tblgrouppermission inner join
	tblpermission on tblgrouppermission.permissionid=tblpermission.permissionid inner join
	tblfunction on tblpermission.functionid=tblfunction.functionid

where
	tblfunction.functionid in (select functionid from #tblpagefunctions) and
	tblgrouppermission.usertypeid = @usertypeid and
	tblgrouppermission.usergroupid is null


--get all defined controls for this page, with associated functionid
select servername as controlname, functionid, permissiontypeid, action from #tblpagefunctions

drop table #tblpagefunctions
GO
