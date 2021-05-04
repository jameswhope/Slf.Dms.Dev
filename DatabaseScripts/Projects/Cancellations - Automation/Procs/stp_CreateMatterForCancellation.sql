IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CreateMatterForCancellation')
	BEGIN
		DROP  Procedure  stp_CreateMatterForCancellation
	END

GO

CREATE Procedure [dbo].[stp_CreateMatterForCancellation]
(
	@ClientId int,
	@CreatedBy int,
	@CreatedOnStatusChanged bit,
	@MatterId int output
)
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
			,@HasAssociatedMatters BIT
			,@HasLegalMatters BIT
			,@IsFeeOwed BIT
			,@TaskTypeId INT
			,@IsSDAFundsAvailable BIT
			,@DueDate DATETIME;
		

	SELECT @Return = 0
	,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 1 ELSE 0 END)
	,@ClientExists = (CASE WHEN (SELECT count(*) FROM tblClient WHERE ClientId = @ClientId) > 0 THEN 1 ELSE 0 END)
    ,@AttorneyId = (SELECT a.AttorneyId FROM tblClient c
					Inner Join tblPerson p ON c.PrimaryPersonId = p.PersonId 
					Inner Join tblState s ON s.StateId = p.StateId 
					Inner Join tblCompanyStatePrimary a ON a.CompanyId = c.CompanyId And s.Abbreviation = a.State
					Where c.ClientId = @ClientId )
	,@MatterNumber = CONVERT(VARCHAR(50), (SELECT max(MatterId)+1 FROM tblMatter))
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
	,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
	,@MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'CS')
	,@MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Survey')
	,@HasAssociatedMatters = (CASE WHEN 
								(SELECT count(*) FROM tblMatter WHERE ClientId = @ClientId and 
								isDeleted = 0 and MatterStatusId not in (2,4)) > 0  THEN 1 ELSE 0 END)
	,@HasLegalMatters = (CASE WHEN 
								(SELECT count(*) FROM tblAccount WHERE ClientId = @ClientId and 
								AccountStatusId in (157, 160, 166, 164)) > 0  THEN 1 ELSE 0 END)
	,@IsFeeOwed = (CASE WHEN 
					(SELECT PFOBalance FROM tblClient WHERE ClientId = @ClientId) > 0  THEN 1 ELSE 0 END)
	,@IsSDAFundsAvailable = (CASE WHEN 
					(SELECT SDABalance FROM tblClient WHERE ClientId = @ClientId) > 0  THEN 1 ELSE 0 END);

	DECLARE @AccountTbl TABLE(AccountId INT);
	
	INSERT INTO @AccountTbl(AccountId)
	SELECT AccountID FROM tblAccount where AccountId not in (
	SELECT a.AccountId
	FROM 
		tblMatter m inner join
		tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join
		tblAccount a ON a.CurrentCreditorInstanceId = ci.CreditorInstanceId
	WHERE 
		m.ClientId = @ClientId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) 
	UNION
	SELECT AccountId 
	FROM 
		tblAccount 
	WHERE 
		AccountStatusid IN (55,54,157,160,164,166) and ClientId = @ClientId) 
	and ClientId = @ClientId;

	IF @ClientExists = 0 SET @Return = -2;

	IF @Return = 0 BEGIN
		IF @InTran = 1 BEGIN TRANSACTION;
		BEGIN TRY

			--Insert the new Matter
			INSERT INTO tblMatter(ClientId, MatterStatusCodeId, MatterNumber, MatterDate, MatterMemo, CreatedDateTime, 
								  CreatedBy, CreditorInstanceId, AttorneyId, MatterTypeId, IsDeleted, MatterStatusId, 
								  MatterSubStatusId)
			VALUES(@ClientId, @MatterStatusCodeId, @MatterNumber, getdate(), 'Cancellation Matter', getdate(),
					@CreatedBy, null, @AttorneyId, 4, 0, 1, @MatterSubStatusId);

			SET @MatterId = SCOPE_IDENTITY();

			INSERT INTO tblCancellation(ClientId, MatterId, HasAssociatedMatters, HasLegalMatters, 
										IsFeeOwed, IsSDAFundsAvailable, Created, CreatedBy, LastModified,
										LastModifiedBy, IsDeleted, CreatedOnStatusChanged)
			VALUES(@ClientId, @MatterId, @HasAssociatedMatters, @HasLegalMatters, @IsFeeOwed,
				   @IsSDAFundsAvailable, getdate(), @CreatedBy, getdate(), @CreatedBy, 0, @CreatedOnStatusChanged);

			--Update the status of all accounts to Pending Cancellation
			UPDATE tblAccount SET
				PreviousStatus = AccountStatusId,
				AccountStatusId = 170,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE AccountId IN( SELECT AccountId FROM @AccountTbl) 	

			--Audit Account Status Change
			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
			SELECT 127, AccountId, 170, getdate(), @CreatedBy, 0
			FROM @AccountTbl  

			INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
			VALUES( 52, @ClientId, 25, getdate(), @CreatedBy, 0);
			
			UPDATE tblClient SET 
				HasAssociatedMatters = @HasAssociatedMatters,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE ClientId = @ClientId;

			IF @CreatedOnStatusChanged = 1 BEGIN
				SET @TaskTypeId = (SELECT TaskTypeId FROM tblTaskType WHERE [Name] = 'Call Client For Cancellation');
				SET @DueDate =( SELECT DATEADD(d, 5, getdate()));
				EXEC @Return = stp_InsertTaskForSettlement1 @MatterId, null, @TaskTypeId, @DueDate, 'Call Client For Cancellation', @CreatedBy;
			END

			IF @Return = 0 BEGIN
				SET @Note = 'A cancellation matter was created by ' + @UserName+' for '+ @ClientName + ' on ' + convert(varchar(50), getdate());

				--Insert Note
				EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, null, @Note, null, null, null,null,@NoteId output;

				--Enter Roadmap
				INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
				VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate())
			END
			
			DELETE @AccountTbl;

			IF @InTran = 1 BEGIN
				IF @Return = 0 COMMIT ELSE ROLLBACK;
			END
		END TRY
		BEGIN CATCH
			SET @Return = -1;
			IF @InTran = 1 ROLLBACK;
		END CATCH
	END

	RETURN @Return;
END
GO