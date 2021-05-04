IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextClient4Queue')
	BEGIN
		DROP  Procedure  stp_Dialer_GetNextClient4Queue
	END

GO

CREATE Procedure stp_Dialer_GetNextClient4Queue
@SQL Varchar(Max)
AS
Begin	

	EXEC(@SQL) 
	
			
End
GO


