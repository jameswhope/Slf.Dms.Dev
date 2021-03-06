/****** Object:  StoredProcedure [dbo].[job_MorningRebalanceClients]    Script Date: 11/19/2007 15:26:49 ******/
/****** Object:  StoredProcedure [dbo].[job_MorningRebalanceClients]    Script modified by J Hope Date: 05/22/2008 10:10:00 ******/
DROP PROCEDURE [dbo].[job_MorningRebalanceClients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[job_MorningRebalanceClients]
	
AS

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
GO
