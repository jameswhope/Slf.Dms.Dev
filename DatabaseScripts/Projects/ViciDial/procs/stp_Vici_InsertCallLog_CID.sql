IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_InsertCallLog_CID')
	BEGIN
		DROP  Procedure  stp_Vici_InsertCallLog_CID
	END

GO

CREATE Procedure stp_Vici_InsertCallLog_CID
@LeadApplicantId int,
@PhoneNumber varchar(20),
@CallDate datetime,
@UserId int,
@direction varchar(10),
@Autodial bit = 1,
@CallId int = null,
@ViciStatusCode varchar(10)
AS
BEGIN
declare @leadcallid int 
Declare @CallIdKey varchar(20), @ResultId int
Select @CallIdKey = Convert(varchar(20), @CallId)
Select @resultid = CallResultTypeId from tblvicileadstatus where VICILeadStatusCode = @ViciStatusCode

Insert Into tblLeadDialerCall(LeadApplicantId, PhoneNumber, Created, CreatedBy, AutoDial, CallId, OutboundCallKey, ResultId)
Values(@LeadApplicantId, @PhoneNumber, @CallDate, @UserId, @AutoDial, @CallId, @CallIdKey, @ResultId)

Select @leadcallid = Scope_identity() 

--Insert Note if required by the call status
if (exists(select vicileadstatuscode from tblvicileadstatus where vicileadstatuscode = @ViciStatusCode and autonote = 1))
Begin

declare @note varchar(1000)
select @note = 'Call ' + 
case when @Direction = 'OUT' then 'made to phone number ' else 'received from phone number' end +
@phonenumber +
' on ' + convert(varchar(20), @Calldate) +
' by ' +  (select username from tbluser where userid = @userid) +
'.'

INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) 
VALUES (@LeadApplicantId, 0 ,'Phone', @note, @CallDate, @userid, @CallDate, @userid)

End

Select @leadcallid as leadcallid
	
END
GO

