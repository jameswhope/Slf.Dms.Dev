SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 05/01/2008
-- Description:	Rebalances all client transactions 
--              for all clients in one pass.
-- =============================================
ALTER PROCEDURE [dbo].[stp_RebalanceAllClients] 

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ClientID INT	
	
	DECLARE ClientCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT ClientID 
	FROM tblClient
	WHERE CurrentClientStatusID not in (15, 17, 18)

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