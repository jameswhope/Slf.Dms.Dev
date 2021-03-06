/****** Object:  View [dbo].[vwPermissions_UserFunctions]    Script Date: 11/19/2007 14:47:52 ******/
DROP VIEW [dbo].[vwPermissions_UserFunctions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPermissions_UserFunctions]
AS
SELECT     TOP 100 PERCENT dbo.tblPermission.Value, dbo.tblPermission.FunctionId, dbo.tblPermission.PermissionTypeId, dbo.tblUserPermission.UserId, 
                      dbo.tblPermission.PermissionID
FROM         dbo.tblPermission INNER JOIN
                      dbo.tblUserPermission ON dbo.tblPermission.PermissionID = dbo.tblUserPermission.PermissionId
ORDER BY dbo.tblPermission.FunctionId
GO
