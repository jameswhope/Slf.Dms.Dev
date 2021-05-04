IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ReportGetCommissionBatchPaymentsSummary_new')
	BEGIN
		DROP  Procedure  stp_ReportGetCommissionBatchPaymentsSummary_new
	END

GO

CREATE Procedure stp_ReportGetCommissionBatchPaymentsSummary_new
(
	@date1 datetime,
	@date2 datetime,
	@companyid int
)
as
begin

declare @nr table (commrecid int, amount money, amountwithheld money, originalamount money);

DECLARE @WithholdingAccountNo VARCHAR(50)
DECLARE @WithholdingRoutingNo VARCHAR(50)
DECLARE @WithholdingName VARCHAR(50)
SELECT @WithholdingAccountNo = AccountNumber, @WithholdingRoutingNo = RoutingNumber, @WithholdingName = Display FROM tblCommRec WHERE Abbreviation like 'Lexxiom WH'

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


select * from #temp2
order by seq

--select * from @nr

drop table #temp2


end

GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

