IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_SyncLeadStatus_Matters')
	BEGIN
		DROP  Procedure  stp_Vici_SyncLeadStatus_Matters
	END

GO

CREATE Procedure stp_Vici_SyncLeadStatus_Matters
@LeadId int, --Param LeadID represents MatterID
@DispoCode varchar(20),
@DispoDate datetime,
@CallCount int = NULL,
@UserName varchar(20),
@Minutes int = 60
AS
Begin

	--declare vars
	declare 
	@DialerStatusId int,
	@Contacted bit,
	@UserId int
	
	--init vars
	select @DialerStatusId = null, @Contacted = null, @UserId  = null

	--validate user
	select @UserId = userid from tbluser where username = @UserName
	
	select @DialerStatusId = DialerStatusId, @Contacted = Contacted 
	from tblViciLeadStatus 
	Where ViciLeadStatusCode = @DispoCode
	
	Update tblMatter Set
	DialerStatusId = case when DialerStatusId in (5,6) then DialerStatusId else isnull(@DialerStatusId, DialerStatusId) end, -- Update  except when (5,6) stopping/stopped
	--DialerCount = ISNULL(@CallCount, DialerCount),
	DialerRetryAfter = Case When (DialerRetryAfter is null or DateAdd(n, @Minutes, GetDate()) > DialerRetryAfter) then DateAdd(n, @Minutes, GetDate()) else DialerRetryAfter End,
	LastViciStatusCode = Case when @DispoCode Not In ('PND', 'STP', 'OTHERC') then @DispoCode else LastViciStatusCode end,
	LastViciStatusDate = Case when @DispoCode Not In ('PND', 'STP', 'OTHERC') then @DispoDate else LastViciStatusDate end,
	LastContacted = Case When @Contacted = 1 Then @DispoDate else LastContacted End
	Where MatterId = @LeadId
	
	Update tblClient Set
	DialerResumeAfter = Case When (DialerResumeAfter is null or DateAdd(n, @Minutes, GetDate()) > DialerResumeAfter) then DateAdd(n, @Minutes, GetDate()) else DialerResumeAfter End
	Where Clientid in (select clientid from tblmatter where matterid = @leadid)

End	

