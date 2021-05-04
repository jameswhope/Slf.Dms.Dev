IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateSettlementCalculations')
	BEGIN
		DROP  Procedure  stp_UpdateSettlementCalculations
	END

GO

CREATE Procedure [dbo].[stp_UpdateSettlementCalculations]
(	
	@SettlementId int,	
	@CreatedBy int,
	@DeliveryMethod varchar(25),
	@DeliveryAmount money,
	@AdjustedFee money
)

AS
BEGIN

	DECLARE @Return INT
			,@SettCost money
			,@SettFeeCredit money
			,@SettFeeAvail money
			,@SettFeePaid money
			,@SettFeeOwed money
			,@RegisterBalance money
			,@SDABAlance money
			,@SettAmount money
			,@SettFee money
			,@AvailSDA money
			,@RemainingBal money
			,@OvernightFees money
			,@OriginalAdjustedFee money;
			
	SELECT @Return = 0;
	
	Select @DeliveryMethod = case when @DeliveryMethod = 'check' then 'chk'
								  when @DeliveryMethod = 'c' then 'chk'
								  when @DeliveryMethod = 'p' then 'chkbytel'
								  when @DeliveryMethod = 'check by phone' then 'chkbytel'
								  when @DeliveryMethod = 'check by email' then 'chkbyemail'
							      else @DeliveryMethod
							 end
		   
	SELECT  @SettFeeCredit = abs(SettlementFeeCredit), 			
			@SettAmount = SettlementAmount, @OriginalAdjustedFee = AdjustedSettlementFee,
			@SettFee = SettlementFee, @OvernightFees = OvernightDeliveryAmount,
			@RegisterBalance = RegisterBalance, @AvailSDA = AvailSDA, @SDABalance = SDABalance
	FROM tblSettlements WHERE SettlementId = @SettlementId;

	-- Rule: If the adjustment and credit total more than the fee only charge the delivery amount. Settlement cost
	-- should never be negative. (rare)
	if abs(@AdjustedFee) + @SettFeeCredit > @SettFee begin
		SET @SettCost = @DeliveryAmount
	end
	else begin
		SET @SettCost = @SettFee + @AdjustedFee + @DeliveryAmount - @SettFeeCredit
	end
		
	SET @RemainingBal = @RegisterBalance - @SettAmount

	IF @RemainingBal >= @SettCost BEGIN
		SELECT @SettFeeAvail = @SettCost, @SettFeePaid = @SettCost, @SettFeeOwed = 0
	END
	ELSE BEGIN
		SELECT @SettFeeAvail = @RemainingBal;
		IF @RemainingBal > 0 BEGIN
			SELECT @SettFeePaid = @RemainingBal, @SettFeeOwed = @SettCost - @RemainingBal;
		END
		ELSE BEGIN
			SELECT @SettFeePaid = 0, @SettFeeOwed = @SettCost;
		END
	END		

	IF @DeliveryMethod <> 'chk' and @DeliveryAmount <> 15 BEGIN
		SET @OvernightFees = 0;
	END
	
	IF @Return = 0 BEGIN
		BEGIN TRY		
					
			UPDATE tblSettlements SET
					DeliveryMethod = @DeliveryMethod,
					OvernightDeliveryAmount = @OvernightFees,
					AdjustedSettlementFee = @AdjustedFee,
					DeliveryAmount = @DeliveryAmount,
					SettlementCost = @SettCost,
					SettlementFeeAmtAvailable = @SettFeeAvail,
					SettlementFeeAmtBeingPaid = @SettFeePaid,
					SettlementFeeAmtStillOwed = @SettFeeOwed,
					LastModified = getdate(),
					LastModifiedBy = @CreatedBy
				WHERE SettlementId = @SettlementId

			IF @OriginalAdjustedFee <> @AdjustedFee BEGIN
				UPDATE tblSettlementTrackerImports
					SET SettlementFees = @SettFee + @AdjustedFee,
						LastModified = getdate(),
						LastModifiedBy = @CreatedBy
					WHERE SettlementId =@SettlementId;
			END
		END TRY
		BEGIN CATCH
			SET @Return = -1;
		END CATCH
	END
	RETURN @Return
END
GO