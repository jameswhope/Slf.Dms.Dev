IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertMultiDepositRule')
	BEGIN
		DROP  Procedure  stp_InsertMultiDepositRule
	END

GO

create procedure [dbo].[stp_InsertMultiDepositRule]
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
	INSERT INTO [tblDepositRuleAch]([StartDate],[EndDate],[DepositDay],[DepositAmount],[BankAccountID],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[ClientDepositId], [OldRuleID], [Locked])
	VALUES (@StartDate,@EndDate,@DepositDay,@DepositAmount,@BankAccountID,getdate(),@CreatedBy,getdate(),@LastModifiedBy,@ClientDepositId, @OldRuleID, @Locked)
END


GRANT EXEC ON stp_InsertMultiDepositRule TO PUBLIC




