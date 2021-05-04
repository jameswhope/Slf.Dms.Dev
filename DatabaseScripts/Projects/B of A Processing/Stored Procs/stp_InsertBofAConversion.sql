IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertBofAConversion')
	BEGIN
		DROP  Procedure  stp_InsertBofAConversion
	END

GO

CREATE PROCEDURE [dbo].[stp_InsertBofAConversion] 
	@ClientID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE tblClient SET BofAConversion = getdate() WHERE ClientID = @ClientID
END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

