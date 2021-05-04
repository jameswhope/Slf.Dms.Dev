
alter procedure stp_GetBankTransfers
(
	@DateFrom datetime,
	@DateTo datetime,
	@FromCompanyID int,
	@ToCompanyID int
)
as
begin

declare @FromTrust varchar(255)

select @FromTrust = display from tblcommrec where companyid = @FromCompanyID and istrust = 1


select 
	a.dc [transfer_date], isnull(nr.amount,0) [transfer_amt], c.accountnumber, p.firstname, p.lastname
from 
	tblclient c 
join 
	tblaudit a on a.pk = c.clientid
	and a.auditcolumnid = 27
	and a.value = c.companyid
	and (a.dc between @DateFrom and @DateTo)
join 
	tblaudit orig on orig.pk = c.clientid
	and orig.auditcolumnid = 27
	and orig.value = @FromCompanyID	
join 
	tblperson p on p.personid = c.primarypersonid
left join 
	tblnacharegister2 nr on nr.clientid = c.clientid
	and nr.name = @FromTrust
where 
	c.companyid = @ToCompanyID
order by 
	[transfer_date]

end
go