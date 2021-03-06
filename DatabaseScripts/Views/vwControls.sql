/****** Object:  View [dbo].[vwControls]    Script Date: 11/19/2007 14:47:51 ******/
DROP VIEW [dbo].[vwControls]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwControls]
AS
SELECT     dbo.tblControl.ServerName AS ControlName, dbo.tblFunction.FullName AS FunctionName, dbo.tblControlFunction.ControlId, 
                      dbo.tblControlFunction.ControlFunctionId, dbo.tblFunction.FunctionId, dbo.tblControl.PageId, dbo.tblPage.ServerName AS PageName
FROM         dbo.tblControl INNER JOIN
                      dbo.tblControlFunction ON dbo.tblControl.ControlId = dbo.tblControlFunction.ControlId INNER JOIN
                      dbo.tblFunction ON dbo.tblControlFunction.FunctionId = dbo.tblFunction.FunctionId INNER JOIN
                      dbo.tblPage ON dbo.tblControl.PageId = dbo.tblPage.PageId
GO
