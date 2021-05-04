IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateTaskForSettlement')
	BEGIN
		DROP  Procedure  stp_UpdateTaskForSettlement
	END

GO

CREATE Procedure [dbo].[stp_UpdateTaskForSettlement]
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
			,@InTran BIT						
			,@Note VARCHAR(MAX)
			,@UserName VARCHAR(50)
			,@TaskTypeName VARCHAR(50)
			,@Resolved DATETIME
			,@ResolutionName VARCHAR(50)
			,@ClientId INT;
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @ModifiedBy)
		   ,@TaskTypeName = (SELECT [NAME] FROM tblTaskType WHERE TaskTypeId = (
							SELECT TaskTypeId FROM tblTask WHERE TaskId = @TaskId))
		   ,@ClientId = (SELECT ClientId FROM tblClientTask WHERE TaskId = @TaskId);	
	
	if @ClientId is null
		BEGIN
			select @ClientId = clientid from tblmatter where currenttaskid = @TaskId
		END

	IF @TaskResolutionId IS NOT NULL BEGIN
		SET @Resolved = getdate()
		SET @ResolutionName = (SELECT [Name] FROM tblTaskResolution WHERE TaskResolutionId = @TaskResolutionId)
	END	   
	ELSE BEGIN
		SET @Resolved = null;
		SET @ResolutionName = null
	END

	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
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
			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, null,
										 null,@ModifiedBy, @TaskId, @Note,null,null,null, null,null;
			
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


GRANT EXEC ON stp_UpdateTaskForSettlement TO PUBLIC

GO


