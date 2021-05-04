IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_CreateMatter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_CreateMatter 
	END

GO

CREATE Procedure stp_NonDeposit_CreateMatter 
@ClientId int,
@CreatedBy int,
@NonDepositTypeId int,
@MissedDate datetime,
@DepositAmount money, 
@DepositId int,
@PlanId int = null,
@MatterId int output
AS
BEGIN
	DECLARE @Return int
	,@ClientExists BIT
	,@AttorneyId INT
	,@MatterNumber VARCHAR(50)
	,@InTran BIT
	,@MatterStatusCodeId INT
	,@MatterSubStatusid INT
	,@Note VARCHAR(max)
	,@UserName VARCHAR(50)
	,@NoteId INT
	,@ClientName VARCHAR(100)
	,@TaskTypeId INT
	,@DueDate DATETIME
	,@ReasonId Int
	,@NonDepositId Int;
		
	SELECT @Return = 0
	,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 1 ELSE 0 END)
	,@ClientExists = (CASE WHEN (SELECT count(*) FROM tblClient WHERE ClientId = @ClientId) > 0 THEN 1 ELSE 0 END)
    ,@AttorneyId = NULL
	,@MatterNumber = CONVERT(VARCHAR(50), (SELECT max(MatterId)+1 FROM tblMatter))
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
	,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
	,@MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'ND_CR')
	,@MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Contact Client');
 		
	IF @ClientExists = 0 SET @Return = -2;
	
	IF @Return = 0 BEGIN
		IF @InTran = 1 BEGIN TRANSACTION;
		BEGIN TRY

			--Insert the new Matter
			INSERT INTO tblMatter(ClientId, MatterStatusCodeId, MatterNumber, MatterDate, MatterMemo, CreatedDateTime, 
								  CreatedBy, CreditorInstanceId, AttorneyId, MatterTypeId, IsDeleted, MatterStatusId, 
								  MatterSubStatusId)
			VALUES(@ClientId, @MatterStatusCodeId, @MatterNumber, getdate(), 'Non Deposit Matter Generated', getdate(),
					@CreatedBy, null, @AttorneyId, 5, 0, 1, @MatterSubStatusId);

			SET @MatterId = SCOPE_IDENTITY();
			
			--get the planid associated to the deposit when not provided			
			If @PlanId is null and @DepositId is not null
			begin
				select top 1 @Planid = planid 
				from tblPlannedDepositRegisterXref 
				where registerid = @DepositId 
				order by created desc
			end

			--create the non deposit record
			INSERT INTO tblNonDeposit(ClientId, MatterId, Created, CreatedBy, LastModified, LastModifiedBy, NonDepositTypeId, MissedDate, DepositId, DepositAmount, PlanId)
			VALUES(@ClientId, @MatterId, getdate(), @CreatedBy, getdate(), @CreatedBy, @NonDepositTypeId, @MissedDate, @DepositId, @DepositAmount, @PlanId);
			
			Select @NonDepositId = scope_identity();
			
			--create need for a letter
			exec stp_NonDeposit_InsertLetter @NonDepositId, null, @DepositId , 'Pending', @CreatedBy

			SET @TaskTypeId = (SELECT TaskTypeId FROM tblTaskType WHERE [Name] = 'Contact Client - NonDeposit');
			SET @DueDate =( SELECT DATEADD(m, 1, getdate()));
			
			EXEC @Return = stp_NonDeposit_InsertTaskForNonDeposit @MatterId, @TaskTypeId, @DueDate, 'Call Client For Non Deposit', @CreatedBy, @NonDepositTypeId;

			IF @Return = 0 BEGIN
				If @NonDepositTypeId = 1
					SET @Note = 'A non deposit matter was created by ' + @UserName+' for '+ @ClientName + ' on ' + convert(varchar(50), getdate()) + '. Client missed deposit on ' + convert(varchar(50), @MissedDate);
				ELSE
					BEGIN
						DECLARE @BouncedDate datetime
						Select @BouncedDate=Bounce  from tblregister where registerid = @DepositId
						SET @Note = 'A non deposit matter was created by ' + @UserName+' for '+ @ClientName + ' on ' + convert(varchar(50), getdate()) + '. Deposit #' + convert(varchar(50), @DepositId) + ' bounced on ' + convert(varchar(50), @BouncedDate);
					END

				--Insert Note
				EXEC @Return = stp_NonDeposit_InsertNoteForNonDepositMatter @ClientId, @MatterId, @CreatedBy, null, @Note, null, null, null,null,@NoteId output;

				--Enter Roadmap
				DECLARE @UserGroupId int Set @UserGroupId = NULL
				Select @UserGroupId = UserGroupId From tbluser where userid = @CreatedBy
				
				INSERT INTO tblNonDepositRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created, UserGroupId)
				VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate(), @UserGroupId)
				
			END
			
			IF @InTran = 1 BEGIN
				IF @Return = 0 COMMIT ELSE ROLLBACK;
			END
		END TRY
		BEGIN CATCH
			Print 'MATTER ' + ERROR_MESSAGE();
			SET @Return = -1;
			IF @InTran = 1 ROLLBACK;
		END CATCH
	END

	RETURN @Return;
	
END


GO



