IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AsteriskInsertConference')
	BEGIN
		DROP  Procedure  stp_AsteriskInsertConference
	END

GO

CREATE Procedure stp_AsteriskInsertConference
@CallId int,
@UserId int,
@PhoneNumber varchar(20),
@PhoneSystem varchar(50),
@CallerId varchar(20) = null
AS
BEGIN
	INSERT INTO tblAstConferenceCall(CallId,UserId,PhoneNumber,PhoneSystem,CallerId)
	VALUES (@CallId,@UserId,@PhoneNumber,@PhoneSystem,@CallerId)

	Select scope_identity()	
END

GO
 
