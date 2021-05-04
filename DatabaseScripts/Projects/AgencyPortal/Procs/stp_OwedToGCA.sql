
create procedure stp_OwedToGCA
as
begin
-- extract from stp_IssueCommBatch

declare @vtblBatches table
(
	ID int identity(1,1),
	CompanyID int,
	TrustID int,
	CommScenID int,
	CommRecID int,
	ParentCommRecID int null,
	[Order] int,
	Amount money
)

declare @vtblComms table
(
	CompanyID int,
	TrustID int,
	ID int,
	[Type] varchar(14),
	CommScenID int,
	CommRecID int,
	ParentCommRecID int,
	[Order] int,
	Amount money
)

--create table tblOwedtoGCA
--(
--	Recipient varchar(50),
--	SEIDEMAN money default(0),
--	PALMER money default(0),
--	INIGUEZ money default(0),
--	MOSSLER money default(0),
--	PEAVEY money default(0),
--	BARKER money default(0),
--	RunDate datetime default(getdate())
--)

truncate table tblOwedtoGCA

declare @companyid int, @shortconame varchar(50), @recipient varchar(50), @parent varchar(50), @amount money


INSERT INTO
	@vtblComms
SELECT
	CompanyID,
	TrustID,
	ID,
	[Type],
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	Amount
FROM
(
	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
		cp.CommPayID as ID,
		'CommPay' as [Type],
		cs.CommScenID,
		cs.CommRecID,
		cs.ParentCommRecID,
		cs.[Order],
		cp.Amount
	FROM
		tblCommPay as cp
		inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
		inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cp.CommBatchID is null

	UNION ALL

	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
		cc.CommChargebackID as ID,
		'CommChargeback' as [Type],
		cs.CommScenID,
		cs.CommRecID,
		cs.ParentCommRecID,
		cs.[Order],
		-cc.Amount
	FROM
		tblCommChargeback as cc
		inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
		inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblCommStruct as cs on cs.CommStructID = cc.CommStructID
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cc.CommBatchID is null
) as drvComms



INSERT INTO
	@vtblBatches
SELECT
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	sum(Amount) as Amount
FROM
	@vtblComms
GROUP BY
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order]


--who owes what
declare cur cursor for
SELECT
	--TrustID,
	c.companyid,
	c.shortconame,
	cr.display [recipient],
	p.display [parent],
	sum(Amount) as Amount
FROM
	@vtblBatches b
join tblcompany c on c.companyid = b.companyid
join tblcommrec cr on cr.commrecid = b.commrecid
join tblcommrec p on p.commrecid = b.parentcommrecid and p.isgca = 1
where
	amount < 0
--and b.commrecid = 29
--and b.companyid = 6
GROUP BY
	c.shortconame,
	--TrustID,
	cr.display,
	p.display,
	c.companyid
order by [recipient], c.companyid

open cur
fetch next from cur into @companyid,@shortconame,@recipient,@parent,@amount
while @@fetch_status = 0 begin
	if not exists (select 1 from tblOwedtoGCA where recipient = @recipient) begin
		exec('insert tblOwedtoGCA (recipient,' + @shortconame + ') values (''' + @recipient + ''',' + @amount + ')')
	end
	else begin
		exec('update tblOwedtoGCA set ' + @shortconame + ' = ' + @amount + ' where recipient = ''' + @recipient + '''')
	end

	fetch next from cur into @companyid,@shortconame,@recipient,@parent,@amount
end

close cur
deallocate cur


select recipient [Due From], seideman [Due To Seideman GCA], palmer [Due to Palmer GCA], iniguez [Due to Iniguez GCA],
	mossler [Due to Mossler GCA], peavey [Due to Peavey GCA], barker [Due to Barker GCA],
	seideman+palmer+iniguez+mossler+peavey+barker [Totals]
from tblOwedtoGCA
order by [totals]


end
go 