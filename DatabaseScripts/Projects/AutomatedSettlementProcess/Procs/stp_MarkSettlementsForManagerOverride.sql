IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MarkSettlementsForManagerOverride')
	BEGIN
		DROP  Procedure  stp_MarkSettlementsForManagerOverride
	END

GO

CREATE Procedure [dbo].[stp_MarkSettlementsForManagerOverride]
(
@UserId INT,
@ModifiedMatters XML OUTPUT
)
AS
BEGIN
	DECLARE @InTran BIT,
			@Note VARCHAR(max),
			@Today DATETIME,
			@UserName VARCHAR(50),
			@MatterStatusCodeId INT,
			@MatterSubStatusId INT;

	SET @InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END);
	SET @Today = getdate();
	SET @UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @UserId)
	SET @MatterStatusCodeId = (SELECT MatterStatusCodeId FROM tblMatterStatusCode WHERE MatterStatusCode = 'Pending Accounting Approval');
	SET @MatterStatusCodeId = (SELECT MatterSubStatusId FROM tblMatterSubStatus WHERE MatterSubStatus = 'Pending Accounting Approval');
	
	DECLARE @SettlementsForVerifyComplete TABLE(
													MatterId INT,
													SettlementId INT,
													ClientId INT,
													PaymentAmount MONEY
											    );
	
	IF @InTran = 0 BEGIN TRANSACTION;
	BEGIN TRY
		/**
			Select all settlements that are already marked as waiting on manager approval to check
			if there are any deposits in the client account and if SettlementAmt <= Available Balance. Mark them
			back to Verification complete so that next task can be assigned
		**/		
		INSERT INTO @SettlementsForVerifyComplete(MatterId, SettlementId, ClientId, PaymentAmount)
		SELECT s.MatterId, s.SettlementId, s.ClientId, s.SettlementAmount
		FROM tblSettlements s 
		inner join tblClient c ON c.ClientId = s.ClientId and (c.SDABalance - isnull(s.BankReserve, 0)) >= s.SettlementAmount
		inner join tblMatter m ON m.MatterId = s.MatterId AND (m.MatterStatusCodeId = 27 or m.MatterStatusCodeId = 33) 
		inner join tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1
		WHERE s.MatterId is not null 
		and isnull(s.IsPaymentArrangement,0) = 0 
	
		INSERT INTO @SettlementsForVerifyComplete(MatterId, SettlementId, ClientId, PaymentAmount)
		SELECT s.MatterId, s.SettlementId, s.ClientId, v.pmtamount
		FROM tblSettlements s 
		inner join vw_paymentschedule_ordered v on v.settlementid = s.settlementid and v.[order] = 1 
		inner join tblClient c ON c.ClientId = s.ClientId and (c.SDABalance - isnull(s.BankReserve, 0) >= v.pmtAmount)
		inner join tblMatter m ON m.MatterId = s.MatterId AND (m.MatterStatusCodeId = 27 or m.MatterStatusCodeId = 33) 
		inner join tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1
		WHERE s.MatterId is not null 
		and isnull(s.IsPaymentArrangement,0) = 1 
	
	
		UPDATE tblMatter SET MatterStatusCodeId = @MatterStatusCodeId
							 , MatterStatusId = 3
							 , MatterSubStatusId = 54
		FROM tblMatter m 
		WHERE MatterId IN (SELECT MatterId FROM @SettlementsForVerifyComplete)

		INSERT INTO tblAccount_PaymentProcessing(MatterId, AvailableSDA, DueDate, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed)
		SELECT s.MatterId, s.AvailSDA, s.SettlementDueDate, 'Settlement',
		(CASE 
			WHEN (s.DeliveryMethod = 'chkbytel' and s.DeliveryAmount <> 15) THEN (tm.paymentamount + s.DeliveryAmount)
			ELSE tm.paymentamount
		END) AS CheckAmount, 
		(CASE 
			WHEN s.DeliveryMethod = 'chkbytel' THEN 'P' 
			WHEN s.DeliveryMethod = 'chkbyemail' THEN 'E' 
			ELSE 'C'  -- chk
		END) AS DeliveryMethod,
		 @Today, @UserId, @Today, @UserId, 0
		FROM @SettlementsForVerifyComplete tm inner join
		tblSettlements s ON s.MatterId = tm.MatterId

		SET @Note = @UserName + ' has changed the status of settlement matter to Pending Payment Processing From waiting on Manager''s Approval
					as the client now has funds in his account.'	;

		INSERT INTO tblNote([Value], ClientId, Created, CreatedBy, LastModified, LastModifiedBy)
		SELECT @Note, ClientId, @Today, @UserId, @Today, @UserId
		FROM @SettlementsForVerifyComplete		
		
		INSERT INTO tblNoteRelation(NoteId, RelationTypeId, RelationId)		
		SELECT n.NoteId, 19, tm.MatterId
		FROM @SettlementsForVerifyComplete tm inner join
		tblMatter m ON m.MatterId = tm.MatterId	inner join
		tblClient c ON c.ClientId = m.ClientId left join
		tblNote	n ON n.ClientId = c.ClientId AND
		n.[Value] = @Note and n.CreatedBy = @UserId and n.Created = @Today 
		and n.LastModified = @Today and n.LastModifiedBy = @UserId and n.[Subject] is null 

		INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created)
		SELECT tm.SettlementId, @MatterStatusCodeId, n.NoteId, @UserId, @Today
		FROM @SettlementsForVerifyComplete tm inner join
		tblClient c ON c.ClientId = tm.ClientId left join
		tblNote	n ON n.ClientId = c.ClientId AND
		n.[Value] = @Note and n.CreatedBy = @UserId and n.Created = @Today 
		and n.LastModified = @Today and n.LastModifiedBy = @UserId and n.[Subject] is null 

		SET @ModifiedMatters = (SELECT MatterId "@id" FROM @SettlementsForVerifyComplete FOR XML PATH('Matter'))

		DELETE @SettlementsForVerifyComplete;
		
		IF @InTran = 0 COMMIT
	END TRY
	BEGIN CATCH
		IF @InTran = 0 ROLLBACK
	END CATCH	
			
END

GO


