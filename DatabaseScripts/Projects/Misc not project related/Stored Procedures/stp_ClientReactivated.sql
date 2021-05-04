IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientReactivated')
	BEGIN
		DROP  Procedure  stp_ClientReactivated
	END

GO

-- =============================================
-- Author:		Jim Hope
-- Create date: 04/07/2010
-- Description:	Client has gone from Pending Cancellation to active
-- =============================================
CREATE PROCEDURE stp_ClientReactivated 
	@ClientID int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AccountID AS integer
	DECLARE @PreviousStatus AS integer 
	DECLARE @AccountStatusID AS integer

	DECLARE c_PC CURSOR for
	SELECT AccountID, PreviousStatus, AccountStatusID 
	FROM tblAccount
	WHERE AccountStatusID NOT IN (55,54,157,158,159,160,164,166)
	AND ClientID = @ClientID 

	OPEN c_PC
	FETCH NEXT FROM c_PC INTO @AccountID, @PreviousStatus, @AccountStatusID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		UPDATE tblAccount 
		SET AccountStatusID = @PreviousStatus
		WHERE AccountID = @AccountID
	FETCH NEXT FROM c_PC INTO @AccountID, @PreviousStatus, @AccountStatusID
	END

	CLOSE c_PC
	DEALLOCATE c_PC
END
GO

/*
GRANT EXEC ON stp_ClientReactivated TO PUBLIC

GO
*/

