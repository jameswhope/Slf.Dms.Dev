IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientPendingCancellation')
	BEGIN
		DROP  Procedure  stp_ClientPendingCancellation
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 04/07/2010
-- Description:	Changes creditor account statusis to NR - Pending cancellation
-- =============================================
CREATE PROCEDURE stp_ClientPendingCancellation 
	@ClientID int 
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @AccountID AS integer
	DECLARE @AccountStatusID AS integer 

	DECLARE c_PC CURSOR for
	SELECT AccountID, AccountStatusID 
	FROM tblAccount
	WHERE AccountStatusID NOT IN (55,54,157,158,159,160,164,166)
	AND ClientID = @ClientID 

	OPEN c_PC
	FETCH NEXT FROM c_PC INTO @AccountID, @AccountStatusID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		UPDATE tblAccount 
		SET AccountStatusID = 170, 
		SET PreviousStatus = @AccountStatusID
		WHERE AccountID = @AccountID
	FETCH NEXT FROM c_PC INTO @AccountID, @AccountStatusID
	END

	CLOSE c_PC
	DEALLOCATE c_PC
END


GO

/*
GRANT EXEC ON stp_ClientPendingCancellation TO PUBLIC

GO
*/

