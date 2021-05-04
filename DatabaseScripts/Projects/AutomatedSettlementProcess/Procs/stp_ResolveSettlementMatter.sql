IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ResolveSettlementMatter')
	BEGIN
		DROP  Procedure  stp_ResolveSettlementMatter
	END

GO

CREATE Procedure [dbo].[stp_ResolveSettlementMatter]
(	
	@SettlementId int,
	@Note varchar(max),
	@AutoNote varchar(max),
	@CreatedBy int,
	@ClientId int,
	@TaskTypeId int = null,
	@AccountId int,
	@DocTypeId nvarchar(50) = null,
	@DateString varchar(50)= null,
	@DocId varchar(50) = null,
	@SubFolder nvarchar(150) = null,
	@ResolutionId INT,
	@MatterStatusCodeId INT,
	@MatterStatusId INT,
	@MatterSubStatusId INT,
	@IsDeleted BIT,
	@Active BIT,
	@isResolved BIT
)

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DECLARE @Return INT
			,@InTran BIT			
			,@SettlementMatter INT
			,@ReasonId INT			
			,@ApprovedNote VARCHAR(MAX)
			,@TaskId INT
			,@TaskName VARCHAR(50)
			,@UserName VARCHAR(50)
			,@ActiveName VARCHAR(25)
			,@Desc VARCHAR(500)
			,@NoteId int
			,@AccountStatus INT
			,@PreviousState INT
			,@PreviousStatusCode VARCHAR(10)
			,@PresentStatusId INT;
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@SettlementMatter = (SELECT MatterId FROM tblSettlements WHERE SettlementId = @SettlementId)
		   ,@UserName = (SELECT UserName FROM tblUser WHERE UserId = @CreatedBy)
		   ,@ActiveName = (SELECT MatterStatusCode FROM tblMatterStatusCode WHERE MatterStatusCodeId = @MatterStatusCodeId);
		   
	SELECT @AccountStatus = AccountStatusId FROM tblAccountStatus WHERE Code = 'SP';
	SELECT @PreviousState = isnull(PreviousStatus, AccountStatusId), @PresentStatusId = AccountStatusId FROM tblAccount WHERE AccountId = @AccountId;
	SELECT @PreviousStatusCode = Code FROM tblAccountStatus WHERE AccountStatusId = @PreviousState;
		   
	IF @TaskTypeId is not null BEGIN
		--SET @TaskId = (SELECT TaskId FROM tblTask WHERE TaskId IN (SELECT TaskId FROM tblMatterTask WHERE MatterId = @SettlementMatter) and TaskTypeId = @TaskTypeId)
		SET @TaskId = (SELECT TaskId FROM tblTask WHERE TaskId IN (SELECT TaskId FROM tblTask WHERE MatterId = @SettlementMatter) and TaskTypeId = @TaskTypeId)
		
		SET @TaskName = (SELECT [Name] FROM tblTaskType WHERE TaskTypeId = @TaskTypeId);
		SELECT @Desc = [Description] FROM tblTask WHERE TaskId = @TaskId
	END
	ELSE BEGIN
		SET @TaskId = null;
		SET @TaskName = 'Manager Approval';
	END

	IF @SettlementMatter IS NULL SET @Return = -2 --matter does not exist	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY
			IF @TaskTypeId is not null BEGIN

				--Resolve the task
				EXEC @Return = stp_UpdateTaskForSettlement @TaskId, @Desc, @CreatedBy, @CreatedBy, @ResolutionId;
			END
			
			IF @Return = 0 BEGIN
				--Update the Matter
				UPDATE tblMatter SET
				MatterStatusCodeId = @MatterStatusCodeId,			
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusId = @MatterStatusId,
				IsDeleted = @IsDeleted
				WHERE MatterId = @SettlementMatter

				IF @isResolved = 0 BEGIN
					UPDATE tblAccount SET AccountStatusId = @PreviousState WHERE AccountId =@AccountId;
					
					INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
						VALUES(127, @AccountId, @PreviousState, getdate(), @CreatedBy, 0);

					UPDATE tblSettlementTrackerImports
					SET [Status] = @PreviousStatusCode,
						LastModified = getdate(),
						LastModifiedBy = @CreatedBy
					WHERE SettlementId =@SettlementId;
				END
				ELSE IF @TaskTypeId in (72,78) BEGIN
					UPDATE tblAccount SET PreviousStatus = @PresentStatusId, AccountStatusId = @AccountStatus WHERE AccountId =@AccountId;
					
					INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
						VALUES(127, @AccountId, @PresentStatusId, getdate(), @CreatedBy, 0);

					UPDATE tblSettlementTrackerImports
					SET [Status] = 'SP',
						LastModified = getdate(),
						LastModifiedBy = @CreatedBy
					WHERE SettlementId =@SettlementId;
				END
				
				If @AutoNote is not Null BEGIN

					EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @SettlementMatter, @AccountId,@CreatedBy, @TaskId, @AutoNote,@DocTypeId,@DocId, @DateString,@SubFolder,null;

				END
				
				IF @Note is not null BEGIN
					EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @SettlementMatter, @AccountId,@CreatedBy, @TaskId, @Note, null, null, null, null,@NoteId output;
					
					IF not @NoteId is null BEGIN
						INSERT INTO tblSettlementNote(SettlementId, Note,CreatedBy, CreatedDateTime,NoteId)
						VALUES(@SettlementId, @Note, @CreatedBy, getdate(), @NoteId)	

					END

					IF not @NoteId is null and @TaskTypeId in (72,78) BEGIN
						UPDATE tblSettlementClientApproval SET NoteId = @NoteId WHERE MatterId = @SettlementMatter;

					END
				END

				INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
				VALUES(@SettlementId, @MatterStatusCodeId, @NoteId, @CreatedBy, getdate())
			
			END
			ELSE BEGIN
				SET @Return = -3
			END
			
			IF @InTran = 0 BEGIN
				IF @Return = 0 COMMIT ELSE ROLLBACK;
			END
		END TRY
		BEGIN CATCH
			SET @Return = -1;
			IF @InTran = 0 ROLLBACK;
		END CATCH
	END
	
	RETURN @Return
END
GO


GRANT EXEC ON stp_ResolveSettlementMatter TO PUBLIC

GO


