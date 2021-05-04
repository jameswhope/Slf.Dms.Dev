IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_ChangeNonDepositStatus')
	BEGIN
		DROP  Procedure  stp_NonDeposit_ChangeNonDepositStatus
	END

GO

CREATE Procedure  stp_NonDeposit_ChangeNonDepositStatus 
	@MatterId int,
	@MatterSubStatus varchar(50),
	@MatterStatusCode varchar(50),
	@Note varchar(max) = null,
	@CreatedBy int 
AS
BEGIN
	DECLARE @Return INT
			,@ClientId INT
			,@MatterStatusCodeId INT			
			,@MatterSubStatusid INT
			,@MatterStatusid INT
			,@UserName VARCHAR(50)
			,@NoteId INT
			,@ClientName VARCHAR(100)
			,@TaskId INT;

	SELECT @ClientId = ClientId FROM tblMatter WHERE MatterId = @MatterId;

	SELECT @Return = 0
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
	,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
	--,@TaskId = (SELECT mt.TaskId FROM tblMatterTask mt inner join tblTask t ON t.TaskId = mt.TaskId and t.TaskResolutionId is null WHERE mt.MatterId = @MatterId)
	,@TaskId = (SELECT top 1 mt.TaskId FROM tblMatterTask mt inner join tblTask t ON t.TaskId = mt.TaskId and t.TaskResolutionId is null WHERE mt.MatterId = @MatterId Order by mt.createddatetime desc)
	,@MatterStatusCodeId = (SELECT MatterStatusCodeId from tblmatterstatuscode Where MatterStatusCode=@MatterStatusCode)
	,@MatterSubStatusId = (SELECT MatterSubStatusId from tblmattersubstatus Where MatterSubStatus=@MatterSubStatus)
	,@MatterStatusId = (SELECT MatterStatusId from tblmattersubstatus Where MatterSubStatus=@MatterSubStatus);
		
	IF @ClientId is null SET @Return = -2;

	IF @Return = 0 BEGIN
		BEGIN TRY

			IF @TaskId is not null BEGIN
				--Resolve the task
				EXEC @Return = stp_NonDeposit_UpdateTaskForNonDeposit @TaskId, 'Client For Non Deposit Contacted.', @CreatedBy, @CreatedBy, 1;
				IF @Return <> 0 SET @Return = -4;
			END

			IF @Return = 0 BEGIN
				--Update the Matter
				UPDATE tblMatter SET
				MatterStatusCodeId = @MatterStatusCodeId,			
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusId = @MatterStatusId
				WHERE MatterId = @MatterId;
				
				SET @Note = 'A non deposit matter for '+ @ClientName + '  updated by ' + @UserName + ' to ' + @MatterSubStatus + '. ' + isnull(@Note,'');
				EXEC @Return = stp_NonDeposit_InsertNoteForNonDepositMatter @ClientId, @MatterId, @CreatedBy, @TaskId, @Note,null,null, null,null,null;
				IF @Return <> 0 SET @Return = -5;

				DECLARE @UserGroupId int Set @UserGroupId = NULL
				Select @UserGroupId = UserGroupId From tbluser where userid = @CreatedBy
				
				INSERT INTO tblNonDepositRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created, UserGroupId)
				VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate(), @UserGroupId)
				
				exec stp_Vici_InsertStopLeadRequest @MatterId, 'MATTERS', 'Update nondeposit status'
			
			END

		END TRY
		BEGIN CATCH
			Print error_Message();
			SET @Return = -1;
		END CATCH
	END
	RETURN @Return;
END
GO
