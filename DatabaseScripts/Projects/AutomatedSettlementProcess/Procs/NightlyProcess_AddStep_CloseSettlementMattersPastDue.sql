IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CloseSettlementMattersPastDue')
	BEGIN
		DROP  Procedure  stp_CloseSettlementMattersPastDue
	END

GO

CREATE Procedure [dbo].[stp_CloseSettlementMattersPastDue]

AS
BEGIN

	DECLARE @SettlementsToClose TABLE(
										MatterId INT,
										SettlementId INT,
										ClientId INT,
										AccountId INT 
								    );

	INSERT INTO @SettlementsToClose(MatterId, SettlementId, ClientId, AccountId)
	SELECT s.MatterId, s.SettlementId, s.ClientId, s.CreditorAccountId
	FROM tblSettlements s inner join
		 tblMatter m ON m.MatterId = s.MatterId inner join
		 tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1
	WHERE dateadd(dd,1,s.SettlementDueDate) <= getdate() and m.MatterId is not null


	UPDATE dbo.tblMatter
	SET MatterStatusCodeId	= 43,
		MatterStatusId		= 2,
		MatterSubStatusId  = 71
	WHERE MatterId IN (SELECT DISTINCT MatterId FROM @SettlementsToClose);

	UPDATE tblTask
	SET TaskResolutionID = 2,
		Resolved = getdate(),
		ResolvedBy = -1,
		lastModified = getdate(),
		LastModifiedBy = -1
	WHERE TaskResolutionID <> 1 and 
		  TaskId IN (SELECT TaskId FROM tblMatterTask WHERE MatterId IN (
					SELECT DISTINCT MatterId FROM @SettlementsToClose))

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

	UPDATE tblAccount SET AccountStatusId = isnull(PreviousStatus, AccountStatusId) WHERE AccountId IN 
	(SELECT DISTINCT AccountId FROM @SettlementsToClose);
	
	INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
	SELECT 127, AccountId, isnull(PreviousStatus, AccountStatusId), getdate(), -1, 0
			FROM tblAccount WHERE AccountId IN 
	(SELECT DISTINCT AccountId FROM @SettlementsToClose);

	INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
	SELECT SettlementId, 43, null, -1, getdate()
	FROM @SettlementsToClose


	-- flag expired settlement alerts
	update tblclientalerts
	set deleted = 1
	from tblclientalerts a
	join @SettlementsToClose s on s.settlementid = a.alertrelationid
	where a.deleted = 0
	and a.resolved is null
	and a.alertrelationtype = 'tblSettlements' 
	
	-- and insert info alerts about the expired settlements
	insert tblclientalerts (clientid,alerttype,alertdescription,alertrelationtype,alertrelationid,created,createdby)
	select sc.clientid, 1, 'The settlement with ' + g.[Name] + ' #' + right(AccountNumber, 4) + ' for $' + CONVERT(varchar(20), s.SettlementAmount, 1) + ' has expired.', 'tblSettlements', s.settlementid, getdate(), -1
	from @SettlementsToClose sc
	join tblsettlements s on s.settlementid = sc.settlementid
	join tblAccount a on a.AccountId = s.CreditorAccountId
	join tblCreditorInstance ci on ci.CreditorInstanceId = a.CurrentCreditorInstanceId
	join tblCreditor c on c.CreditorId = ci.CreditorId
	join tblCreditorGroup g on g.creditorgroupid = c.creditorgroupid
	
	--expire old settlements in tblLexxSignDocs
	update tblLexxSignDocs 
	set currentstatus = 'Expired', completed = s.SettlementDueDate
	from tblLexxSignDocs lsd WITH(NOLOCK)
	INNER join tblSettlements s WITH(NOLOCK) ON s.SettlementID = lsd.RelationID
	where CurrentStatus='Waiting on signatures' AND  DocumentTypeID='D6004' and RelationTypeID=21
	and datediff(day,s.SettlementDueDate,getdate())> 0
	
	--complete/close settlements in tblLexxSignDocs
	update tblLexxSignDocs 
	set currentstatus = 'Completed', completed = s.SettlementDueDate
	from tblLexxSignDocs lsd WITH(NOLOCK)
	INNER join tblSettlements s WITH(NOLOCK) ON s.SettlementID = lsd.RelationID
	inner join tblmatter m WITH(NOLOCK) on m.MatterId = s.MatterId
	where CurrentStatus='Waiting on signatures' AND  DocumentTypeID='D6004' and RelationTypeID=21
	and datediff(day,s.SettlementDueDate,getdate())< 0
	and m.MatterStatusId in (2,4)
	
END
GO



