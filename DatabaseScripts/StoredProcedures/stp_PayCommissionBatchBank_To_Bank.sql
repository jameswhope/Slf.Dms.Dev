IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PayCommissionBatchBank_To_Bank')
	BEGIN
		DROP  Procedure  stp_PayCommissionBatchBank_To_Bank
	END

GO

CREATE Procedure stp_PayCommissionBatchBank_To_Bank
(
	@date1 datetime = '01/01/1950',
	@date2 datetime = '01/01/1950',
	@companyid int = 4
)
as
begin

/*Testing stuff1*/
--DECLARE @date1 DATETIME
--DECLARE @date2 DATETIME
--DECLARE @companyid INT
--SET @date1 = '06/26/2013' -- '01/01/1950'
--SET @date2 = GETDATE()
--SET @Companyid = 4
/*End of testing stuff1*/

IF @date1 = '01/01/1950'
	BEGIN
		SET @date1 = CAST(GETDATE() AS VARCHAR(12)) + ' 12:01 AM'
		SET @date2 = CAST(GETDATE() AS VARCHAR(12)) + ' 11:59 PM'
	END
ELSE
	BEGIN
		SET @date1 = CAST(@date1 AS VARCHAR(12)) + ' 12:01 AM'
		SET @date2 = CAST(@date2 AS VARCHAR(12)) + ' 11:59 PM'
	END

declare @nr table (commrecid int, amount money, amountwithheld money, originalamount money);

DECLARE @Amount NUMERIC(18, 2)

DECLARE @WithholdingAccountNo VARCHAR(50)
DECLARE @WithholdingRoutingNo VARCHAR(50)
DECLARE @WithholdingName VARCHAR(50)
SELECT @WithholdingAccountNo = AccountNumber, @WithholdingRoutingNo = RoutingNumber, @WithholdingName = Display FROM tblCommRec WHERE Abbreviation like 'Lexxiom WH'

DECLARE @SeidemanOAAccountNo VARCHAR(50)
DECLARE @SeidemanOARoutingNo VARCHAR(50)
DECLARE @SeidemanOAName VARCHAR(50)
SELECT @SeidemanOAAccountNo = AccountNumber, @SeidemanOARoutingNo = RoutingNumber, @SeidemanOAName = Display FROM tblCommRec WHERE Abbreviation like 'TSLF OA' 

DECLARE @Lexxiom2OAName VARCHAR(50)
DECLARE @Lexxiom2OARoutingNo VARCHAR(50)
DECLARE @Lexxiom2OAAccountNo VARCHAR(50)
SELECT @Lexxiom2OAAccountNo = AccountNumber, @Lexxiom2OARoutingNo = RoutingNumber, @Lexxiom2OAName = Display FROM tblCommRec WHERE Abbreviation like 'Lexxiom2' 

DECLARE @LexxiomOAName VARCHAR(50)
DECLARE @LexxiomOARoutingNo VARCHAR(50)
DECLARE @LexxiomOAAccountNo VARCHAR(50)
SELECT TOP 1 @LexxiomOAAccountNo = AccountNumber, @LexxiomOARoutingNo = RoutingNumber, @LexxiomOAName = Display FROM tblCommRec WHERE Abbreviation like 'Lexxiom' 

DECLARE @LexxiomMktOAName VARCHAR(50)
DECLARE @LexxiomMktOARoutingNo VARCHAR(50)
DECLARE @LexxiomMktOAAccountNo VARCHAR(50)
SELECT @LexxiomMktOAAccountNo = AccountNumber, @LexxiomMktOARoutingNo = RoutingNumber, @LexxiomMktOAName = Display FROM tblCommRec WHERE Abbreviation like 'Lexxiom2Mkt' 

if (@companyid > 2) begin
	insert @nr
	select commrecid, sum(amount) [amount], sum(amountwithheld) [amountwithheld], sum(originalamount) [originalamount]
	from tblnacharegister2 nr
	left join tblnachafile f on f.nachafileid = nr.nachafileid
	where ((nr.nachafileid = -1 and nr.created > @date1) or (f.date between @date1 and @date2))
	and companyid = @companyid
	and commrecid > 0
	and accountnumber <> @WithholdingAccountNo
	group by commrecid
