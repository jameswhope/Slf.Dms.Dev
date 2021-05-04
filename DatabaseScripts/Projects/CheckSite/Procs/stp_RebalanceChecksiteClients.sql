IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_RebalanceChecksiteClients')
	BEGIN
		DROP  Procedure  stp_RebalanceChecksiteClients
	END

GO

CREATE Procedure stp_RebalanceChecksiteClients
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ClientID INT	
	
	DECLARE ClientCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT ClientID 
	FROM tblClient
	WHERE TrustId = 22

	OPEN ClientCursor
		FETCH NEXT FROM ClientCursor INTO @ClientID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC stp_DoRegisterRebalanceClient @ClientID
			FETCH NEXT FROM ClientCursor INTO @ClientID
		END
	CLOSE ClientCursor
	DEALLOCATE ClientCursor
END

GO

