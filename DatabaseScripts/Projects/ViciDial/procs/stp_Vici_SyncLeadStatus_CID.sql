IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_SyncLeadStatus_CID')
	BEGIN
		DROP  Procedure  stp_Vici_SyncLeadStatus_CID
	END

GO

CREATE Procedure stp_Vici_SyncLeadStatus_CID
@LeadId int,
@DispoCode varchar(20),
@DispoDate datetime,
@CallCount int = NULL,
@UserName varchar(20),
@Minutes int = 60
AS
Begin

	--declare vars
	declare 
	@OldLeadStatusId int, 
	@LeadStatusId int,
	@DialerStatusId int,
	@Contacted bit,
	@ChangeStatus bit,
	@ReasonId int,
	@ParentRoadmapID int,
	@UserId int
	
	--init vars
	select @OldLeadStatusId = null, @LeadStatusId = null,  @DialerStatusId = null, @Contacted = null, @ChangeStatus = 0, @ReasonId = null, @ParentRoadmapID = null, @UserId  = null

	--validate user
	select @UserId = userid from tbluser where username = @UserName
	
	select @LeadStatusId = LeadStatusId, @DialerStatusId = DialerStatusId, @Contacted = Contacted, @ReasonId = LeadReasonId  
	from tblViciLeadStatus Where ViciLeadStatusCode = @DispoCode
	
	if (@UserName In ('VDAD', 'VDCL', ''))
	Begin
		-- Only Change status if automatic disposition happens
		select @OldLeadStatusId = StatusId from tblLeadApplicant Where LeadApplicantId = @LeadId
		Select @ChangeStatus =  dbo.fn_Vici_AllowLeadStatusTransition(@OldLeadStatusId, @LeadStatusId)
	End
   
	Update tblLeadApplicant Set
	StatusId = case when @ChangeStatus = 1 then isnull(@LeadStatusId, StatusId) else StatusId end,
	DialerStatusId = case when DialerStatusId in (5,6) then DialerStatusId else isnull(@DialerStatusId, DialerStatusId) end, -- Update  except when (5,6) stopping/stopped
	DialerCount = ISNULL(@CallCount, DialerCount),
	DialerRetryAfter = DateAdd(n, @Minutes, GetDate()),
	LastViciStatusCode = Case when @DispoCode Not In ('PND', 'STP', 'OTHERC') then @DispoCode else LastViciStatusCode end,
	LastViciStatusDate = Case when @DispoCode Not In ('PND', 'STP', 'OTHERC') then @DispoDate else LastViciStatusDate end,
	LastContacted = Case When @Contacted = 1 Then @DispoDate else LastContacted End,
	ReasonId = case when @ChangeStatus = 1 then @ReasonId else ReasonId end
	Where LeadApplicantId = @LeadId
	
	If (@ChangeStatus = 1) 
	Begin
		--If Not User, user the CID dialer user
		Select @UserId = isnull(@UserId, 31)

		SELECT TOP 1 @ParentRoadmapID = RoadmapID  FROM tblLeadStatusRoadMap AS rm  WHERE (LeadApplicantID = @LeadId) ORDER BY LastModified DESC 
		
		Insert Into tblLeadRoadMap(LeadApplicantId, ParentLeadRoadMapId, LeadStatusId, Reason, Created, CreatedBy, LastModified, LastModifiedBy)
		Values (@LeadId, @ParentRoadMapId, @LeadStatusId, 'Applicant Status Changed',  Getdate(), @UserId, GetDate(), @UserId)
	
		Insert Into tblLeadStatusRoadMap(LeadApplicantId, ParentRoadMapId, LeadStatusId, Reason, Created, CreatedBy, LastModified, LastModifiedBy)
		Values (@LeadId, @ParentRoadMapId, @LeadStatusId, 'Applicant Status Changed',  Getdate(), @UserId, GetDate(), @UserId)
	
	End 

End	