end
else begin
	insert @nr
	select r.commrecid, sum(amount) [amount], sum(amountwithheld) [amountwithheld], sum(originalamount) [originalamount]
	from tblnacharegister nr
	join tblcommrec r on r.display = nr.name
	left join tblnachafile f on f.nachafileid = nr.nachafileid
	where ((nr.nachafileid is null and nr.created > @date1) or (f.date between @date1 and @date2))
	and nr.companyid = @companyid
	and nr.commrecid in (11,20) -- gca's
	and amount > 0
	and nr.accountnumber <> @WithholdingAccountNo
	group by r.commrecid
end

select cbt.commrecid, cbt.parentcommrecid, r.abbreviation [commrec],
	isnull(nr.amount,sum(cbt.transferamount)) [gross],
	sum(cbt.amount) - isnull(nr.amountwithheld,0) [net],
	cr.istrust,
	cr.isgca,
	-1 [seq]
into #temp2
from tblcommbatchtransfer cbt
join tblcommbatch cb on cb.commbatchid = cbt.commbatchid
	and cb.batchdate between @date1 and @date2
join tblcommrec r on r.commrecid = cbt.commrecid	
join tblcommrec cr on cr.commrecid = cbt.parentcommrecid	
left join @nr nr on nr.commrecid = cbt.commrecid and cr.isgca = 1
where cbt.companyid = @companyid
group by cbt.commrecid, cbt.parentcommrecid, r.abbreviation, nr.amount, nr.amountwithheld, cr.istrust, cr.isgca

declare @commrecid int, @parentcommrecid int, @isgca bit, @seq int;

set @seq = 0;

declare cur cursor for
	select commrecid, parentcommrecid, isgca
	from #temp2
	where istrust = 0
	order by isgca desc, commrec

open cur
fetch next from cur into @commrecid, @parentcommrecid, @isgca
while @@fetch_status = 0 begin

	if (@isgca = 1) begin
		set @seq = @seq + 10;
	end
	else begin
		-- has a parent other than gca
		select @seq=seq + 1
		from #temp2
		where commrecid = @parentcommrecid
	end
	
	update #temp2
	set Seq = @Seq
	where commrecid = @commrecid
	and parentcommrecid = @parentcommrecid

	fetch next from cur into @commrecid, @parentcommrecid, @isgca
end

close cur
deallocate cur

/*DATABASE INSERT IS BELOW*/

