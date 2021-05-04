IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_updateClientAchInfo')
	BEGIN
		DROP  Procedure  stp_lexxsign_updateClientAchInfo
	END

GO

CREATE Procedure stp_lexxsign_updateClientAchInfo

	(
		@DepositDate datetime
		,@DepositAmount money
		,@BankAccountId int
		,@AdHocAchID int
	)

AS
BEGIN

	declare @BankName varchar(500)
	declare @BankRoutingNumber varchar(9)
	declare @BankAccountNumber varchar(50)
	declare @BankType varchar(1)

	select @BankName =customername,@BankRoutingNumber =rn.routingnumber,@BankAccountNumber = cba.accountnumber,@BankType = cba.bankType
	from tblclientbankaccount cba inner join tblroutingnumber rn on rn.routingnumber = cba.routingnumber
	where bankaccountid = @BankAccountId


	UPDATE [tblAdHocACH]
	SET      [DepositDate] = @DepositDate
	  ,[DepositAmount] = @DepositAmount
	  ,[BankName] = @BankName
	  ,[BankRoutingNumber] = @BankRoutingNumber
	  ,[BankAccountNumber] = @BankAccountNumber
	  ,[LastModified] = getdate()
	  ,[LastModifiedBy] = 1481
	  ,[BankType] = @BankType
	  ,[BankAccountId] = @BankAccountId
	WHERE AdHocAchID = @AdHocAchID

END




GRANT EXEC ON stp_lexxsign_updateClientAchInfo TO PUBLIC




