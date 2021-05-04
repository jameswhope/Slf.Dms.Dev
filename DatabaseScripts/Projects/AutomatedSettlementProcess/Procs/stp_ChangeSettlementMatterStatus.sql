IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ChangeSettlementMatterStatus')
	BEGIN
		DROP  Procedure  stp_ChangeSettlementMatterStatus
	END

GO

CREATE Procedure [dbo].[stp_ChangeSettlementMatterStatus]
(
   @MatterId int = NULL,
   @ClientId int,
   @MatterStatusCodeId int,
   @CreatedBy int,
   @AccountId int,
   @MatterStatusId int,
   @MatterSubStatusId int
)
AS BEGIN


	UPDATE dbo.tblMatter SET IsDeleted = 0 WHERE  MatterId =@MatterId; 

	DECLARE @Settlement int, @NoteId int, @Note varchar(max), @UserName varchar(50), @AccountStatus varchar(10), @AccountStatusId INT,@TaskId INT;

	SELECT @Settlement = SettlementId FROM tblSettlements WHERE MatterId = @MatterId;

	SELECT @AccountStatusId = (CASE
									WHEN @MatterStatusId = 2 THEN isnull(PreviousStatus, AccountStatusId)
									WHEN @MatterStatusId = 3 and @MatterSubStatusId = 51 THEN AccountStatusId 
									ELSE 172
								END) FROM tblAccount WHERE AccountId = @AccountId;

	SELECT @AccountStatus = Code FROM tblAccountStatus WHERE AccountStatusId = @AccountStatusId;

	SET @UserName = (SELECT UserName FROM tblUser WHERE UserId = @CreatedBy);

	SET @TaskId = (SELECT TaskId FROM tblMatterTask WHERE MatterId = @MatterId);

	IF @Settlement is not null BEGIN

		IF @MatterStatusId = 2 BEGIN
			IF @MatterStatusCodeId = 42 BEGIN
				UPDATE tblSettlementTrackerImports
				SET [Status] = @AccountStatus,
					LastModified = getdate(),
					LastModifiedBy = @CreatedBy,
					Paid = null,
					days = null
				WHERE SettlementId = @Settlement;

				UPDATE tblAccount 
				SET Settled = null,
					SettledBy = null
				WHERE AccountId = @AccountId;
				
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(139, @AccountId, null, getdate(), @CreatedBy, 0);
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(140, @AccountId, null, getdate(), @CreatedBy, 0);
			END
			ELSE BEGIN
				UPDATE tblSettlementTrackerImports
				SET CancelDate = getdate(),
					CancelBy = @CreatedBy,
					[Status] = @AccountStatus,
					LastModified = getdate(),
					LastModifiedBy = @CreatedBy
				WHERE SettlementId = @Settlement;
			END

			IF (SELECT TaskResolutionId FROM tblTask WHERE TaskId = @TaskId) IS NULL BEGIN
				EXEC  [dbo].[stp_UpdateTaskForSettlement] @TaskID, 'Client Approval', @CreatedBy, @CreatedBy, 2;
			END
		END
		ELSE IF @MatterStatusId = 3 BEGIN
			UPDATE tblSettlementTrackerImports
			SET CancelDate = null,
				CancelBy = null,
				[Status] = @AccountStatus,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy,
				Expired = null
			WHERE SettlementId = @Settlement;

			
			IF @MatterSubStatusId = 51 BEGIN
				DELETE FROM tblSettlementClientApproval WHERE MatterId = @MatterId;
				EXEC  [dbo].[stp_UpdateTaskForSettlement] @TaskID, 'Re-opening Client Approval task', @CreatedBy, null, null;

			END

			IF @MatterSubStatusId = 67 BEGIN
				UPDATE tblAccount_PaymentProcessing 
				SET IsApproved = null,
					ApprovedDate = null,
					ApprovedBy = null
				WHERE MatterId = @MatterId;
			END
		END

		SET @Note = (SELECT @UserName + ' Changed status to ' + ms.MatterSubStatus +  '  of settlement matter for client ' + p.FirstName + ' ' + p.LastName + ' with '+ cr.[Name] + ' for $' + Convert(varchar(10),s.SettlementAmount) 
									from tblSettlements s
							inner join tblClient c On c.ClientId = s.ClientId
							inner join tblMatter m ON m.MatterId = s.MatterId 
							inner join tblMatterSubStatus ms ON ms.MatterSubStatusId = m.MatterSubStatusId
							inner join tblPerson p On p.PersonId = c.PrimaryPersonId
							inner join tblAccount a On a.AccountId = s.CreditorAccountId
							inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
							inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId
							where SettlementId = @Settlement) 

		UPDATE tblAccount SET AccountStatusId = @AccountStatusId WHERE AccountId = @AccountId;
		
		INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(127, @AccountId, @AccountStatusId, getdate(), @CreatedBy, 0);
				
		EXEC stp_InsertNoteForSettlementMatter @ClientId, @MatterId, @AccountId,@CreatedBy, null, @Note, null, null, null, null,@NoteId output;

		IF @NoteId is not null BEGIN
			INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
				VALUES(@Settlement, @MatterStatusCodeId, @NoteId, @CreatedBy, getdate())
		END
	END
END
GO


GRANT EXEC ON stp_ChangeSettlementMatterStatus TO PUBLIC

GO