--Find Seideman to Inland community bank transfer Lexxiom2 or CommRec = 50
--This inserts the amount in tblNachaRegister to move money from Seideman OA (BB&T) to Lexxiom OA (Inland Community Bank)
--The values for commrecid 50 are constant so......................................there must be two inserts one debit and one credit
IF EXISTS(SELECT * FROM #temp2 WHERE commrecid in (50))
	BEGIN
	--Get the amount to process
		SELECT @Amount = sum(Gross) FROM #temp2 WHERE commrecid in (50)
		PRINT 'Inserting $' + CAST(@Amount AS VARCHAR(12)) + ' into tblNachaRegister for Lexxiom2 transaction fees to transfer from Seideman OA to Lexxiom OA.'
	--Insert the Lexxiom2 side a positive number
		INSERT INTO tblNachaRegister (	Name
			, AccountNumber
			, RoutingNumber
			, [Type]
			, Amount
			, IsPersonal
			, CommrecID
			, IsDeclined
			, CompanyID
			, Created
			)
		VALUES (@LexxiomOAName
			,@LexxiomOAAccountNo
			,@LexxiomOARoutingNo
			,'C'
			,@Amount
			,0
			,50
			,0
			,1
			,GETDATE()
			)
	--Insert the Seideman side a negative number
	INSERT INTO tblNachaRegister (Name
			, AccountNumber
			, RoutingNumber
			, [Type]
			, Amount
			, IsPersonal
			, CommrecID
			, IsDeclined
			, CompanyID
			, Created
			)
		VALUES (
			@SeidemanOAName
			,@SeidemanOAAccountNo
			,@SeidemanOARoutingNo
			,'C'
			,@Amount * -1
			,0
			,50
			,0
			,1
			,GETDATE()
			)
	END
ELSE
	BEGIN
		PRINT 'There are no transactions for Lexxiom2 today.'
	END
	
--Find Seideman to Inland community bank transfer Lexxiom2/Stonewall2 or CommRec = 52
--This inserts the amount in tblNachaRegister to move money from Seideman OA (BB&T) to Lexxiom OA (Inland Community Bank)
--The values for commrecid 52 are constant so......................................there must be two inserts one debit and one credit
IF EXISTS(SELECT * FROM #temp2 WHERE commrecid in (44))
	BEGIN
	--Get the amount to process
		SELECT @Amount = sum(Gross) FROM #temp2 WHERE commrecid in (44)
		PRINT 'Inserting $' + CAST(@Amount AS VARCHAR(12)) + ' into tblNachaRegister for Lexxiom2 transaction fees from Stonewall2 transactions to transfer from Seideman OA to Lexxiom OA.'
	--Insert the Lexxiom2 (LexPmtSys) side a positive number put the transaction into Lexxiom2 transfers
		INSERT INTO tblNachaRegister (	Name
			, AccountNumber
			, RoutingNumber
			, [Type]
			, Amount
			, IsPersonal
			, CommrecID
			, IsDeclined
			, CompanyID
			, Created
			)
		VALUES (@Lexxiom2OAName
			,@Lexxiom2OAAccountNo
			,@Lexxiom2OARoutingNo
			,'C'
			,@Amount
			,0
			,52
			,0
			,1
			,GETDATE()
			)
	--Insert the Seideman side a negative number
	INSERT INTO tblNachaRegister (Name
			, AccountNumber
			, RoutingNumber
			, [Type]
			, Amount
			, IsPersonal
			, CommrecID
			, IsDeclined
			, CompanyID
			, Created
			)
		VALUES (
			@SeidemanOAName
			,@SeidemanOAAccountNo
			,@SeidemanOARoutingNo
			,'C'
			,@Amount * -1
			,0
			,52
			,0
			,1
			,GETDATE()
			)
	END
--Find Seideman to Inland community bank transfer Lexxiom2/Stonewall2 or CommRec = 54 - The Marketing money
--This inserts the amount in tblNachaRegister to move money from Seideman OA (BB&T) to Lexxiom2Mkt OA (America West Bank)
--The values for commrecid 54 are constant so......................................there must be two inserts one debit and one credit
IF EXISTS(SELECT * FROM #temp2 WHERE commrecid in (54))
	BEGIN
	--Get the amount to process
		SELECT @Amount = sum(Gross) FROM #temp2 WHERE commrecid in (54)
		PRINT 'Inserting $' + CAST(@Amount AS VARCHAR(12)) + ' into tblNachaRegister for Lexxiom2Mkt (Marketing) transaction fees from Stonewall2 transactions to transfer from Seideman OA to Lexxiom2Mkt OA.'
	--Insert the Lexxiom2Mkt (Lexxiom Marketing) side a positive number put the transaction into Lexxiom2 transfers
		INSERT INTO tblNachaRegister (	Name
			, AccountNumber
			, RoutingNumber
			, [Type]
			, Amount
			, IsPersonal
			, CommrecID
			, IsDeclined
			, CompanyID
			, Created
			)
		VALUES (@LexxiomMktOAName
			,@LexxiomMktOAAccountNo
			,@LexxiomMKtOARoutingNo
			,'C'
			,@Amount
			,0
			,54
			,0
			,1
			,GETDATE()
			)
	--Insert the Seideman side a negative number
	INSERT INTO tblNachaRegister (Name
			, AccountNumber
			, RoutingNumber
			, [Type]
			, Amount
			, IsPersonal
			, CommrecID
			, IsDeclined
			, CompanyID
			, Created
			)
		VALUES (
			@SeidemanOAName
			,@SeidemanOAAccountNo
			,@SeidemanOARoutingNo
			,'C'
			,@Amount * -1
			,0
			,54
			,0
			,1
			,GETDATE()
			)
	END
ELSE
	BEGIN
		PRINT 'There are no transactions for Lexxiom2Mkt (Marketing Money) and Stonewall2 today.'
	END

--select * from #temp2
drop table #temp2

end
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

