/****** Object:  StoredProcedure [dbo].[stp_Permissions_UserTypeFunctionFunctions_Get]    Script Date: 11/19/2007 15:27:32 ******/
DROP PROCEDURE [dbo].[stp_Permissions_UserTypeFunctionFunctions_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[stp_Permissions_UserTypeFunctionFunctions_Get]
	(
		@usertypeid int,
		@parentfunctionid int
	)

as

select
	tblfunction.functionid,
	tblfunction.parentfunctionid,
	tblfunction.[name] as functionname,
	tblfunction.isoperation,
	tblpermission.permissiontypeid,
	tblpermission.value,
	issystem,
	(select count(*) from tblfunction a where a.parentfunctionid=tblfunction.functionid) as numchildren
from
	tblfunction inner join
	tblpermission on tblpermission.functionid=tblfunction.functionid inner join
	tblgrouppermission on tblgrouppermission.permissionid=tblpermission.permissionid 
where
	tblgrouppermission.usertypeid=@usertypeid and
	tblgrouppermission.usergroupid is null and
	tblfunction.parentfunctionid=@parentfunctionid

union

select
	functionid,
	parentfunctionid,
	name as functionname,
	isoperation,	
	null as permissiontypeid,
	null as value,
	issystem,
	(select count(*) from tblfunction a where a.parentfunctionid=tblfunction.functionid) as numchildren
from
	tblfunction
where
	tblfunction.parentfunctionid=@parentfunctionid
GO
