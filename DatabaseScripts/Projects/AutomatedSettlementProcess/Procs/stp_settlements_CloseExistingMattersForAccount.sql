IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_CloseExistingMattersForAccount')
	BEGIN
		DROP  Procedure  stp_settlements_CloseExistingMattersForAccount
	END

GO

CREATE Procedure stp_settlements_CloseExistingMattersForAccount
	(
		@clientid int,
		@accountid int
	)
AS
BEGIN
	DECLARE @SettlementsToClose TABLE(MatterId INT,SettlementId INT,ClientId INT,AccountId INT );

	--find settlements w/ matters
	insert INTO @SettlementsToClose 
	select m.MatterId,s.SettlementID,s.ClientID,s.CreditorAccountID
	from tblsettlements s with (NOLOCK)
	INNER JOIN tblMatter m WITH(NOLOCK) on m.MatterId=s.MatterId
	where creditoraccountid = @accountid and s.clientid = @clientid and status = 'a' 
	 and MatterTypeId=3 and IsDeleted=0 and MatterStatusId IN(1,3)
	order by created desc

	--close matter and set status to cancelled by neg
	UPDATE dbo.tblMatter
	SET MatterStatusCodeId	= 2,
		MatterStatusId		= 2,
		MatterSubStatusId  = 93
	WHERE MatterId IN (SELECT DISTINCT MatterId FROM @SettlementsToClose);

	--resolve all tasks for matter
	UPDATE tblTask
	SET TaskResolutionID = 2,Resolved = getdate(),ResolvedBy = -1,lastModified = getdate(),LastModifiedBy = -1
	WHERE isnull(TaskResolutionID,0) <> 1 and TaskId IN (SELECT TaskId FROM tblMatterTask WHERE MatterId IN (
	SELECT DISTINCT MatterId FROM @SettlementsToClose))

	UPDATE tblTask
	SET TaskResolutionID = 2,Resolved = getdate(),ResolvedBy = -1,lastModified = getdate(),LastModifiedBy = -1
	WHERE  isnull(TaskResolutionID,0) <> 1 and matterid IN (SELECT DISTINCT MatterId FROM @SettlementsToClose)


	--set cancelled for reporting
	UPDATE tblSettlementTrackerImports
		SET CancelDate = getdate(),
			CancelBy = -1,
			[Status] = (SELECT Code FROM tblAccountStatus WHERE AccountStatusId = isnull(a.PreviousStatus, a.AccountStatusId)),
			LastModified = getdate(),
			LastModifiedBy = -1,
			Expired = getdate()
	FROM tblSettlementTrackerImports st inner join
		 @SettlementsToClose s ON s.SettlementId = st.SettlementId inner join
		 tblAccount a ON a.AccountId = s.AccountId


	--insert roadmap step that we cancelled settlement
	INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
	SELECT SettlementId, 2, null, -1, getdate()
	FROM @SettlementsToClose

	-- flag expired settlement alerts
	update tblclientalerts
	set deleted = 1
	from tblclientalerts a
	join @SettlementsToClose s on s.settlementid = a.alertrelationid
	where a.deleted = 0
	and a.resolved is null
	and a.alertrelationtype = 'tblSettlements' 
END

GO


GRANT EXEC ON stp_settlements_CloseExistingMattersForAccount TO PUBLIC

GO


