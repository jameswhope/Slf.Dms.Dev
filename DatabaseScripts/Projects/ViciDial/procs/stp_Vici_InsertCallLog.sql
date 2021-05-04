IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_InsertCallLog')
	BEGIN
		DROP  Procedure  stp_Vici_InsertCallLog
	END

GO

CREATE Procedure stp_Vici_InsertCallLog
@PhoneNumber varchar(20),
@RefId int = null,
@SourceId varchar(50),
@CallIdKey varchar(50),
@CallDate datetime,
@UserName varchar(50),
@Direction varchar(10),
@ViciStatusCode varchar(10),
@Autodial bit = 1
AS
BEGIN

Declare @callid int, @userid int, @inbound bit, @reftype varchar(50), @refdate datetime, @refby int, @matterid int, @callreason int

select @userid = userid from tbluser where username = @username

select @userid = isnull(@userid,30), 
	   @inbound = case when @direction = 'IN' then 1 else 0 end,
	   @reftype = case when @sourceid = 'CID' then 'LEAD' else 'CLIENT' end,
	   @callreason = 0
	   
if (@reftype is null)
	select @refId = null
	
if (@refid is null)
	select @refdate = null, @refby = null, @reftype = null
else
	begin
		select @refdate = @calldate, @refby = @userid
		
		if @sourceid = 'MATTERS'
			select @refid = m.clientid, @matterid = m.matterid, 
			@callreason = (Select mt.astcallreasonid from tblmattertype mt Where mt.mattertypeid = m.mattertypeid)
			from tblmatter m where m.matterid = @refid
	end

	insert into tblAstCallLog(Created, UserId, PhoneNumber, CallIdKey, Inbound, RefType, RefId, RefDate, RefBy, PhoneSystem, ViciStatusCode, CallReasonId, LanguageId )
	Values (@CallDate, @UserId, @PhoneNumber, @CallIdKey, @Inbound, @RefType, @RefId, @RefDate, @RefBy, 'Vicidial', @ViciStatusCode, @callreason, 1)
	
	Select @callid = scope_identity()

if (@callid is not null and @refid is not null)
begin
	If @sourceid = 'CID'
		exec stp_Vici_InsertCallLog_CID @refid, @PhoneNumber, @CallDate, @UserId, @Direction, @Autodial, @callid, @ViciStatusCode
	else if @sourceid = 'MATTERS'
		exec stp_Vici_InsertCallLog_MATTERS @matterid, @callid, @CallDate
end
	
Select @callid as callid
	
END
GO



