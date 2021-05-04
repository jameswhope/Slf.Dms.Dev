IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertTaskForSettlement')
	BEGIN
		DROP  Procedure  stp_InsertTaskForSettlement
	END

GO

CREATE Procedure [dbo].[stp_InsertTaskForSettlement]
(	
	@SettlementId int,
	@TaskTypeId int,
	@Description varchar(500),
	@CreatedBy int		
)

AS
BEGIN

	DECLARE @Return INT
			,@InTran BIT
			,@DueDate DATETIME
			,@TaskDueDate DATETIME
			,@NewTaskId INT			
			,@SettlementMatter INT
			,@TaskTypeIdExists BIT
			,@ClientId INT
			,@AccountId INT
			,@Note VARCHAR(MAX)
			,@UserName VARCHAR(50)
			,@TaskTypeName VARCHAR(50);
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@TaskTypeIdExists = (CASE WHEN (SELECT count(*) FROM tblTaskType WHERE TaskTypeId = @TaskTypeId)> 0 THEN 1 ELSE 0 END)
		   ,@TaskTypeName = (SELECT [NAME] FROM tblTaskType WHERE TaskTypeId = @TaskTypeId)
		   ,@UserName = (SELECT (u.FirstName + ' ' + u.LastName + ' (' + ug.[Name] + ')') FROM tblUser u
							INNER JOIN tblUserGroup ug ON ug.UserGroupId = u.UserGroupId WHERE UserId = @CreatedBy);		   

	SELECT @DueDate = SettlementDueDate, @SettlementMatter = MatterId, @AccountId = CreditorAccountId FROM tblSettlements WHERE SettlementId = @SettlementId;
	SELECT @ClientId = ClientId FROM tblMatter WHERE MatterId = @SettlementMatter

	IF @SettlementMatter IS NULL SET @Return = -2 --matter does not exist	
	ELSE IF @TaskTypeIdExists = 0 SET @Return = -4; -- TaskType does not exist

	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY
			EXEC stp_GetTaskDueDate @DueDate, @TaskDueDate output;

			IF @TaskDueDate IS NOT NULL BEGIN
				SET @Return  = 0
				--Insert into tblTask
				INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,
									CreatedBy, LastModified, LastModifiedBy, AssignedTo)
				VALUES(@TaskTypeId, @Description, @TaskDueDate, NULL, getdate(),
						@CreatedBy, getdate(), @CreatedBy, 0);

				SET @NewTaskId = scope_identity();			

				--Insert into Client Task
				INSERT INTO tblClientTask(ClientId,TaskId,Created,CreatedBy,LastModified,LastModifiedBy)
				VALUES(@ClientId, @NewTaskId, getdate(), @CreatedBy, getdate(), @CreatedBy)

				--Associate the task with matter
				INSERT INTO tblMatterTask(MatterId, TaskId) 
				VALUES(@SettlementMatter, @NewTaskId)

				--Insert Client Alerts
				INSERT INTO tblClientAlerts(ClientId, AlertType, AlertDescription, AlertRelationType, AlertRelationId, Created, CreatedBy)
				SELECT @ClientId, 2, ('Waiting for client approval of settlement ' + g.[Name] + ' #' + SUBSTRING(AccountNumber, len(AccountNumber) - 3, 4) + ' for $' + CONVERT(varchar(20), s.SettlementAmount, 1)), 'tblSettlements', @SettlementId, getdate(), @CreatedBy 
				FROM tblSettlements s inner join tblAccount a ON a.AccountId = s.CreditorAccountId
				inner join tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId
				inner join tblCreditor c on c.CreditorId = ci.CreditorId 
				inner join tblCreditorGroup g on g.creditorgroupid = c.creditorgroupid
				WHERE SettlementId = @SettlementId
				
				SET @Note = @UserName + ' created a task of type ' + @TaskTypeName + ' on '+ convert(varchar(50), getdate());
				EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @SettlementMatter,
											 @AccountId,@CreatedBy, @NewTaskId, @Note,null,null,null, null,null;

			END
			ELSE BEGIN
				SET @Return = -5;
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


GRANT EXEC ON stp_InsertTaskForSettlement TO PUBLIC

GO


