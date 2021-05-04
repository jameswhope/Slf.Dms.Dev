IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'Stored_Procedure_Name')
	BEGIN
		DROP  Procedure  stp_GetMatterStatusByClient.sql
	END

GO

CREATE Procedure stp_GetMatterStatusByClient.sql
	@ClientID int
AS
BEGIN
	SET NOCOUNT ON;
	
SELECT MatterStatusCodeDescr FROM tblmatter m
JOIN tblmatterstatuscode ms ON ms.matterstatuscodeid = m.matterstatuscodeid
WHERE m.clientid = @ClientID
AND ms.mattersubstatuscodeid = 2

END
GO

/*
GRANT EXEC ON stp_GetMatterStatusByClient.sql TO PUBLIC

GO
*/

