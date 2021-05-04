IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertDepositRuleCheck')
	BEGIN
		DROP  Procedure  stp_NonDeposit_InsertDepositRuleCheck
	END

GO

CREATE Procedure stp_NonDeposit_InsertDepositRuleCheck
@StartDate datetime,
@EndDate datetime,
@DepositDay int,
@DepositAmount money,
@CreatedBy int,
@LastModifiedBy int,
@ClientId int
as
BEGIN
	INSERT INTO  tblRuleCheck([StartDate],[EndDate],[DepositDay],[DepositAmount],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[ClientId])
	VALUES (@StartDate,@EndDate,@DepositDay,@DepositAmount, getdate(),@CreatedBy,getdate(),@LastModifiedBy,@ClientId)
	
	Select Scope_identity()
END