IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DeleteCancellationMatter')
	BEGIN
		DROP  Procedure  stp_DeleteCancellationMatter
	END

GO

CREATE Procedure [dbo].[stp_DeleteCancellationMatter]
(
	@MatterId int,
	@CreatedBy int
)
AS
BEGIN
	DECLARE @Return int
			,@ClientId INT
			,@MatterTypeId INT	
			,@InTran BIT
			,@MatterStatusCodeId INT
			,@MatterSubStatusid INT
			,@Note VARCHAR(max)
			,@UserName VARCHAR(50)
			,@NoteId INT
			,@ClientName VARCHAR(100)
			,@TaskId INT;

	SELECT @Return = 0
			,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 1 ELSE 0 END);	
		
	SELECT @ClientId = ClientId, @MatterTypeId = MatterTypeId FROM tblMatter WHERE MatterId = @MatterId;

	IF @ClientId is null SET @Return = -2
	ELSE IF @MatterTypeId <> 4 SET @Return = -3;

	IF @Return = 0 BEGIN
		SELECT 
			@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
			,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
			,@MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'RC')
			,@MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'RC')
			,@TaskId = (SELECT t.TaskId FROM tblTask t inner join tblMatterTask mt ON 
				t.TaskId = mt.TaskId and mt.MatterId = @MatterId WHERE t.TaskTypeId = 76 and t.TaskResolutionId <> 1);

		DECLARE @AccountTbl TABLE(AccountId INT);
	
		INSERT INTO @AccountTbl(AccountId)
		SELECT AccountID FROM tblAccount where AccountId not in (
		SELECT a.AccountId
		FROM 
			tblMatter m inner join
			tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join
			tblAccount a ON a.CurrentCreditorInstanceId = ci.CreditorInstanceId
		WHERE 
			m.ClientId = @ClientId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) 
		UNION
		SELECT AccountId 
		FROM 
			tblAccount 
		WHERE 
			AccountStatusid IN (55,54,157,160,164,166) and ClientId = @ClientId) 
		and ClientId = @ClientId;
	END

	IF @Return = 0 BEGIN
		IF @InTran = 1 BEGIN TRANSACTION;
		BEGIN TRY

			--Update tblMatter 
			UPDATE tblMatter SET
				MatterStatusId = 2,
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusCodeId = @MatterStatusCodeId
			WHERE MatterId = @MatterId;
			
			--Update the status of all accounts to Pending Cancellation
			UPDATE tblAccount SET				
				AccountStatusId = PreviousStatus,				
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE AccountId IN( SELECT AccountId FROM @AccountTbl)

			--Audit Account Status Change
			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
			SELECT 127, at.AccountId, a.PreviousStatus, getdate(), @CreatedBy, 0
			FROM @AccountTbl at inner join
				tblAccount a ON a.AccountId = at.AccountId

			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
			VALUES( 52, @ClientId, 14, getdate(), @CreatedBy, 0);

			SET @Note = 'The client ' + @ClientName + ' has been re-activated by ' + @UserName +' . The Cancellation matter associated with the client has been closed.';

			--Insert Note
			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, null, @Note, null, null, null,null,@NoteId output;

			--Enter Roadmap
			INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
			VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate())

			IF @TaskId is not null BEGIN
				EXEC @Return = [stp_UpdateTaskForSettlement] @TaskId, 'Call Client For Cancellation', @CreatedBy, @CreatedBy, 2;
			END
			
			DELETE @AccountTbl;
			
			IF @InTran = 1 BEGIN
				IF @Return = 0 COMMIT ELSE ROLLBACK;
			END
		END TRY
		BEGIN CATCH
			SET @Return = -1;
			IF @InTran = 1 ROLLBACK;
		END CATCH
	END

	RETURN @Return;
END
GO


