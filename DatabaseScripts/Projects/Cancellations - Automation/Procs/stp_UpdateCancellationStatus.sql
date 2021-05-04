IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateCancellationStatus')
	BEGIN
		DROP  Procedure  stp_UpdateCancellationStatus
	END

GO

CREATE Procedure [dbo].[stp_UpdateCancellationStatus]
(
	@MatterId int,
	@CreatedBy int
)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DECLARE @Return INT
			,@ClientId INT
			,@InTran BIT
			,@Note VARCHAR(MAX)
			,@MatterSubStatusId INT
			,@PrevMatterSubStatusId INT
			,@MatterStatusCodeId INT			
			,@MatterStatusId INT
			,@UserName VARCHAR(50)
			,@ClientName VARCHAR(100)
			,@IsRequestPresent INT
			,@IsFeeOwed BIT
			,@ClientAgreedToPay BIT
			,@IsMatterPresent BIT
			,@DueDate DATETIME
			,@MatterDate DATETIME
			,@PFOBalance MONEY
			,@AvailSDA MONEY
			,@TotalRefund MONEY
			,@PrevMatterSubStatus VARCHAR(50)
			,@MatterSubStatus VARCHAR(50)
			,@DeliveryMethod VARCHAR(5)
			,@ReasonId INT;

	SELECT @ClientId = m.ClientId, @DueDate = dateadd(d,10,m.MatterDate), @MatterDate = m.MatterDate,
	@PrevMatterSubStatusId = m.MatterSubStatusId, @PrevMatterSubStatus = ms.MatterSubStatus
    FROM tblMatter m inner join tblMatterSubStatus ms ON ms.MatterSubStatusId = m.MatterSubStatusId
    WHERE MatterId = @MatterId;

	SELECT @IsFeeOwed = IsFeeOwed, 
			@ClientAgreedToPay = ClientAgreedToPay FROM tblCancellation WHERE MatterId = @MatterId;
			
	SELECT @DeliveryMethod = DeliveryMethod
	FROM tblAccount_DeliveryInfo WHERE MatterId = @MatterId;

	SELECT @IsMatterPresent = (CASE WHEN 
								(SELECT count(*) FROM tblMatter WHERE ClientId = @ClientId and MatterId <> @MatterId
								and isDeleted = 0 and MatterStatusId not in (2,4)) > 0  THEN 1 ELSE 0 END);

	
	SELECT @Return = 0, @MatterSubStatusId = 0, @IsRequestPresent = 0
	,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 1 ELSE 0 END)
	,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @CreatedBy)
	,@ClientName = (SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
	,@ReasonId = (SELECT CancellationSubReasonId FROM tblCancellationReasonSummary WHERE MatterId = @MatterId);
	
	SET @IsRequestPresent = (SELECT (CASE 
									WHEN (SELECT count(*) FROM tblDocRelation WHERE ClientId = @ClientId and 
										RelatedDate > @MatterDate and DeletedFlag = 0 and DocTypeId = 'D8019SCAN') = 0 AND 
										(@ReasonId = 32 or @ReasonId = 15 or @ReasonId = 16 or @ReasonId =17) THEN 1 
									WHEN (SELECT count(*) FROM tblDocRelation WHERE ClientId = @ClientId and 
										RelatedDate > @MatterDate and DeletedFlag = 0 and DocTypeId = '9028') = 0 AND 
										@ReasonId = 30 THEN 2 
									WHEN (SELECT count(*) FROM tblDocRelation WHERE ClientId = @ClientId and 
										RelatedDate > @MatterDate and DeletedFlag = 0 and DocTypeId = '9037') = 0 THEN 3
									ELSE 0 
								END));
	
	SELECT @AvailSDA = AvailableSDA, @PFOBalance = PFOBalance FROM tblClient WHERE ClientId = @ClientId;

	IF 	@PrevMatterSubStatus = 'Pending Matter Resolution' OR @PrevMatterSubStatus = 'Pending Receipt of Cancellation Request' 
		OR @PrevMatterSubStatus = 'Pending Fee Recovery' OR @PrevMatterSubStatus = 'Waiting on Bankruptcy Document' OR @PrevMatterSubStatus = 'Waiting on Death Certificate' BEGIN
		SELECT @MatterSubStatusId = (CASE
										WHEN @IsMatterPresent = 1 THEN (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Matter Resolution' )
										WHEN @IsFeeOwed = 1 and @ClientAgreedToPay = 1 and @PFOBalance > 0 THEN (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Fee Recovery' )
										WHEN @IsRequestPresent = 1 THEN (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Waiting on Bankruptcy Document' )
										WHEN @IsRequestPresent = 2 THEN (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Waiting on Death Certificate' )
										WHEN @IsRequestPresent = 3 THEN (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Receipt of Cancellation Request'  )
										ELSE 67
									END);
	END

	SELECT @MatterStatusId = MatterStatusId, @MatterSubStatus = MatterSubStatus 
	FROM tblMatterSubStatus WHERE MatterSubStatusId = @MatterSubStatusId;

	SELECT @MatterStatusCodeId = (CASE
										WHEN @MatterSubStatus = 'Pending Survey' THEN 44
										WHEN @MatterSubStatus = 'RC' THEN 45
										WHEN @MatterSubStatus = 'Survey Completed' THEN 47
										WHEN @MatterSubStatus = 'Pending Matter Resolution' THEN 48
										WHEN @MatterSubStatus = 'Pending Receipt of Cancellation Request' THEN 49
										WHEN @MatterSubStatus = 'ClientRequest Received'  THEN 50
										WHEN @MatterSubStatus = 'Pending Fee Recovery' THEN 46
										WHEN @MatterSubStatus = 'Waiting on Bankruptcy Document' THEN 51
										WHEN @MatterSubStatus = 'Waiting on Death Certificate' THEN 52
										ELSE 38
									END);
	
	SET @TotalRefund = (SELECT (isnull(c.SDABalance, 0) - isnull(c.PFOBalance, 0) - 15 - dbo.udf_FundsOnHold(c.ClientID,0) + isnull(sum(abs(r.Amount)),0)) FROM
						tblCancellation cl inner join tblClient c ON c.ClientId = cl.ClientId left join
						tblCancellation_RefundInfo cr ON cr.MatterId = cl.MatterId left join
						tblRegister r ON r.RegisterId = cr.RegisterId where cl.MatterId = @MatterId
						GROUP BY c.SDABalance, c.PFOBalance, c.ClientId);
						
	SELECT @Note = @UserName + ' updated the status of the cancellation matter for client ' + @ClientName + ' from ' + @PrevMatterSubStatus + ' to ' + @MatterSubStatus

	IF @ClientId is null SET @Return = -2;

	IF @Return = 0 and @MatterSubStatusId <> 0 BEGIN
		IF @InTran = 1 BEGIN TRANSACTION;
		BEGIN TRY		

			--Update the Matter
			UPDATE tblMatter SET
			MatterStatusCodeId = @MatterStatusCodeId,			
			MatterSubStatusId = @MatterSubStatusId,
			MatterStatusId = @MatterStatusId
			WHERE MatterId = @MatterId;
				
			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId, null,@CreatedBy, null, @Note,null,null, null,null,null;
			
			IF not exists (select 1 from tblCancellationRoadmap where MatterStatusCodeId = @MatterStatusCodeId and MatterId = @MatterId) BEGIN
				--add roadmap for status changed to
				INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
				VALUES(@MatterId, @MatterStatusCodeId, @CreatedBy, getdate())
				
			END
			
			UPDATE tblCancellation SET TotalRefund = (case when @TotalRefund < 0 Then 0 Else @TotalRefund End) WHERE MatterId = @MatterId;

			IF @MatterSubStatusId = 67 BEGIN
				INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
				VALUES(@MatterId, @DueDate, @AvailSDA, 'Cancellation', (case when @TotalRefund < 0 Then 0 Else @TotalRefund End), @DeliveryMethod, getdate(), @CreatedBy, getdate(), @CreatedBy, 0)

				INSERT INTO tblCancellationRoadmap(MatterId, MatterStatusCodeId, CreatedBy, Created)
				VALUES(@MatterId, 38, @CreatedBy, getdate())
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



