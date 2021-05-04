IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ResolveClientApprovalTask')
	BEGIN
		DROP  Procedure  stp_ResolveClientApprovalTask
	END

GO

CREATE Procedure [dbo].[stp_ResolveClientApprovalTask]
(	
	@SettlementId int,
	@IsApproved bit,
	@Note varchar(max),			
	@CreatedBy int,
	@ApprovalType varchar(50),
	@ReasonName varchar(50) = null,
	@DateString nvarchar(6),
	@DocId nvarchar(15),
	@SubFolder nvarchar(150),
	@DocTypeId nvarchar(50)
)

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DECLARE @Return INT
			,@InTran BIT			
			,@SettlementMatter INT
			,@MatterStatusCodeId INT
			,@MatterSubStatusId INT
			,@MatterStatusId INT
			,@Active BIT
			,@IsDeleted BIT
			,@ApprovedNote VARCHAR(MAX)
			,@ClientId INT
			,@AccountId INT
			,@TaskId INT
			,@ReasonId INT
			,@AvailSDA MONEY
			,@SettlementAmount MONEY
			,@DeliveryAmount MONEY
			,@DeliveryMethod VARCHAR(3)
			,@CheckAmount MONEY
			,@DueDate DATETIME
			,@IsClientStipulation BIT
			,@IsPaymentArrangement BIT
			,@DownPaymentId int
			,@DownPaymentAmount MONEY
			,@DownPaymentDate DATETIME
			,@TaskTypeId int
			,@PaymentAmount Money
			,@PaymentProcessingId int
