IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertMultiDepositRuleCheck')
	BEGIN
		DROP  Procedure  stp_NonDeposit_InsertMultiDepositRuleCheck
	END

GO

CREATE Procedure stp_NonDeposit_InsertMultiDepositRuleCheck
(
@StartDate datetime,
@EndDate datetime,
@DepositDay int,
@DepositAmount money,
@BankAccountID int,
@CreatedBy int,
@LastModifiedBy int,
@ClientDepositId int,
@OldRuleID int = 0,
@Locked bit = 0
)
as
BEGIN
	INSERT INTO  tblDepositRuleCheck([StartDate],[EndDate],[DepositDay],[DepositAmount],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[ClientDepositId], [OldRuleID], [Locked])
	VALUES (@StartDate,@EndDate,@DepositDay,@DepositAmount, getdate(),@CreatedBy,getdate(),@LastModifiedBy,@ClientDepositId, @OldRuleID, @Locked)
	
	Select Scope_identity()
END



GO

 

