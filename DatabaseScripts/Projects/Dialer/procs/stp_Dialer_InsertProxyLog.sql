IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertProxyLog')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertProxyLog
	END

GO

CREATE Procedure stp_Dialer_InsertProxyLog
@CallId varchar(20),
@EventType varchar(20),
@EventSubtype varchar(20)
AS
Begin
Insert into tblDialerProxyLog(CallId, EventType, EventSubtype)
Values (@CallId, @EventType, @EventSubType)
Select scope_identity()
End

GO



