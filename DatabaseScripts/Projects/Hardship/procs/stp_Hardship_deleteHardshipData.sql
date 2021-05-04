IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Hardship_deleteHardshipData')
	BEGIN
		DROP  Procedure  stp_Hardship_deleteHardshipData
	END

GO

CREATE Procedure stp_Hardship_deleteHardshipData
(
@clientID int
)
as
BEGIN
	--DELETE FROM tblHardshipData WHERE ClientID = @clientid
END

GO


GRANT EXEC ON stp_Hardship_deleteHardshipData TO PUBLIC

GO





