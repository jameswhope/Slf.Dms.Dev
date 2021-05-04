IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationInsertSettlement')
	BEGIN
		DROP  Procedure  stp_NegotiationInsertSettlement
	END

GO

CREATE Procedure stp_NegotiationInsertSettlement
@CreditorAccountID int,
@ClientID int,
@RegisterBalance money = Null,
@FrozenAmount money = Null,
@CreditorAccountBalance money = Null,
@SettlementPercent float,
@SettlementAmount money,
@SettlementAmtAvailable money = Null,
@SettlementAmtBeingSent money = Null,
@SettlementAmtStillOwed money = Null,
@SettlementDueDate datetime =  Null,
@SettlementSavings money = Null,
@SettlementFee money = Null,
@OvernightDeliveryAmount money = Null,
@SettlementCost money = Null,
@SettlementFeeAmtAvailable money = Null,
@SettlementFeeAmtBeingPaid money = Null,
@SettlementFeeAmtStillOwed money = Null,
@SettlementNotes varchar(max) = Null,
@Status  varchar(1) = Null,
@SettlementRegisterHoldID int = Null,
@OfferDirection varchar(50),
@SettlementSessionGuid uniqueidentifier = Null,
@SettlementFeeCredit money = Null,
@UserId int
AS
BEGIN
/*
	History
	
	06.02.08 opereira Created
*/
Insert Into tblSettlements(
CreditorAccountID, ClientID, RegisterBalance,
FrozenAmount, CreditorAccountBalance, SettlementPercent,
SettlementAmount, SettlementAmtAvailable, SettlementAmtBeingSent,
SettlementAmtStillOwed, SettlementDueDate, SettlementSavings,
SettlementFee, OvernightDeliveryAmount, SettlementCost,
SettlementFeeAmtAvailable, SettlementFeeAmtBeingPaid, SettlementFeeAmtStillOwed,
SettlementNotes, [Status], Created,
CreatedBy, LastModified, LastModifiedBy,
SettlementRegisterHoldID, OfferDirection, SettlementSessionGuid,
SettlementFeeCredit)
VALUES
(@CreditorAccountID, @ClientID, @RegisterBalance,
@FrozenAmount, @CreditorAccountBalance, @SettlementPercent,
@SettlementAmount, @SettlementAmtAvailable, @SettlementAmtBeingSent,
@SettlementAmtStillOwed, @SettlementDueDate, @SettlementSavings,
@SettlementFee, @OvernightDeliveryAmount, @SettlementCost,
@SettlementFeeAmtAvailable, @SettlementFeeAmtBeingPaid, @SettlementFeeAmtStillOwed,
@SettlementNotes, @Status, GetDate(),
@UserId, GetDate(), @UserId,
@SettlementRegisterHoldID, @OfferDirection, @SettlementSessionGuid,
@SettlementFeeCredit
)

SELECT Scope_Identity()

END
GO
