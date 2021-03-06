/****** Object:  View [dbo].[vwPermissions_GroupFunctions]    Script Date: 11/19/2007 14:47:52 ******/
DROP VIEW [dbo].[vwPermissions_GroupFunctions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPermissions_GroupFunctions]
AS
SELECT     TOP 100 PERCENT dbo.tblGroupPermission.UserTypeId, dbo.tblPermission.Value, dbo.tblPermission.FunctionId, 
                      dbo.tblPermission.PermissionTypeId, dbo.tblGroupPermission.UserGroupId
FROM         dbo.tblPermission INNER JOIN
                      dbo.tblGroupPermission ON dbo.tblPermission.PermissionID = dbo.tblGroupPermission.PermissionId
ORDER BY dbo.tblPermission.FunctionId
GO
