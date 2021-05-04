IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getMultiDepositRuleOverlaps')
	BEGIN
		DROP  Procedure  stp_getMultiDepositRuleOverlaps
	END

GO

create procedure [dbo].[stp_getMultiDepositRuleOverlaps]
(
	@NewRuleStartDate datetime,
	@NewRuleEndDate datetime,
	@ClientDepositID int,
	@ExcludeRuleId int = Null
)
as
BEGIN
	declare @ssql varchar(max)
	set @ssql = 'SELECT dr.RuleACHId, ba.AccountNumber AS BankAccountNumber, ba.RoutingNumber AS BankRoutingNumber, '
	set @ssql = @ssql + 'rn.CustomerName AS BankName, dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate, '
	set @ssql = @ssql + 'ba.BankType, dr.ClientDepositID, ba.BankAccountId '
	set @ssql = @ssql + 'FROM tblDepositRuleAch AS dr INNER JOIN tblClientBankAccount AS ba ON dr.BankAccountID = ba.BankAccountId '
	set @ssql = @ssql + 'INNER JOIN tblRoutingNumber AS rn ON ba.RoutingNumber = rn.RoutingNumber '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@NewRuleStartDate as varchar) + char(39) + ' between dr.startdate and dr.enddate '
	set @ssql = @ssql + 'and dr.ClientDepositID = ' + cast(@ClientDepositID as varchar) + ' and dr.RuleACHId <> ' + cast(isnull(@ExcludeRuleId, 0) as varchar)  
	set @ssql = @ssql + ' union '
	set @ssql = @ssql + 'SELECT dr.RuleACHId, ba.AccountNumber AS BankAccountNumber, ba.RoutingNumber AS BankRoutingNumber, '
	set @ssql = @ssql + 'rn.CustomerName AS BankName, dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate, '
	set @ssql = @ssql + 'ba.BankType, dr.ClientDepositID, ba.BankAccountId '
	set @ssql = @ssql + 'FROM tblDepositRuleAch AS dr INNER JOIN tblClientBankAccount AS ba ON dr.BankAccountID = ba.BankAccountId '
	set @ssql = @ssql + 'INNER JOIN tblRoutingNumber AS rn ON ba.RoutingNumber = rn.RoutingNumber '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@NewRuleEndDate as varchar) + char(39) + ' between dr.startdate and dr.enddate '
	set @ssql = @ssql + 'and dr.ClientDepositID = ' + cast(@ClientDepositID as varchar) + ' and dr.RuleACHId <> ' + cast(isnull(@ExcludeRuleId, 0) as varchar) 
	set @ssql = @ssql + ' union '
	set @ssql = @ssql + 'SELECT dr.RuleACHId, ba.AccountNumber AS BankAccountNumber, ba.RoutingNumber AS BankRoutingNumber, '
	set @ssql = @ssql + 'rn.CustomerName AS BankName, dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate, '
	set @ssql = @ssql + 'ba.BankType, dr.ClientDepositID, ba.BankAccountId '
	set @ssql = @ssql + 'FROM tblDepositRuleAch AS dr INNER JOIN tblClientBankAccount AS ba ON dr.BankAccountID = ba.BankAccountId '
	set @ssql = @ssql + 'INNER JOIN tblRoutingNumber AS rn ON ba.RoutingNumber = rn.RoutingNumber '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@NewRuleStartDate as varchar) + char(39) + ' <= dr.startdate '
	set @ssql = @ssql + 'and ' + char(39) + cast(@NewRuleEndDate as varchar) + char(39) + ' >= dr.enddate '
	set @ssql = @ssql + 'and dr.ClientDepositID = ' + cast(@ClientDepositID as varchar) + ' and dr.RuleACHId <> ' + cast(isnull(@ExcludeRuleId, 0) as varchar)  
	exec(@ssql)

END



GRANT EXEC ON stp_getMultiDepositRuleOverlaps TO PUBLIC


