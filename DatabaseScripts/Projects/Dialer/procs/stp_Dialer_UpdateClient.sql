IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateClient')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateClient
	END

GO

CREATE Procedure stp_Dialer_UpdateClient
@ClientId int,
@DialerResumeAfter datetime = null
AS
Update tblClient Set
DialerResumeAfter = isnull(@DialerResumeAfter, DialerResumeAfter)
Where ClientId = @ClientId


GO

 

