/****** Object:  StoredProcedure [dbo].[stp_Permissions_GroupFunctions_Get]    Script Date: 11/19/2007 15:27:29 ******/
DROP PROCEDURE [dbo].[stp_Permissions_GroupFunctions_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_GroupFunctions_Get]
	(
		@usergroupid int,
		@definedonly bit = 0
	)

as

select
	tblfunction.functionid,
	tblfunction.parentfunctionid,
	tblfunction.[name] as functionname,
	tblfunction.isoperation,
	issystem,
	tblpermission.permissiontypeid,
	tblpermission.value
from
	tblfunction inner join
	tblpermission on tblpermission.functionid=tblfunction.functionid inner join
	tblgrouppermission on tblgrouppermission.permissionid=tblpermission.permissionid
where
	tblgrouppermission.usergroupid=@usergroupid 

union

select
	functionid,
	parentfunctionid,
	name as functionname,
	isoperation,	
	issystem,
	null as permissiontypeid,
	null as value
from
	tblfunction
GO
