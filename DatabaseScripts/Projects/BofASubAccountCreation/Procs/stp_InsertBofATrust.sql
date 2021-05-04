IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertBofATrust')
	BEGIN
		DROP  Procedure  stp_InsertBofATrust
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/06/2009
-- Description:	Insert new Trust ID for B of A clients
-- =============================================
CREATE PROCEDURE stp_InsertBofATrust 
	@ClientID int = 0, 
	@TrustID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE tblClient SET TrustID = @TrustID WHERE ClientID = @ClientID OR TrustID = @TrustID

END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

