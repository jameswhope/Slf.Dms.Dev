IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ChangeDeliveryMethod')
	BEGIN
		DROP  Procedure  stp_ChangeDeliveryMethod
	END

GO

CREATE Procedure [dbo].[stp_ChangeDeliveryMethod]
(	
	@MatterId int,
	@DeliveryMethod varchar(2),
	@DeliveryAmount Money,
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
	@CreatedBy int
)

AS
BEGIN

	DECLARE @Return INT
			,@InTran BIT
			,@SettlementId INT
			,@MatterTypeId INT
			,@ClientId INT
			,@AccountId INT
			,@UserName VARCHAR(50)
			,@DelMethod VARCHAR(20)
			,@OldDelMethod VARCHAR(20)
			,@DelMethodFullForm VARCHAR(20)
			,@ReqType VARCHAR(50)
			,@Amount MONEY
			,@CheckAmount MONEY
			,@CancelDelFee MONEY
			,@ApprovedNote VARCHAR(MAX)
			,@NoteId INT;			
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END);

	SELECT @ClientId = m.ClientId, @MatterTypeId = m.MatterTypeId, @ReqType = acc.RequestType,
		   @OldDelMethod = (CASE WHEN acc.DeliveryMethod = 'C' THEN 'Check' 
								  WHEN acc.DeliveryMethod = 'P' THEN 'Check By Phone'
								  ELSE 'Check By Email'  END),
		   @AccountId = ci.AccountId
	FROM tblAccount_PaymentProcessing acc inner join
		 tblMatter m ON m.MatterId = acc.MatterId left join
		 tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId 
	WHERE acc.MatterId = @MatterId 

	SELECT @UserName = FirstName + ' ' + LastName FROM tblUser WHERE UserID = @CreatedBy;
	SELECT @DelMethod = (CASE WHEN @DeliveryMethod = 'C' THEN 'chk' 
								  WHEN @DeliveryMethod = 'P' THEN 'chkbytel'
								  ELSE 'chkbyemail'  END)
	SELECT @DelMethodFullForm = (CASE WHEN @DeliveryMethod = 'C' THEN 'Check' 
								  WHEN @DeliveryMethod = 'P' THEN 'Check By Phone'
								  ELSE 'Check By Email'  END)	
	
	IF @MatterTypeId = 3 BEGIN
		SELECT @Amount = SettlementAmount, @SettlementId = SettlementId	FROM tblSettlements WHERE MatterId = @MatterId;
		
		SELECT @CheckAmount = (CASE 
								WHEN (@DeliveryMethod = 'P' and @DeliveryAmount <> 15) THEN (@Amount + @DeliveryAmount)
								ELSE @Amount  END)
	END
	ELSE IF @MatterTypeId = 4 BEGIN
		SELECT @Amount = c.TotalRefund, @CancelDelfee = ad.DeliveryFee FROM tblCancellation c inner join tblAccount_DeliveryInfo ad ON c.MatterId = ad.MatterId WHERE c.MatterId = @MatterId;
		
		SELECT @CheckAmount = (CASE 
								WHEN (@DeliveryMethod = 'P' and (@DeliveryAmount <> 15 OR @DeliveryAmount <> 0)) THEN (@Amount - @CancelDelfee + @DeliveryAmount)
								ELSE @Amount  END)
	END


	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY	
			IF @OldDelMethod = @DelMethodFullForm BEGIN
				SET @ApprovedNote = (SELECT @UserName + ' changed the PayableTo field to ' + @PayableTo	)
			END
			ELSE BEGIN
				SET @ApprovedNote = (SELECT @UserName + ' changed the delivery method of ' + @ReqType + ' for ' + p.FirstName + ' ' + p.LastName + ' from ' + @OldDelMethod + ' to ' + @DelMethodFullForm
									from tblMatter m
							inner join tblClient c On c.ClientId = m.ClientId
							inner join tblPerson p On p.PersonId = c.PrimaryPersonId
							where MatterId = @MatterId)
			END

			IF not exists (SELECT 1 FROM tblAccount_DeliveryInfo WHERE MatterId = @MatterId) BEGIN
				INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState, 
							DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail, PayableTo, AttentionTo, 
							ContactName, DeliveryFee)
				VALUES(@MatterId, @Address, @City, @State, @Zip, @ContactNumber, null, @EmailAddress, @PayableTo,
						@AttentionTo, @ContactName, @DeliveryAmount)
			END 
			ELSE BEGIN
				UPDATE tblAccount_DeliveryInfo
				SET  AttentionTo = @AttentionTo,
					[DeliveryAddress] = @Address,
					DeliveryCity = @City,
					[DeliveryState] = @State,
					DeliveryZip = @Zip,
					DeliveryEmail = @EmailAddress,
					ContactName = @ContactName,
					PayableTo = @PayableTo,
					DeliveryPhone = @ContactNumber,					
					DeliveryFee = (case when @MatterTypeId = 3 THEN null when @DeliveryAmount = 0 THEN 15 ELSE @DeliveryAmount END)
				WHERE MatterId = @MatterId;	
			END
			
			UPDATE tblMatter SET
				MatterStatusCodeId = @MatterStatusCodeId,			
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusId = @MatterStatusId
				WHERE MatterId = @MatterId

			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, @AccountId,@CreatedBy, null, @ApprovedNote, null, null, null, null,@NoteId output;
		
			UPDATE tblAccount_PaymentProcessing
			SET DeliveryMethod = @DeliveryMethod,
				CheckAmount = @CheckAmount,
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE MatterId = @MatterId;
		
			IF @MatterTypeId = 3 BEGIN
				INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
				VALUES(@SettlementId, @MatterStatusCodeId, @NoteId, @CreatedBy, getdate())
			END
			ELSE IF @MatterTypeId = 4 BEGIN
				IF @DeliveryAmount <> 15 OR @DeliveryAmount <> 0 BEGIN
					UPDATE tblCancellation SET TotalRefund = @CheckAmount WHERE MatterId = @MatterId
				END
			
				INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
				VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate())
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


