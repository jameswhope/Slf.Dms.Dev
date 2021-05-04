IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetLastC21BatchRequestDate')
	BEGIN
		DROP  Procedure  stp_GetLastC21BatchRequestDate
	END

GO

CREATE Procedure stp_GetLastC21BatchRequestDate
AS
	SELECT Max(RequestEndDate) AS [LastRequestDate] FROM tblC21Batch 

GO

