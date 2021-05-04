 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_AutoGenerateMatters')
	BEGIN
		DROP  Procedure  stp_NonDeposit_AutoGenerateMatters
	END

GO

create procedure stp_NonDeposit_AutoGenerateMatters
(
	@date datetime,
	@daysallowed int 
)
as
BEGIN

declare @t table(clientid int, depositdate datetime, depositamount money, deptype varchar(50))

--First Deposits not scheduled as adhocs. Expecting checks
Insert into @t(clientid, depositdate, depositamount, deptype)
select  c.clientid, @date, c.initialdraftamount, 'initial check'
from tblclient c
where c.currentclientstatusid not in (15,17,18,22)
and c.clientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
and c.clientId not in (Select a.clientid from tbladhocach a where a.clientid = c.clientid and isnull(a.InitialDraftYN,0) = 1)
and c.initialdraftdate is not null
and convert(varchar(10),c.initialdraftdate,101) = convert(varchar(10),@date,101)
and isnull(c.initialdraftamount,0) > 0

--MULTI DEPOSIT. Expected Checks (No rules yet)
Insert into @t(clientid, depositdate, depositamount, deptype)
select c.clientid, @date, d.depositamount, 'multideposit by check'
from tblclientdepositday d  
inner join tblclient c on c.clientid = d.clientid
where c.multideposit = 1
and c.currentclientstatusid not in (15, 17, 18, 22)
and isnull(c.depositstartdate, cast('1900-01-01' as datetime)) < @date 
and d.depositmethod <> 'ach'
and d.deleteddate is null
and d.depositday = day(@date)

--Single Deposit. Expected Checks (No rules yet)
Insert into @t(clientid, depositdate, depositamount, deptype)
select c.clientid, @date, c.depositamount, 'single deposit by check'
from tblclient c  
where c.multideposit = 0
and c.currentclientstatusid not in (15, 17, 18, 22)
and isnull(c.depositstartdate, cast('1900-01-01' as datetime)) < @date 
and c.depositmethod is not null and c.depositmethod <> 'ach'
and c.depositday is not null and c.depositday = day(@date)

--REPORT
Declare cursor_nondeposit Cursor For
select distinct t1.clientid, t1.depositamount 
from (
select t.*,
lastdepositdate = (select top 1 r.transactiondate from tblregister r where r.clientid = t.clientid and r.bounce is null and r.void is null and  r.entrytypeid = 3 and r.created <= @date order by r.transactiondate desc),
lastdepositamount = (select top 1 r.amount from tblregister r where r.clientid = t.clientid and r.bounce is null and r.void is null and  r.entrytypeid = 3 and r.created <= @date order by r.transactiondate desc) 
from @t t) t1
where isnull(datediff(d, t1.lastdepositdate, @date), 1000) > @daysallowed

declare @clientid int
declare @depositamount money

Open cursor_nondeposit
Fetch next from cursor_nondeposit into @clientid, @depositamount

While @@Fetch_Status = 0
Begin
--Create matter
	if not exists(select nondepositid from tblnondeposit where clientid = @clientid and nondeposittypeid = 1 and  misseddate = @date )
		begin
			exec stp_NonDeposit_CreateMatter @clientId, 32, 1, @date, @depositamount, null, null, null
		end
Fetch next from cursor_nondeposit into @clientid, @depositamount
End

Close cursor_nondeposit
Deallocate cursor_nondeposit

END