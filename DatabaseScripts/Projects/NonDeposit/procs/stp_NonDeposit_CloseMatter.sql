 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_CloseMatter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_CloseMatter
	END

GO

CREATE Procedure stp_NonDeposit_CloseMatter
(	
	@MatterId int,
	@MatterStatusCode varchar(50),
	@MatterSubStatus varchar(50),
	@Note varchar(max) = null,			
	@CreatedBy int
)
AS
BEGIN
	DECLARE @Return INT
			,@ClientId INT
			,@MatterStatusCodeId Int
			,@MatterSubstatusId Int
			,@UserName VARCHAR(50)
			,@TaskId INT;			
		   
	SELECT @ClientId = m.ClientId
	FROM tblMatter m 
	WHERE m.MatterId = @MatterId;

	SELECT @Return = 0
		   ,@MatterStatusCodeId = (SELECT MatterStatusCodeId from tblmatterstatuscode Where MatterStatusCode=@MatterStatusCode)
		   ,@MatterSubStatusId = (SELECT MatterSubStatusId from tblmattersubstatus Where MatterSubStatus=@MatterSubStatus)
		   ,@UserName = (SELECT FirstName + ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
		   ,@TaskId = (SELECT top 1 mt.TaskId FROM tblMatterTask mt inner join tblTask t ON t.TaskId = mt.TaskId and t.TaskResolutionId is null WHERE mt.MatterId = @MatterId Order by mt.createddatetime desc)


	IF @Return = 0 BEGIN
		BEGIN TRY		
		
			IF @TaskId is not null BEGIN
				--Resolve the task
				EXEC @Return = stp_NonDeposit_UpdateTaskForNonDeposit @TaskId, 'Task For Non Deposit Closed.', @CreatedBy, @CreatedBy, 1;
				IF @Return <> 0 SET @Return = -4;
			END	
			
			UPDATE tblMatter SET
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusId = 2,
				MatterStatusCodeId = @MatterStatusCodeId
			WHERE MatterId = @MatterId
			
			IF @Note is not null BEGIN
				EXEC @Return = stp_NonDeposit_InsertNoteForNonDepositMatter @ClientId, @MatterId, @CreatedBy, null, @Note,null,null, null,null,null;
			END
			
			DECLARE @UserGroupId int Set @UserGroupId = NULL
			Select @UserGroupId = UserGroupId From tbluser where userid = @CreatedBy
			
			INSERT INTO tblNonDepositRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created, UserGroupId)
			VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate(), @UserGroupId)
			
			exec stp_Vici_InsertStopLeadRequest @MatterId, 'MATTERS', 'Close nondeposit matter'
			
			IF @Return <> 0 BEGIN
				SET @Return = -3
			END	

		END TRY
		BEGIN CATCH
			SET @Return = -1;
		END CATCH
	END
	
	RETURN @Return
END
GO
