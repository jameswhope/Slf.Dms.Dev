 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_ActivateOnePayment')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_ActivateOnePayment
	END

GO

CREATE Procedure stp_PaymentArrangement_ActivateOnePayment
@PmtScheduleId int,
@SettlementId int,
@PmtDate datetime,
@PmtAmount money,
@Note varchar(max),
@CreatedBy int
AS
Begin
declare @Return int,
		@MatterId int,
	    @MatterStatusCodeId int,
	    @MatterStatusId int,
	    @MatterSubStatusId int,
	    @Active bit,
	    @IsDeleted bit,
	    @IsResolved bit,
	    @AutoNote varchar(max),
		@ClientId int,
		@AccountId int,
		@AvailSDA money,
		@CheckAmount money,
		@DeliveryAmount money,
		@DeliveryMethod varchar(3),
		@PaymentProcessingId int

Select @Return = 0,
	   @MatterStatusCodeId = 38,
	   @MatterStatusId = 3,
	   @MatterSubStatusId = 67,
	   @Active = 1,
	   @IsDeleted = 0,
	   @IsResolved = 1
	   
--Get Settlement Info
SELECT  @MatterId = s.MatterId, 
		@ClientId = s.ClientId, 
		@AccountId = s.CreditorAccountId, 
		@AvailSDA = isnull(c.AvailableSDA, c.SDABalance),  
		@DeliveryAmount = s.DeliveryAmount,
		@DeliveryMethod = (CASE WHEN s.DeliveryMethod = 'chkbytel' THEN 'P' WHEN s.DeliveryMethod = 'chkbyemail' THEN 'E' ELSE 'C' END)
		FROM tblSettlements s
		join tblclient c on c.clientid = s.clientid
		WHERE s.SettlementId = @SettlementId;
		
Select @AutoNote = (SELECT 'A scheduled payment has been activated for client '+ p.FirstName + ' ' + p.LastName + ' to creditor ' + cr.[Name] + ' #' + SUBSTRING(ci.AccountNumber, len(ci.AccountNumber) - 3, 4) + ' for $' + Convert(varchar(10),@PmtAmount) + ' with available balance of  ' + isnull(Convert(varchar(10),@AvailSDA),'NA') + '. The payment is due on ' + convert(varchar(10), @PmtDate, 101)
					from tblSettlements s
					inner join tblClient c On c.ClientId = s.ClientId
					inner join tblPerson p On p.PersonId = c.PrimaryPersonId
					inner join tblAccount a On a.AccountId = s.CreditorAccountId
					inner join tblCreditorInstance ci On ci.CreditorInstanceId = a.CurrentCreditorInstanceId
					inner join tblCreditor cr  On cr.CreditorId = ci.CreditorId 
					where SettlementId = @SettlementId)

--Insert the Settlement Roadmap
INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
	VALUES(@SettlementId, @MatterStatusCodeId, null, @CreatedBy, getdate())
	
EXEC @Return = stp_ResolveSettlementMatter @SettlementId, @Note, @AutoNote, @CreatedBy, @ClientId, null, @AccountId,
				null, null, null, null, null, @MatterStatusCodeId, @MatterStatusId, @MatterSubStatusId, @IsDeleted, @Active,@IsResolved;

IF @Return = 0
BEGIN
    Select @CheckAmount = (CASE WHEN (@DeliveryMethod = 'P' and @DeliveryAmount <> 15) THEN (@PmtAmount + @DeliveryAmount) ELSE @PmtAmount END);

	INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
		VALUES(@MatterId, @PmtDate, @AvailSDA, 'Settlement - P.A.', @CheckAmount, @DeliveryMethod, getdate(), @CreatedBy, getdate(), @CreatedBy, 0)
		
	Select @PaymentProcessingId = scope_identity() 

	Update tblPaymentSchedule Set PaymentProcessingId = @PaymentProcessingId Where PmtScheduleId = @PmtScheduleId
END
ELSE
	RAISERROR('First scheduled payment of arrangement not found  ',16,1)
	
End

GO


