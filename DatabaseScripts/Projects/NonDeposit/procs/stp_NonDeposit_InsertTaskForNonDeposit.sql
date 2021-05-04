IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertTaskForNonDeposit')
	BEGIN
		DROP  Procedure  stp_NonDeposit_InsertTaskForNonDeposit
	END

GO

CREATE Procedure stp_NonDeposit_InsertTaskForNonDeposit
(	
	@MatterId int,
	@TaskTypeId int,
	@DueDate datetime,
	@Description varchar(500),
	@CreatedBy int,
	@NonDepositTypeId int = 1		
)

AS
BEGIN

	DECLARE @Return INT
			,@TaskDueDate DATETIME
			,@NewTaskId INT			
			,@TaskTypeIdExists BIT
			,@NonDepositId INT
			,@ClientId INT
			,@Note VARCHAR(MAX)
			,@UserName VARCHAR(50)
			,@TaskTypeName VARCHAR(50);
			
	SELECT @Return = 0
		   ,@TaskTypeIdExists = (CASE WHEN (SELECT count(*) FROM tblTaskType WHERE TaskTypeId = @TaskTypeId)> 0 THEN 1 ELSE 0 END)
		   ,@TaskTypeName = (SELECT [NAME] FROM tblTaskType WHERE TaskTypeId = @TaskTypeId)
		   ,@UserName = (SELECT (u.FirstName + ' ' + u.LastName ) FROM tblUser u WHERE UserId = @CreatedBy);		   

	SELECT @ClientId = ClientId FROM tblMatter WHERE MatterId = @MatterId

	IF @ClientId IS NULL SET @Return = -2 --matter does not exist	
	ELSE IF @TaskTypeIdExists = 0 SET @Return = -4; -- TaskType does not exist

	IF @Return = 0 BEGIN
		BEGIN TRY

			IF @DueDate IS NOT NULL BEGIN
				SET @Return  = 0
				--Insert into tblTask
				INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,
									CreatedBy, LastModified, LastModifiedBy, AssignedTo)
				VALUES(@TaskTypeId, @Description, @DueDate, NULL, getdate(),
						@CreatedBy, getdate(), @CreatedBy, 0);

				SET @NewTaskId = scope_identity();			

				--Insert into Client Task
				INSERT INTO tblClientTask(ClientId,TaskId,Created,CreatedBy,LastModified,LastModifiedBy)
				VALUES(@ClientId, @NewTaskId, getdate(), @CreatedBy, getdate(), @CreatedBy)
				
				IF @TaskTypeId in (76,77) BEGIN
					SET @NonDepositId = (SELECT NonDepositId FROM tblNonDeposit WHERE MatterId = @MatterId);
					
					DECLARE @AlertText varchar(255)
					SELECT @AlertText = CASE WHEN @NonDepositTypeId = 2 THEN 'Your deposit was Returned' ELSE 'We did not receive your deposit' END
					
					--Insert Client Alerts
					INSERT INTO tblClientAlerts(ClientId, AlertType, AlertDescription, AlertRelationType, AlertRelationId, Created, CreatedBy)
					VALUES(@ClientId, 2, @AlertText, 'tblNonDeposit', @NonDepositId, getdate(), @CreatedBy)
				END

				--Associate the task with matter
				INSERT INTO tblMatterTask(MatterId, TaskId, CreatedDatetime, CreatedBy) 
				VALUES(@MatterId, @NewTaskId, getdate(), @CreatedBy)
				
				SET @Note = @UserName + ' created a task of type ' + @TaskTypeName + ' on '+ convert(varchar(50), getdate());
				EXEC @Return = stp_NonDeposit_InsertNoteForNonDepositMatter @ClientId, @MatterId, @CreatedBy, @NewTaskId, @Note, null, null, null, null, null;
	
			END
			ELSE BEGIN
				SET @Return = -5;
			END

		END TRY
		BEGIN CATCH
			Print 'TASK ' + ERROR_MESSAGE();
			SET @Return = -1;
		END CATCH
	END
	
	RETURN @Return
END
GO
