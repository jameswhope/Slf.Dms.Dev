IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PrepForStatemants')
	BEGIN
		DROP  Procedure  stp_PrepForStatements
	END

GO
-- =============================================
-- Author:		<Jim Hope>
-- Create date: <10/28/2009>
-- Description:	<If a client is marked as active and not resolved this routine resolves the client>
-- =============================================
CREATE Procedure stp_PrepForStatements
AS
BEGIN
	SET NOCOUNT ON;
declare @ClientID int
declare @Created smalldatetime

declare c_cursor cursor for
 select clientid from tblclient where currentclientstatusid = 14 and vwuwresolved is null

FETCH NEXT FROM c_cursor INTO @ClientID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @Created = (select top 1 Created from tblroadmap where clientstatusid = 14 AND clientid = @ClientID ORDER BY Created)
		if @Created IS NOT NULL
			BEGIN
				update tblclient set vwuwresolved = @Created, vwuwresolvedby = 24 WHERE clientid = @ClientID
			END
		else
			BEGIN
				update tblclient set vwuwresolved = getdate(), vwuwresolvedby = 24 WHERE clientid = @ClientID
			END
FETCH NEXT FROM c_cursor INTO @ClientID
	END

close c_cursor 
deallocate c_cursor 
END

GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

