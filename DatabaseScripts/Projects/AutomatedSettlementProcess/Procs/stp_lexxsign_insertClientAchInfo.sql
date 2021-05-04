IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_insertClientAchInfo')
	BEGIN
		DROP  Procedure  stp_lexxsign_insertClientAchInfo
	END

GO

CREATE Procedure stp_lexxsign_insertClientAchInfo

	(
		@ClientID int
		,@DepositDate datetime
		,@DepositAmount money
		,@BankName varchar(50)
		,@BankRoutingNumber varchar(50)
		,@BankAccountNumber varchar(50)
		,@BankType varchar(1)
		,@BankAccountId int
		,@Userid int
	)

AS
BEGIN
INSERT INTO [tblAdHocACH]([ClientID],[DepositDate],[DepositAmount],[BankName],[BankRoutingNumber],[BankAccountNumber],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[BankType],[InitialDraftYN],[BankAccountId])
VALUES(@ClientID,@DepositDate,@DepositAmount,@BankName,@BankRoutingNumber,@BankAccountNumber,getdate(),@Userid,getdate(),@Userid,@BankType,0,@BankAccountId)

END

GO


GRANT EXEC ON stp_lexxsign_insertClientAchInfo TO PUBLIC

GO


