IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ExpiredSettlements')
	BEGIN
		DROP  Procedure  stp_ExpiredSettlements
	END

GO

CREATE Procedure [dbo].[stp_ExpiredSettlements]
	(
		@GroupName nvarchar(150) = '',
		@RepName nvarchar(250) = ''
	)
AS
declare @Where nvarchar(1000)
declare @strSQL nvarchar(max)
declare @date varchar(50)

--Setup the dates for the weekends
IF datepart(dw, getdate()) = 2
	BEGIN
		SET @date = dateadd(day, -3, getdate())
	END

set @date = cast(datepart(month, @date) as varchar(3)) + '/' 
+ cast(datepart(day, @date) as varchar(3)) + '/' 
+ cast(datepart(year, @date) as varchar(5))

SET @Where = ''

IF @GroupName <> ''
	BEGIN
		SET @WHERE = 'WHERE NegotiationTeam LIKE ''%' + @GroupName + '%'''
	END
if @RepName <> ''
	BEGIN
		SET @WHERE = 'WHERE RepName LIKE ''%' + @RepName + '%'''
	END

declare @vtbl1 table 
(
SettlementID int,
ClientID int,
SettlementInstanceCreated datetime,
ClientAccountNo int,
ClientName nvarchar(150),
CurrentStatus nvarchar(150),
Creditor nvarchar(150),
AccountID int,
SettlementDueDate datetime,
CreditorAccountBalance money,
SettlementAmount money,
RepName nvarchar(150),
NegotiationTeam nvarchar(150),
Attorney nvarchar(150),
SDABal money
)

insert into @vtbl1

select s.settlementid,
c.ClientID,
s.lastmodified,
c.accountnumber,
p.firstname + ' ' + p.lastname [Client],
(select MatterStatusCodeDescr from tblmatterstatuscode where matterstatuscodeid = 23) [Status],
(SELECT top 1 c1.name FROM tblcreditor c1 JOIN tblcreditorinstance ci1 ON ci1.creditorid = c1.creditorid JOIN tblaccount a1 ON a1.accountid = ci1.accountid WHERE a1.accountid = s.CreditorAccountID ORDER BY ci1.created DESC) [Creditor],
s.creditoraccountid,
s.settlementduedate,
s.CreditorAccountBalance,
s.settlementamount,
u.firstname + ' ' + u.lastname [Rep Name],
ne2.Name [Negotitaion Team],
co.shortcoName,
c.SDABalance
from tblsettlements s
join tblclient c on c.clientid = s.clientid
join tblperson p on p.clientid = s.clientid and p.relationship = 'Prime'
join tbluser u on u.userid = s.createdby
join tblnegotiationentity ne on ne.userid = s.createdby
join tblnegotiationentity ne2 on ne2.Negotiationentityid = ne.Parentnegotiationentityid
join tblCompany co on co.companyid = c.companyid
left join tblmatter mt on mt.matterid = s.matterid
where s.settlementid in 
(select settlementid from tblsettlementroadmap where matterstatuscodeid = 23 OR matterstatuscodeid IS NULL)
and settlementduedate >= @date 
and settlementduedate <= dateadd(d, -1, getdate())
and mt.matterstatuscodeid <> 37

union

select s.settlementid,
c.ClientID,
s.lastmodified,
c.accountnumber,
p.firstname + ' ' + p.lastname [Client],
(select MatterStatusCodeDescr from tblmatterstatuscode where matterstatuscodeid = 23) [Status],
(SELECT top 1 c1.name FROM tblcreditor c1 JOIN tblcreditorinstance ci1 ON ci1.creditorid = c1.creditorid JOIN tblaccount a1 ON a1.accountid = ci1.accountid WHERE a1.accountid = s.CreditorAccountID ORDER BY ci1.created DESC) [Creditor],
s.creditoraccountid,
s.settlementduedate,
s.CreditorAccountBalance,
s.settlementamount,
u.firstname + ' ' + u.lastname [Rep Name],
ne2.Name [Negotitaion Team],
co.shortconame,
c.SDABalance
from tblsettlements s
join tblclient c on c.clientid = s.clientid
join tblperson p on p.clientid = s.clientid and p.relationship = 'Prime'
join tbluser u on u.userid = s.lastmodifiedby
join tblnegotiationentity ne on ne.userid = s.createdby
join tblnegotiationentity ne2 on ne2.Negotiationentityid = ne.Parentnegotiationentityid
join tblcompany co on co.companyid = c.companyid
left join tblmatter mt on mt.matterid = s.matterid
where s.settlementid in 
(select settlementid from tblsettlementroadmap where matterstatuscodeid = 23 or matterstatuscodeid is null)
and settlementduedate >= @date 
and settlementduedate <= dateadd(d, -1, getdate())
and s.safprinted is null
and mt.matterstatuscodeid <> 37

union

select 
sti.settlementID,
s.clientid,
sti.importdate,
sti.ClientAcctNumber,
sti.[name],
(select MatterStatusCodeDescr from tblmatterstatuscode where matterstatuscodeid = 23) [Status],
sti.CurrentCreditor,
s.creditoraccountid,
sti.Due,
sti.balance,
sti.settlementAmt,
sti.Negotiator,
ne2.Name [Negotation Team],
sti.LawFirm,
sti.FundsAvail
from tblsettlementtrackerimports sti
join tblsettlements s on s.settlementid = sti.SettlementID 
join tblnegotiationentity ne on ne.userid = s.createdby
join tblnegotiationentity ne2 on ne2.Negotiationentityid = ne.Parentnegotiationentityid
where sti.expired >= @date 
and settlementduedate <= dateadd(day, -1, getdate())
and sti.paid is null
and sti.canceldate is null

create table #vtbl2  
(
SettlementID int,
ClientID int,
SettlementInstanceCreated datetime,
ClientAccountNo int,
ClientName nvarchar(150),
CurrentStatus nvarchar(150),
Creditor nvarchar(150),
AccountID int,
SettlementDueDate datetime,
CreditorAccountBalance money,
SettlementAmount money,
RepName nvarchar(150),
NegotiationTeam nvarchar(150),
Attorney nvarchar(150),
SDABal money --,
--SAFPrinted bit
)

insert into #vtbl2
select * from @vtbl1 order by settlementid, settlementinstancecreated

declare @count int
declare @settlementid int
declare duplicate_cursor cursor fast_forward for
select settlementid, count(settlementid)as cnt
from #vtbl2
group by settlementid
having count(settlementid) > 1

open duplicate_cursor

fetch next from duplicate_cursor into @settlementid, @count

while @@fetch_status = 0
begin
	delete top (@count - 1) from #vtbl2 where settlementid = @settlementid

	fetch next from duplicate_cursor into @settlementid, @count
end

close duplicate_cursor
deallocate duplicate_cursor

select @strSQL = 'select SettlementID, 
	clientid, 
	SettlementDueDate, 
	Attorney, 
	ClientName, 
	Creditor, 
	accountID, 
	SettlementAmount, 
	SDABal, 
	RepName, 
	NegotiationTeam 
	from  #vtbl2 ' 
	set @strSQL = @strSQL + @WHERE 
	set @strSQL = @strSQL + ' order by NegotiationTeam, RepName'

exec(@strSQL)

drop table #vtbl2