;
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END);
		   
	SELECT @SettlementMatter = MatterId, @ClientId = ClientId, @AccountId = CreditorAccountId, @DueDate = SettlementDueDate,
	@AvailSDA = isnull(AvailSDA, RegisterBalance), @SettlementAmount = SettlementAmount, @DeliveryAmount = DeliveryAmount,
	@DeliveryMethod = (CASE WHEN DeliveryMethod = 'chkbytel' THEN 'P' WHEN DeliveryMethod = 'chkbyemail' THEN 'E' ELSE 'C' END),
	@IsClientStipulation = isnull(IsClientStipulation,0),
	@IsPaymentArrangement = isnull(IsPaymentArrangement,0)
	FROM tblSettlements WHERE SettlementId = @SettlementId;
	
	SET @TaskTypeId = CASE WHEN @IsClientStipulation = 1 THEN 78 ELSE 72 END

	SET @TaskId = (SELECT Top 1 TaskId FROM tblTask WHERE TaskId IN (
						SELECT TaskId FROM tblMatterTask WHERE MatterId = @SettlementMatter) and TaskTypeId = @TaskTypeId order by taskid desc);

	IF @ReasonName is not null BEGIN
		SET @ReasonId = (SELECT ReasonId FROM tblClientRejectionReason WHERE lower(ReasonName) = lower(@ReasonName))
	END
	ELSE BEGIN
		SET @ReasonId = null;
	END
	
	-- Get Check Amount
	IF (@IsPaymentArrangement = 1) 
	BEGIN
		Select top 1 @CheckAmount = PmtAmount, @DownPaymentId = PmtScheduleId, @DownPaymentAmount = PmtAmount, @DownPaymentDate = PmtDate
		FROM tblPaymentSchedule 
		Where SettlementId = @SettlementId
		and Deleted is null
		ORDER BY PmtDate, Created
		
		if @CheckAmount Is NULL 
			RAISERROR('First scheduled payment of arrangement not found  ',16,1)
			
	END
	ELSE
	BEGIN
		SET @CheckAmount = @SettlementAmount
	END
	
	SET @CheckAmount = (CASE WHEN (@DeliveryMethod = 'P' and @DeliveryAmount <> 15) THEN (@CheckAmount + @DeliveryAmount) ELSE @CheckAmount END);

	IF @IsApproved = 1 
	BEGIN
		IF @IsClientStipulation = 1
			BEGIN
				SELECT @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Attach Client Signed Stipulation'), 
						   @MatterStatusId = 3, 
						   @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Attach Client Signed Stipulation'),
						   @Active = 1 ,@IsDeleted = 0
						   
			END 
		ELSE
			BEGIN
				Select @PaymentAmount = case when @IsPaymentArrangement = 1 then @DownPaymentAmount else @SettlementAmount end
				
				IF @AvailSDA >= @PaymentAmount 
					BEGIN
						SELECT @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Pending Accounting Approval'), 
							   @MatterStatusId = 3, 
							   @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Accounting Approval'),
							   @Active = 1 ,@IsDeleted = 0
					END	
				ELSE 
					BEGIN
						SELECT @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Waiting Manager Approval'), 
							   @MatterStatusId = 3, 
							   @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Waiting Manager Approval'),
							   @Active = 1 ,@IsDeleted = 0
					END
			END 
		END
	ELSE 
		BEGIN
			SELECT @MatterStatusCodeId = 25, 
				   @MatterStatusId = 2, 
				   @MatterSubStatusId = 53, 
				   @Active = 0, @IsDeleted = 1
		END
		
	IF @SettlementMatter IS NULL SET @Return = -2 --matter does not exist	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY	
			IF @IsApproved = 1 
				BEGIN
					--Insert the Settlement Roadmap
					INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
					VALUES(@SettlementId, 24, null, @CreatedBy, getdate())

					SET @ApprovedNote = (SELECT p.FirstName + ' ' + p.LastName + ' approved settlement with '+ cr.[Name] + ' #' + SUBSTRING(ci.AccountNumber, len(ci.AccountNumber) - 3, 4) + ' for $' + Convert(varchar(10),s.SettlementAmount) + ' through ' + @ApprovalType + ' mode'
										from tblSettlements s
								inner join tblClient c On c.ClientId = s.ClientId
								inner join tblPerson p On p.PersonId = c.PrimaryPersonId
								inner join tblAccount a On a.AccountId = s.CreditorAccountId
								inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
								inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId
								where SettlementId = @SettlementId)
				END
			ELSE 
				BEGIN
					SET @ApprovedNote = (SELECT p.FirstName + ' ' + p.LastName + ' rejected settlement with '+ cr.[Name] + ' #' + SUBSTRING(ci.AccountNumber, len(ci.AccountNumber) - 3, 4) + ' for $' + Convert(varchar(10),s.SettlementAmount) + ' due to reason (' + @ReasonName + ') through ' + @ApprovalType + ' mode'
										from tblSettlements s
								inner join tblClient c On c.ClientId = s.ClientId
								inner join tblPerson p On p.PersonId = c.PrimaryPersonId
								inner join tblAccount a On a.AccountId = s.CreditorAccountId
								inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
								inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId
								where SettlementId = @SettlementId)
				END

			--Insert the Client Approval
			INSERT INTO tblSettlementClientApproval(MatterId, ApprovalType, ReasonId)
			VALUES(@SettlementMatter, @ApprovalType, @ReasonId);
			
			EXEC @Return = stp_ResolveSettlementMatter @SettlementId, @Note, @ApprovedNote, @CreatedBy, @ClientId, @TaskTypeId, @AccountId, 
							@DocTypeId, @DateString, @DocId, @SubFolder, 1, @MatterStatusCodeId, @MatterStatusId, @MatterSubStatusId, @IsDeleted, @Active,@IsApproved;
	
			IF @Return = 0 
				BEGIN
					IF @IsApproved = 1
						BEGIN 
							IF @IsClientStipulation = 1
								BEGIN
									EXEC stp_InsertTaskForSettlement @SettlementId, 84, 'Waiting For client stipulation signed letter', @CreatedBy
									EXEC stp_AssignLastTaskToMatter @SettlementMatter 
								END
							ELSE IF @AvailSDA >= @PaymentAmount 
								BEGIN
									INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
									VALUES(@SettlementMatter, @DueDate, @AvailSDA, 'Settlement', @CheckAmount, @DeliveryMethod, getdate(), @CreatedBy, getdate(), @CreatedBy, 0)
									
									Select @PaymentProcessingId = scope_identity() 
								
									If @IsPaymentArrangement = 1
										Update tblPaymentSchedule Set PaymentProcessingId = @PaymentProcessingId Where PmtScheduleId = @DownPaymentId
								END	
						END

					--resolve client alert
					UPDATE tblclientalerts
					SET Resolved = getdate(), ResolvedBy = @CreatedBy
					WHERE AlertRelationType = 'tblSettlements' 
					and AlertDescription like 'Waiting for client approval of settlement%'
					and resolved is null 
					and alertrelationid = @SettlementId;
				END
			ELSE 
				BEGIN
					SET @Return = -3;
				END
			
			IF @InTran = 0 
				BEGIN
				 IF @Return = 0 COMMIT ELSE ROLLBACK;
				END
		END TRY
		BEGIN CATCH
			--SELECT ERROR_MESSAGE() 
			SET @Return = -1;
			IF @InTran = 0 ROLLBACK;
		END CATCH
	END
	
	RETURN @Return
END
