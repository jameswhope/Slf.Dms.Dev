IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_ReopenMatter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_ReopenMatter
	END

GO

CREATE Procedure stp_NonDeposit_ReopenMatter 
@MatterId int,
@NonDepositTypeId int,
@MissedDate datetime,
@DepositId int,
@UserId int
AS
BEGIN

	DECLARE @Return int
	,@ClientId int
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
	,@NonDepositId int
	,@ReplacementId int;
		
	SELECT @Return = 0
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @UserId)
	,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
	,@MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'ND_RE')
	,@MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Recontact Client')
	,@ClientId = (Select clientid from tblmatter where matterid = @MatterId) ;
	
 		
		BEGIN TRY

			--Update the Matter
			Update tblMatter Set
			MatterStatusCodeId = @MatterStatusCodeId,
			MatterStatusId = 3,
			MatterSubStatusId = @MatterSubStatusId
			Where MatterId = @MatterId
			
			--Update the Non Deposit Send Letter Status
			SElect @NonDepositId = NonDepositId, @ReplacementId = CurrentReplacementId From tblNondeposit
			Where MatterId = @MatterId
			
			--create need for a letter
			exec stp_NonDeposit_InsertLetter @NonDepositId, @ReplacementId, @DepositId, 'Pending', @UserId
					 
			SET @TaskTypeId = (SELECT TaskTypeId FROM tblTaskType WHERE [Name] = 'Recontact Client - NonDeposit');
			SET @DueDate =( SELECT DATEADD(m, 1, getdate()));
			
			EXEC @Return = stp_NonDeposit_InsertTaskForNonDeposit @MatterId, @TaskTypeId, @DueDate, 'Call client for Non Deposit replacement', @UserId, @NonDepositTypeId;

			IF @Return = 0 BEGIN
				If @NonDepositTypeId = 1
					SET @Note = 'A non deposit matter was reopened by ' + @UserName+' for '+ @ClientName + ' on ' + convert(varchar(50), getdate()) + '. Client missed replacement deposit on ' + convert(varchar(50), @MissedDate);
				ELSE
					BEGIN
						DECLARE @BouncedDate datetime
						Select @BouncedDate=Bounce  from tblregister where registerid = @DepositId
						SET @Note = 'A non deposit matter was updated by ' + @UserName+ ' for ' + @ClientName + ' on ' + convert(varchar(50), getdate()) + '. Replacement deposit #' + convert(varchar(50), @DepositId) + ' bounced on ' + convert(varchar(50), @BouncedDate);
					END

				--Insert Note
				EXEC @Return = stp_NonDeposit_InsertNoteForNonDepositMatter @ClientId, @MatterId, @UserId, null, @Note, null, null, null,null,@NoteId output;

				--Enter Roadmap
				DECLARE @UserGroupId int Set @UserGroupId = NULL
				Select @UserGroupId = UserGroupId From tbluser where userid = @UserId
				
				INSERT INTO tblNonDepositRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created, UserGroupId)
				VALUES(@MatterId, @MatterStatusCodeId, @UserId, getdate(), @UserGroupId)
			END
			
		END TRY
		BEGIN CATCH
			Print 'MATTER ' + ERROR_MESSAGE();
			SET @Return = -1;
		END CATCH
	RETURN @Return;
	
END

GO



