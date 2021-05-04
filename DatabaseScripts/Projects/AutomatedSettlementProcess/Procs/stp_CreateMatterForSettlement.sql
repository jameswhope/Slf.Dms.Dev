IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CreateMatterForSettlement')
	BEGIN
		DROP  Procedure  stp_CreateMatterForSettlement
	END

GO

CREATE Procedure [dbo].[stp_CreateMatterForSettlement]
(
	@ClientId int,
	@SettlementId int,
	@CreditorAcctId int, 	
	@MatterStatusCodeId int,
	@CreatedBy int,	
	@MatterTypeId int,
	@MatterStatusId int,
	@MatterMemo varchar(max),
	@MatterSubStatusId int
)
AS
BEGIN
	DECLARE @Return int
			,@ClientExists BIT
			,@SettlementExists BIT			
			,@AttorneyId INT
			,@MatterTypeExists BIT	
			,@MatterNumber VARCHAR(50)
			,@MatterId INT	
			,@InstanceId INT
			,@InTran BIT
			,@Note VARCHAR(max)
			,@UserName VARCHAR(50)
			,@AdjustedFee money
			,@DeliveryAmount money
			,@DeliveryMethod varchar(50)
			,@NoteId INT;
		

	SELECT @Return = 0
	,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 1 ELSE 0 END)
	,@ClientExists = (CASE WHEN (SELECT count(*) FROM tblClient WHERE ClientId = @ClientId) > 0 THEN 1 ELSE 0 END)
	,@MatterTypeExists = (CASE WHEN (SELECT count(*) FROM tblMatterType WHERE MatterTypeId = @MatterTypeId) > 0 THEN 1 ELSE 0 END)
	,@SettlementExists = (CASE WHEN (SELECT count(*) FROM tblSettlements WHERE SettlementId = @SettlementId) > 0 THEN 1 ELSE 0 END)
    ,@AttorneyId = (SELECT a.AttorneyId FROM tblClient c
					Inner Join tblPerson p ON c.PrimaryPersonId = p.PersonId 
					Inner Join tblState s ON s.StateId = p.StateId 
					Inner Join tblCompanyStatePrimary a ON a.CompanyId = c.CompanyId And s.Abbreviation = a.State
					Where c.ClientId = @ClientId )
	,@MatterNumber = CONVERT(VARCHAR(50), (SELECT max(MatterId)+1 FROM tblMatter))
	,@InstanceId = (SELECT CurrentCreditorInstanceId FROM tblAccount WHERE AccountId = @CreditorAcctId AND ClientId = @ClientId)
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy);

	SELECT @AdjustedFee = AdjustedSettlementFee, @DeliveryAmount = DeliveryAmount, @DeliveryMethod = DeliveryMethod
		FROM tblSettlements WHERE SettlementId = @SettlementId

	IF @ClientExists = 0 SET @Return = -2
	ELSE IF @MatterTypeExists = 0 SET @Return = -3
	ELSE IF @SettlementExists = 0 SET @Return = -4;

	IF @Return = 0 BEGIN
		IF @InTran = 1 BEGIN TRANSACTION;
		BEGIN TRY
			EXEC @Return = [stp_UpdateSettlementCalculations] @SettlementId, @CreatedBy, @DeliveryMethod, @DeliveryAmount, @AdjustedFee;			

			--Insert the new Matter
			INSERT INTO tblMatter(ClientId, MatterStatusCodeId, MatterNumber, MatterDate, MatterMemo, CreatedDateTime, 
								  CreatedBy, CreditorInstanceId, AttorneyId, MatterTypeId, IsDeleted, MatterStatusId, 
								  MatterSubStatusId)
			VALUES(@ClientId, @MatterStatusCodeId, @MatterNumber, getdate(), @MatterMemo, getdate(),
					@CreatedBy, @InstanceId, @AttorneyId, @MatterTypeId, 0, @MatterStatusId, @MatterSubStatusId);

			SET @MatterId = SCOPE_IDENTITY();

			--Associate the newly created matter with settlement
			UPDATE tblSettlements 
			SET MatterId = @MatterId,
				LocalCounselId = @AttorneyId,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy	 
			WHERE SettlementId = @SettlementId;

			SET @Note = 'Generated a Matter for the settlement ' + convert(varchar(20), @SettlementId)+ ' by '+@UserName+' on '+ convert(varchar(50), getdate());

			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, null, @Note, null, null, null,null,@NoteId output;

			INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
			VALUES(@SettlementId, @MatterStatusCodeId, @NoteId, @CreatedBy, getdate())
			
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


GRANT EXEC ON stp_CreateMatterForSettlement TO PUBLIC

GO


