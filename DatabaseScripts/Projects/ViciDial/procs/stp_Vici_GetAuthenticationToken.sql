IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetAuthenticationToken')
	BEGIN
		DROP  Procedure  stp_Vici_GetAuthenticationToken
	END

GO

CREATE Procedure stp_Vici_GetAuthenticationToken
@username varchar(50),
@password varchar(50)
AS
Select password from tbluser where username = @username and password = @password

GO


