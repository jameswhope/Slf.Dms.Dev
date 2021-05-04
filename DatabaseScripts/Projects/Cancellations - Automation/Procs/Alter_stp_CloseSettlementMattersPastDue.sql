IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CloseSettlementMattersPastDue')
	BEGIN
		DROP  Procedure  stp_CloseSettlementMattersPastDue
	END

GO

CREATE Procedure stp_CloseSettlementMattersPastDue
AS
BEGIN
	DECLARE @ClientId INT,@CancelMatterId INT;
	
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

	IF (SELECT count(*) FROM @SettlementsToClose) > 0 BEGIN
		declare cursor_DoModifyCancellationMatter cursor for
			select ClientId from @SettlementsToClose order by ClientId

			open cursor_DoModifyCancellationMatter

			fetch next from cursor_DoModifyCancellationMatter into @ClientId
			while @@fetch_status = 0
				begin
					SET @CancelMatterId = (SELECT top 1 MatterId FROM tblMatter WHERE ClientId = @ClientId 
						and MatterTypeId = 4 and IsDeleted <> 1 and MatterStatusId not in (2,4))
					
					IF @CancelMatterId is not null BEGIN
						EXEC stp_UpdateCancellationStatus @CancelMatterId, -1;
					END
		
				fetch next from cursor_DoModifyCancellationMatter into @ClientId
			end

			close cursor_DoModifyCancellationMatter
			deallocate cursor_DoModifyCancellationMatter
	END

	DELETE FROM @SettlementsToClose
END
GO

