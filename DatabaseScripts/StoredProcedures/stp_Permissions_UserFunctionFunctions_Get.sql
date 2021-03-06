/****** Object:  StoredProcedure [dbo].[stp_Permissions_UserFunctionFunctions_Get]    Script Date: 11/19/2007 15:27:30 ******/
DROP PROCEDURE [dbo].[stp_Permissions_UserFunctionFunctions_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_UserFunctionFunctions_Get]
	(
		@userid int,
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
	tbluserpermission on tbluserpermission.permissionid=tblpermission.permissionid
where
	tbluserpermission.userid=@userid and
	parentfunctionid=@parentfunctionid
	
union

select
	functionid,
	parentfunctionid,
	name as functionname,
	isoperation,	
	issystem,
	null as permissiontypeid,
	null as value,
	(select count(*) from tblfunction a where a.parentfunctionid=tblfunction.functionid) as numchildren
from
	tblfunction
where
	parentfunctionid=@parentfunctionid
GO
