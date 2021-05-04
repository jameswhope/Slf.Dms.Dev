IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTransUnionSettings')
	BEGIN
		DROP  Procedure  stp_GetTransUnionSettings
	END

GO

CREATE Procedure stp_GetTransUnionSettings
@TestMode bit
AS
Select top 1 *
From tblTUSettings
Where Active = 1
and  IsTest = @TestMode
Order by Created Desc
GO

 

