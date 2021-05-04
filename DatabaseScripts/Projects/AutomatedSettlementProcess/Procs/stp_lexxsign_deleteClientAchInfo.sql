IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_deleteClientAchInfo')
	BEGIN
		DROP  Procedure  stp_lexxsign_deleteClientAchInfo
	END

GO

CREATE Procedure stp_lexxsign_deleteClientAchInfo
	(
		@AdHocAchID int
	)
AS
BEGIN
	delete from tbladhocach where AdHocAchID = @AdHocAchID
END



GRANT EXEC ON stp_lexxsign_deleteClientAchInfo TO PUBLIC

GO

