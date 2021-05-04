Alter Procedure [dbo].[stp_ChangeSettlementDeliveryMethod]
(	
	@PaymentProcessingId int,
	@SettlementId int,
	@DeliveryMethod varchar(2),
	@DeliveryAmount money,
	@AttentionTo varchar(200) = null,
	@Address varchar(500) = null,
	@City varchar(200) = null,
	@State varchar(2) = null,
	@Zip varchar(20) = null,
	@EmailAddress varchar(200) = null,
	@ContactNumber varchar(30) = null,
	@ContactName varchar(200) = null,
	@PayableTo varchar(200) = null,
	@MatterStatusCodeId int,
	@MatterSubStatusId int,
	@MatterStatusId int,
	@Note varchar(max) = null,			
	@CreatedBy int
)

AS
BEGIN

	DECLARE @Return INT
			,@InTran BIT
			,@Settlementmatter INT
			,@AdjustedFee MONEY
			,@ClientId INT
			,@AccountId INT
			,@UserName VARCHAR(50)
			,@DelMethod VARCHAR(20)
			,@OldDelMethod VARCHAR(20)
			,@DelMethodFullForm VARCHAR(20)
			,@SettlementAmount MONEY
			,@PaymentAmount MONEY
			,@CheckAmount MONEY
			,@ApprovedNote VARCHAR(MAX)
			,@RequestType varchar(200)
			,@IsPaymentArrangement bit
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END);
		   
	SELECT @SettlementMatter = MatterId, @ClientId = ClientId, @AccountId = CreditorAccountId, 
			@AdjustedFee = AdjustedSettlementFee, @SettlementAMount = SettlementAmount,
			@OldDelMethod = (CASE WHEN DeliveryMethod = 'chk' THEN 'Check' 
								  WHEN DeliveryMethod = 'chkbytel' THEN 'Check By Phone'
								  ELSE 'Check By Email'  END),
			@IsPaymentArrangement = IsPaymentArrangement
	FROM tblSettlements WHERE SettlementId = @SettlementId;
	
	SELECT @RequestType From tblAccount_PaymentProcessing Where PaymentProcessingId = @PaymentProcessingId
	
	IF @IsPaymentArrangement = 1
		Select @PaymentAmount = pmtamount from tblPaymentSchedule Where PaymentProcessingId = @PaymentProcessingId And Deleted is null
	Else 
		Select @PaymentAmount = @SettlementAmount

	SELECT @UserName = FirstName + ' ' + LastName FROM tblUser WHERE UserID = @CreatedBy;
	SELECT @DelMethod = (CASE WHEN @DeliveryMethod = 'C' THEN 'chk' 
								  WHEN @DeliveryMethod = 'P' THEN 'chkbytel'
								  ELSE 'chkbyemail'  END)
	SELECT @DelMethodFullForm = (CASE WHEN @DeliveryMethod = 'C' THEN 'Check' 
								  WHEN @DeliveryMethod = 'P' THEN 'Check By Phone'
								  ELSE 'Check By Email'  END)

	SELECT @CheckAmount = (CASE WHEN (@DeliveryMethod = 'P' and @DeliveryAmount <> 15) THEN (@PaymentAmount + @DeliveryAmount)
								  ELSE @PaymentAmount END)
		   
	IF @SettlementMatter IS NULL SET @Return = -2 --matter does not exist	
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY	
			IF @OldDelMethod = @DelMethodFullForm BEGIN
				SET @ApprovedNote = (SELECT @UserName + ' changed the PayableTo field from ' + isnull(sd.PayableTo, cr.[Name]) + ' to ' + @PayableTo
											FROM tblSettlements s
											inner join tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId
											inner join tblAccount a ON a.AccountId = s.CreditorAccountId 
											inner join tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId 
											inner join tblCreditor cr ON cr.CreditorId = ci.CreditorId
										WHERE s.SettlementId = @SettlementId)
			END
			ELSE BEGIN
				SET @ApprovedNote = (SELECT @UserName + ' changed the delivery method of settlement between ' + p.FirstName + ' ' + p.LastName + ' and ' + cr.[Name] + ' from ' + @OldDelMethod + ' to ' + @DelMethodFullForm
									from tblSettlements s
							inner join tblClient c On c.ClientId = s.ClientId
							inner join tblPerson p On p.PersonId = c.PrimaryPersonId
							inner join tblAccount a On a.AccountId = s.CreditorAccountId
							inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
							inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId
							where SettlementId = @SettlementId)
			END

			EXEC @Return = [stp_UpdateSettlementCalculations] @SettlementId, @CreatedBy, @DelMethod, @DeliveryAmount, @AdjustedFee;	

			UPDATE tblSettlements_DeliveryAddresses
			SET AttentionTo = @AttentionTo,
				[Address] = @Address,
				City = @City,
				[State] = @State,
				Zip = @Zip,
				EmailAddress = @EmailAddress,
				ContactName = @ContactName,
				PayableTo = @PayableTo,
				ContactNumber = @ContactNumber
			WHERE SettlementID = @SettlementId;		
			
			EXEC @Return = stp_ResolveSettlementMatter @SettlementId, @Note, @ApprovedNote, @CreatedBy, @ClientId, null, @AccountId, 
							null, null, null, null, 1, @MatterStatusCodeId, @MatterStatusId, @MatterSubStatusId, 0, 1,1;
		
			UPDATE tblAccount_PaymentProcessing
			SET DeliveryMethod = @DeliveryMethod,
				CheckAmount = @CheckAmount,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE PaymentProcessingId = @PaymentProcessingId;
			
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