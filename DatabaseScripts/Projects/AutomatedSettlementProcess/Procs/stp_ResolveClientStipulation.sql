IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ResolveClientStipulation')
	BEGIN
		DROP  Procedure  stp_ResolveClientStipulation
	END

GO

CREATE Procedure [dbo].[stp_ResolveClientStipulation]
(	
	@MatterId int,
	@CreatedBy int,
	@DocTypeId nvarchar(50) = null,
	@DateString varchar(50)= null,
	@DocId varchar(50) = null,
	@SubFolder nvarchar(150) = null	
)

AS
BEGIN

	DECLARE @Return INT
			,@InTran BIT			
			,@SettlementId INT
			,@AutoNote VARCHAR(MAX)
			,@ClientId INT
			,@AccountId INT
			,@MatterStatusCodeId INT
			,@MatterSubStatusId INT
			,@MatterStatusId INT
			,@Active BIT
			,@IsDeleted BIT
			,@UserName VARCHAR(50)
			,@SettlementAmount MONEY
			,@DeliveryAmount MONEY
			,@DeliveryMethod VARCHAR(3)
			,@CheckAmount MONEY
			,@DueDate DATETIME
			,@AvailSDA MONEY
			,@IsPaymentArrangement BIT
			,@DownPaymentId int
			,@DownPaymentAmount MONEY
			,@DownPaymentDate DATETIME
			,@PaymentAmount Money
			,@PaymentProcessingId INT;
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy);
		   
	SELECT @SettlementId = SettlementId, @ClientId = s.ClientId, @AccountId = CreditorAccountId, @DueDate = SettlementDueDate,
			@SettlementAmount = SettlementAmount, @DeliveryAmount = DeliveryAmount, @AvailSDA = isnull(AvailSDA,c.SDABalance),
			@DeliveryMethod = (CASE WHEN DeliveryMethod = 'chkbytel' THEN 'P' WHEN DeliveryMethod = 'chkbyemail' THEN 'E' ELSE 'C' END),
			@IsPaymentArrangement = isnull(IsPaymentArrangement,0)
	FROM tblSettlements s
	JOIN tblClient c on c.clientid = s.clientid
	WHERE MatterId = @MatterId;

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

	SET @AutoNote = (SELECT @UserName + ' scanned the signed Client stipulation document. The matter has been pushed to the Accounting Approval queue')
		   
	IF @SettlementId IS NULL SET @Return = -2 --matter does not exist	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY	

			Select @PaymentAmount = case when @IsPaymentArrangement = 1 then @DownPaymentAmount else @SettlementAmount end
				
			IF @AvailSDA >= @PaymentAmount 
				BEGIN
				
					SELECT @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Pending Accounting Approval'), 
						   @MatterStatusId = 3, 
						   @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Accounting Approval'),
						   @Active = 1 ,@IsDeleted = 0
					
					IF Exists(Select PaymentProcessingId From tblAccount_PaymentProcessing Where MatterId = @MatterId and RequestType = 'Settlement')
						RAISERROR('A payment process is already setup for this settlement matter',16,1)
						   
					INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
					VALUES(@MatterId, @DueDate, @AvailSDA, 'Settlement', @CheckAmount, @DeliveryMethod, getdate(), @CreatedBy, getdate(), @CreatedBy, 0)
					
					Select @PaymentProcessingId = scope_identity() 
					
					If @IsPaymentArrangement = 1
						Update tblPaymentSchedule Set PaymentProcessingId = @PaymentProcessingId Where PmtScheduleId = @DownPaymentId
	
				END	
			ELSE 
				BEGIN
					SELECT @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Waiting Manager Approval'), 
						   @MatterStatusId = 3, 
						   @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Waiting Manager Approval'),
						   @Active = 1 ,@IsDeleted = 0
				END
					
			EXEC @Return = stp_ResolveSettlementMatter @SettlementId, 'Signed client stipulation letter added', @AutoNote, @CreatedBy, @ClientId, 84, @AccountId, 
				@DocTypeId, @DateString, @DocId, @SubFolder, 1, @MatterStatusCodeId, @MatterStatusId, @MatterSubStatusId, @IsDeleted, @Active, 1;

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

 

