IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_DialerQualify')
	BEGIN
		DROP  Procedure  stp_Vici_DialerQualify
	END

GO

CREATE Procedure stp_Vici_DialerQualify
@LeadId int,
@SourceId varchar(50)
AS
Begin
	If @SourceId = 'MATTERS'
	Begin
		exec stp_Vici_DialerQualify_Nondeposit @LeadId
		Return
	End
	
	If @SourceId = 'CLIENTS'
	Begin
		Select c.clientid
		FROM tblClient c  	
		WHERE 
			c.currentclientstatusid not in (15,16,17,18)
			and (c.dialerResumeAfter is null or c.DialerResumeAfter < getdate())
			and c.clientid = @LeadId
		Return
	End
	
	SELECT 1
End

GO
 

