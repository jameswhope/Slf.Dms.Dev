IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateCreditorInfo')
	BEGIN
		DROP  Procedure  stp_UpdateCreditorInfo
	END

GO

CREATE Procedure stp_UpdateCreditorInfo
(@accountid int)
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS


GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

