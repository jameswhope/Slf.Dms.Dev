/****** Object:  StoredProcedure [dbo].[stp_Permissions_GroupFunctionFunctions_Get]    Script Date: 11/19/2007 15:27:29 ******/
DROP PROCEDURE [dbo].[stp_Permissions_GroupFunctionFunctions_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_GroupFunctionFunctions_Get]
	(
		@usergroupid int,
		@parentfunctionid int
	)

as

select
	tblfunction.functionid,
	tblfunction.parentfunctionid,
	tblfunction.[name] as functionname,
	tblfunction.isoperation,
	issystem,
	tblpermission.permissiontypeid,
	tblpermission.value,
	(select count(*) from tblfunction a where a.parentfunctionid=tblfunction.functionid and not issystem=1) as numchildren
from
	tblfunction inner join
	tblpermission on tblpermission.functionid=tblfunction.functionid inner join
	tblgrouppermission on tblgrouppermission.permissionid=tblpermission.permissionid 
where
	tblgrouppermission.usergroupid=@usergroupid and
	tblfunction.parentfunctionid=@parentfunctionid

union

select
	functionid,
	parentfunctionid,
	name as functionname,
	isoperation,	
	issystem,
	null as permissiontypeid,
	null as value,
	(select count(*) from tblfunction a where a.parentfunctionid=tblfunction.functionid and not issystem=1) as numchildren
from
	tblfunction
where
	tblfunction.parentfunctionid=@parentfunctionid
GO
