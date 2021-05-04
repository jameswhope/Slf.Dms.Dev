IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCoAppsForBofA')
	BEGIN
		DROP  Procedure  stp_GetCoAppsForBofA
	END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/05/2009
-- Description:	Get Co-Apps for B of A
-- =============================================
CREATE PROCEDURE stp_GetCoAppsForBofA 
	-- Add the parameters for the stored procedure here
	@ClientID int
AS
		BEGIN
	SET NOCOUNT ON;
		SELECT p.FirstName + ' ' + p.LastName 
        from tblperson p 
        join tblClient c on c.clientid = p.clientid 
        where p.ClientID = @ClientID
        and p.personid <> c.primarypersonid 
END
GO
