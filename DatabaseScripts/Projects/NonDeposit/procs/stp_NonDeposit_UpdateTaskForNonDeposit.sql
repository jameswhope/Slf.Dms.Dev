IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_UpdateTaskForNonDeposit')
	BEGIN
		DROP  Procedure  stp_NonDeposit_UpdateTaskForNonDeposit
	END

GO

CREATE Procedure stp_NonDeposit_UpdateTaskForNonDeposit
(	
	@TaskId int,	
	@Description varchar(500),
	@ModifiedBy int,
	@ResolvedBy int = null, 
	@TaskResolutionId int = null		
)

AS
BEGIN

	DECLARE @Return INT
			,@Note VARCHAR(MAX)
			,@UserName VARCHAR(50)
			,@TaskTypeName VARCHAR(50)
			,@Resolved DATETIME
			,@ResolutionName VARCHAR(50)
			,@ClientId INT;
			
	SELECT @Return = 0
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @ModifiedBy)
		   ,@TaskTypeName = (SELECT [NAME] FROM tblTaskType WHERE TaskTypeId = (
							SELECT TaskTypeId FROM tblTask WHERE TaskId = @TaskId))
		   ,@ClientId = (SELECT ClientId FROM tblClientTask WHERE TaskId = @TaskId);	

	IF @TaskResolutionId IS NOT NULL BEGIN
		SET @Resolved = getdate()
		SET @ResolutionName = (SELECT [Name] FROM tblTaskResolution WHERE TaskResolutionId = @TaskResolutionId)
	END	   
	ELSE BEGIN
		SET @Resolved = null;
		SET @ResolutionName = null
	END

	IF @Return = 0 BEGIN
		BEGIN TRY
			--update into tblTask
			UPDATE tblTask SET
				[Description] = @Description,
				ResolvedBy = @ResolvedBy,
				Resolved = @Resolved,
				TaskResolutionId = @TaskResolutionId,
				LastModified = getdate(),
				LastModifiedBy = @ModifiedBy
			WHERE TaskId = @TaskId

			SET @Note = @UserName + ' updated the task ' + @TaskTypeName + ' on '+ convert(varchar(50), getdate());
			IF @TaskResolutionId is not null BEGIN
				SET @Note = @Note + ' to Resolution ' + @ResolutionName
			END
			EXEC @Return = stp_NonDeposit_InsertNoteForNonDepositMatter @ClientId, null, @ModifiedBy, @TaskId, @Note,null,null,null, null,null;
			
		END TRY
		BEGIN CATCH
			SET @Return = -1;
		END CATCH
	END
	
	RETURN @Return
END
GO

