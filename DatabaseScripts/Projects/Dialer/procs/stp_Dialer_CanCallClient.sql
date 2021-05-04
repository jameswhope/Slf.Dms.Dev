IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_CanCallClient')
	BEGIN
		DROP  Procedure  stp_Dialer_CanCallClient
	END

GO

CREATE Procedure stp_Dialer_CanCallClient
@clientid int
AS
Begin
		
	Select CanCallClient = Case When DialerResumeAfter is null or DialerResumeAfter  < GetDate() Then 1 Else 0 End
	From tblClient
	Where ClientId = @ClientId
	
	
End

GO

 