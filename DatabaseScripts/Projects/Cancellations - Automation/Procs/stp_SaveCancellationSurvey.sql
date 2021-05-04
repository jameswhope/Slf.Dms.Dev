IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SaveCancellationSurvey')
	BEGIN
		DROP  Procedure  stp_SaveCancellationSurvey
	END

GO

CREATE Procedure [dbo].[stp_SaveCancellationSurvey]
(
	@MatterId int,
	@totalRefund money,
	@CreatedBy int,
	@isRefundRequested bit,
	@clientAgreedToPay bit,
	@CancellationSubReasonId int,
	@AgencyName varchar(50),
	@AttorneyName varchar(50),
	@FieldComment varchar(200),
	@PhoneNumber varchar(20),
	@Email varchar(200),
	@City varchar(50),
	@Street varchar(100),
	@State varchar(5),
	@ZipCode varchar(6),
	@PayableTo varchar(50),
	@DeliveryMethod varchar(5),
	@DeliveryFee money,
	@AccountsRefunded xml
)
AS
BEGIN
	DECLARE @Return INT
			,@ClientId INT
			,@InTran BIT
			,@MatterStatusCodeId INT			
			,@MatterSubStatusid INT
			,@Note VARCHAR(max)
			,@UserName VARCHAR(50)
			,@NoteId INT
			,@ClientName VARCHAR(100)
			,@TaskId INT
			,@IsMatterPresent INT
			,@IsRequestPresent BIT
			,@MatterDate DATETIME
			,@IsFeeOwed BIT
			,@DueDate DATETIME
			,@AvailSDA MONEY;

	SELECT @ClientId = ClientId, @MatterDate = MatterDate FROM tblMatter WHERE MatterId = @MatterId;
	SELECT @IsMatterPresent = HasAssociatedMatters, @IsFeeOwed = IsFeeOwed FROM tblCancellation WHERE MatterId = @MatterId

	SELECT @Return = 0
	,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 1 ELSE 0 END)
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
	,@AvailSDA = (SELECT AvailableSDA FROM tblClient WHERE ClientId = @ClientId)
	,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
	,@TaskId = (SELECT mt.TaskId FROM tblMatterTask mt inner join tblTask t ON t.TaskId = mt.TaskId and t.TaskResolutionId is null WHERE mt.MatterId = @MatterId);
	
	SELECT @IsRequestPresent = (CASE 
									WHEN (SELECT count(*) FROM tblDocRelation WHERE ClientId = @ClientId and 
										RelatedDate > @MatterDate and DeletedFlag = 0 and DocTypeId = 'D8019SCAN') = 0 AND 
										(@CancellationSubReasonId = 32 or @CancellationSubReasonId = 15 or @CancellationSubReasonId = 16 or @CancellationSubReasonId =17) THEN 1 
									WHEN (SELECT count(*) FROM tblDocRelation WHERE ClientId = @ClientId and 
										RelatedDate > @MatterDate and DeletedFlag = 0 and DocTypeId = '9028') = 0 AND 
										@CancellationSubReasonId = 30 THEN 2 
									WHEN (SELECT count(*) FROM tblDocRelation WHERE ClientId = @ClientId and 
										RelatedDate > @MatterDate and DeletedFlag = 0 and DocTypeId = '9037') = 0 THEN 3
									ELSE 0 
								END);

	IF @IsMatterPresent = 1 BEGIN
		---set status to Pending Matter Resolution
		SET @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Matter Resolution' );
		SET @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'PMR' );
	END
	ELSE IF @IsFeeOwed = 1 and @clientAgreedToPay = 1 BEGIN
		---set status to Pending Fee deposit by client
		SET @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Fee Recovery' );
		SET @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'PFR' );
	END
	ELSE IF @isRequestPresent = 1 BEGIN
		SET @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Waiting on Bankruptcy Document' );
		SET @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'PBD' );
	END
	ELSE IF @isRequestPresent = 2 BEGIN
		SET @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Waiting on Death Certificate' );
		SET @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'PDC' );
	END
	ELSE IF @isRequestPresent = 3 BEGIN
		---set status to Pending Client Request Receipt
		SET @MatterSubStatusId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Receipt of Cancellation Request' );
		SET @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'PCR' );
	END
	ELSE BEGIN
		-----set status to Pending Accounting approval
		SET @MatterSubStatusId = 67;
		SET @MatterStatusCodeId = 38;
	END

	IF @ClientId is null SET @Return = -2;

	IF @Return = 0 BEGIN
		IF @InTran = 1 BEGIN TRANSACTION;
		BEGIN TRY

			UPDATE tblCancellation SET
				ClientRequestedRefund = @isRefundRequested,
				ClientAgreedToPay = @clientAgreedToPay,
				TotalRefund = @TotalRefund,				
				LastModified = getdate(),
				LastModifiedBy = @CreatedBy
			WHERE MatterId = @MatterId

			INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
			VALUES(@MatterId, 47, @CreatedBy, getdate())

			IF @TaskId is not null BEGIN
				--Resolve the task
				EXEC @Return = stp_UpdateTaskForSettlement @TaskId, 'Call Client For Cancellation', @CreatedBy, @CreatedBy, 1;
				IF @Return <> 0 SET @Return = -4;
			END

			IF @Return = 0 BEGIN
				--Update the Matter
				UPDATE tblMatter SET
				MatterStatusCodeId = @MatterStatusCodeId,			
				MatterSubStatusId = @MatterSubStatusId,
				MatterStatusId = 3
				WHERE MatterId = @MatterId;

				IF not exists (SELECT 1 FROM tblAccount_DeliveryInfo WHERE MatterId = @MatterId) BEGIN
					INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState,
						DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail, PayableTo, AttentionTo, DeliveryFee, DeliveryMethod)
					SELECT @MatterId, c.Street + isnull(c.Street2,''), c.City, s.Abbreviation, c.ZipCode, 
							(select '('+isnull(hp.AreaCode,'')+')'+isnull(hp.Number,'') FROM tblPhone hp inner join tblPersonPhone pp on pp.PhoneId = hp.PhoneId and pp.PersonId = c.PersonId where hp.PhoneTypeId = 27 ), 
							(select '('+isnull(fp.AreaCode,'')+')'+isnull(fp.Number,'') FROM tblPhone fp inner join tblPersonPhone pp on pp.PhoneId = fp.PhoneId and pp.PersonId = c.PersonId where fp.PhoneTypeId = 29 ), 
							EmailAddress, @PayableTo, (c.FirstName + ' ' + c.LastName), @DeliveryFee, @DeliveryMethod
					FROM tblPerson c 
					left join tblState s ON s.StateId = c.StateId 
					WHERE c.ClientId = @ClientId and c.Relationship = 'Prime'
				END
				ELSE BEGIN
					UPDATE tblAccount_DeliveryInfo SET
						PayableTo = @PayableTo,
						AttentionTo = @ClientName,
						DeliveryFee = @DeliveryFee,
						DeliveryMethod = @DeliveryMethod
					WHERE MatterId = @MatterId;
				END

				INSERT INTO tblCancellationReasonSummary(MatterId, CancellationSubReasonId, Comment, AgencyName,
						AttorneyName, AttorneyAddress, AttorneyCity, AttorneyState, AttorneyZipCode, AttorneyPhone, AttorneyEmail)
				VALUES(@MatterId, @CancellationSubReasonId, @FieldComment, @AgencyName, @AttorneyName, @Street, @City,
						@State, @ZipCode, @PhoneNumber, @Email)

				IF not @AccountsRefunded is null BEGIN
					EXEC @Return = stp_InsertCancellationRefund @MatterId, @AccountsRefunded, @CreatedBy;

					IF @Return <> 0 SET @Return = -3;
				END

				IF @Return = 0 BEGIN
					SET @Note = 'A cancellation survey for '+ @ClientName + '  completed by ' + @UserName ;
					EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, @TaskId, @Note,null,null, null,null,null;
					IF @Return <> 0 SET @Return = -5;

					INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
					VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate())
				END

				IF @MatterSubStatusId = 67 BEGIN
					INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
					VALUES(@MatterId, dateadd(d,10, @MatterDate), @AvailSDA, 'Cancellation', @totalRefund , 
					@DeliveryMethod, getdate(), @CreatedBy, getdate(), @CreatedBy, 0)

					INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
					VALUES(@MatterId, 38, @CreatedBy, getdate())
				END
			
			END

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

