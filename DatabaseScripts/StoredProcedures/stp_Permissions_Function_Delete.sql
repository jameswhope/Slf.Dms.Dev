/****** Object:  StoredProcedure [dbo].[stp_Permissions_Function_Delete]    Script Date: 11/19/2007 15:27:28 ******/
DROP PROCEDURE [dbo].[stp_Permissions_Function_Delete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[stp_Permissions_Function_Delete]
	(
		@functionid int
	)

as

--delete controls which are the only for this function
delete from tblcontrol where 
	controlid in (select tblcontrolfunction.controlid from tblcontrolfunction where tblcontrolfunction.functionid=@functionid) and
	(select count (*) from tblcontrolfunction where controlid=tblcontrol.controlid and not functionid=@functionid)=0

--delete the links to those controls
delete from tblcontrolfunction where functionid=@functionid

--delete the function
delete from tblfunction where functionid=@functionid

--delete any defined permissions for this function
delete from tbluserpermission where permissionid in(select permissionid from tblpermission where functionid=@functionid)
delete from tblgrouppermission where permissionid in(select permissionid from tblpermission where functionid=@functionid)
delete from tblpermission where functionid=@functionid
GO
