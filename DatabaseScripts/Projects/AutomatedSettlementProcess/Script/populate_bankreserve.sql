

-- get pending settlements
SELECT   
	s.SettlementID,
	s.clientid
into #temp
FROM (
	SELECT     SettlementID
	FROM         dbo.tblNegotiationRoadmap
	GROUP BY SettlementID
	having MAX(SettlementStatusID) = 5
) nr INNER JOIN
	tblSettlements AS s with(nolock)  ON s.SettlementID = nr.SettlementID and s.active = 1 INNER JOIN
	tblAccount AS a with(nolock)  ON a.AccountID = s.CreditorAccountID INNER JOIN
	tblCreditorInstance AS ci with(nolock)  ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
	tblCreditor AS c with(nolock)  ON c.CreditorID = ci.CreditorID
where s.bankreserve is null


declare @SDABalance money, @PFOBalance money, @BankReserve money, @AvailSDA money, @MinBankReserve money, @MonthlyFee money,
	@settlementid int, @clientid int

create table #monthlyfee (amount money)
create table #balances (totaldeposits money, totalwithdrawls money, sdabalance money, pfobalance money)

declare cur cursor for select settlementid, clientid from #temp
open cur
fetch next from cur into @settlementid, @clientid
while @@fetch_status = 0 begin

	insert #monthlyfee exec stp_GetMonthlyFee @ClientId
	insert #balances exec stp_GetRegisterBalance @ClientId

	select @MonthlyFee = amount from #monthlyfee
	select @SDABalance = sdabalance, @PFOBalance = pfobalance from #balances
	select @MinBankReserve = cast([value] as money) from tblproperty where name = 'MinBankReserve'

	if (@MonthlyFee < @MinBankReserve) begin
		set @BankReserve = @MinBankReserve
	end
	else begin
		set @BankReserve = @MonthlyFee
	end

	set @AvailSDA = @SDABalance - @BankReserve

	update tblsettlements
	set sdabalance = @SDABalance, bankreserve = @bankreserve, pfobalance = @pfobalance, availsda = @availsda
	where settlementid = @settlementid
	
	truncate table #balances
	truncate table #monthlyfee

	fetch next from cur into @settlementid, @clientid
end

close cur
deallocate cur

drop table #temp
drop table #monthlyfee
drop table #balances

 