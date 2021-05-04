IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetMultipleAchforDate')
	BEGIN
		DROP  Procedure  stp_GetMultipleAchforDate
	END

GO

CREATE Procedure stp_GetMultipleAchforDate
@startDate datetime = null,
@days int = null
AS
Begin
--if start date is empty. Get Today's date
if @startDate is null Set @startDate = GetDate()

Set @startDate = Cast( convert(varchar, @startDate, 101) as DateTime)

--if start date is weekend or bank holiday. Get the previous collection date
While DateName(dw, @startDate) in ('Saturday', 'Sunday') or Exists(Select bankholidayid From tblBankHoliday Where Date = @startDate)
Begin
	Set @startDate = DateAdd(d, -1, @startDate)
End

--Create Report Table
Declare @reportDate datetime 
set @reportDate = GetDate()
--Create Collection Day table
Declare @collectionday table (ReportDate datetime, CollectionDate datetime, ScheduledDate datetime)
--if days is null or <= zero then use default days = 1
if (isnull(@days, 0) <= 0) Set @days = 1

Declare @dayCount int
Set @dayCount = 0
Declare @date datetime
Set @date = @startDate
Declare @colldate datetime 
--Set @colldate = @startDate

--fill the collection days
While @dayCount <= @days 
begin
	if DateName(dw, @date) not in ('Saturday', 'Sunday') and not Exists(Select bankholidayid From tblBankHoliday Where [Date] = @date)
	begin
		Set @colldate = @date
		Set @dayCount = @dayCount + 1
	end
	if @dayCount > @days BREAK
	--insert date	
	set @date = DateAdd(d,1, @date)
	Insert Into @collectionday(ReportDate, CollectionDate, ScheduledDate) Values (@reportDate, @colldate, @date)
end

--Create ClientDeposit Table
declare @deposits table (DepositId int identity(1,1) not null,
						 ClientId int,
						 ScheduledDate datetime,
						 DepositDay int,
						 Amount money,
						 ACHType varchar(50),
						 ACHId int,
						 MultiDepositClient bit,
						 RoutingNumber varchar(50),
						 BankAccountNumber varchar(50),
						 AdhocZeroDollarRule bit default 0)



declare @ScheduledDate datetime
--Select @ScheduledDate = @startdate
declare @lastDayofMonth bit

declare sched_days cursor for
select distinct ScheduledDate From @collectionday
order by ScheduledDate

Open sched_days

Fetch Next From sched_days Into @ScheduledDate

While @@FETCH_STATUS = 0
Begin
	Select @lastDayofMonth = Case When
		Day(@ScheduledDate) = 
		Day(DateAdd(d,-1, DateAdd(m,1,cast((convert(varchar,year(@ScheduledDate)) + '-' + convert(varchar,month(@ScheduledDate)) + '-' + '1') as datetime))))
		Then 1
		Else 0
	End

	--Insert ACH (single deposit)
	Insert Into @deposits(ClientId, ScheduledDate, DepositDay, Amount, ACHType, ACHId, MultiDepositClient, RoutingNumber, BankAccountNumber)
	SELECT
		c.ClientID,
		@ScheduledDate,
		c.DepositDay,
		c.DepositAmount,
		'ACH',
		c.clientId,
		c.MultiDeposit,
		c.BankRoutingNumber,
		c.BankAccountNumber
	FROM
		tblClient as c
	WHERE
		c.ClientID not in
		(	SELECT ClientID	FROM tblRuleACH
			WHERE StartDate <= @ScheduledDate and (EndDate is null or EndDate >= @ScheduledDate)
		) 
		and c.CurrentClientStatusID not in (15, 17, 18)
		and lower(c.DepositMethod) = 'ach'
		and	(c.DepositDay = day(@ScheduledDate) or (@lastdayofmonth = 1 and c.DepositDay >= day(@ScheduledDate)))
		and c.DepositStartDate is not null
		and c.DepositStartDate <= @ScheduledDate
		and c.DepositDay is not null
		and c.DepositDay > 0
		and c.MultiDeposit = 0
		--and c.clientid not in (SELECT clientid  FROM tblRegister WHERE ACHMonth = month(@ScheduledDate) and ACHYear = year(@ScheduledDate))
		
	--Insert ACH Rule(single deposit)
	Insert Into @deposits(ClientId, ScheduledDate, DepositDay, Amount, ACHType, AChId, MultiDepositClient, RoutingNumber, BankAccountNumber)
	SELECT
		c.ClientID,
		@ScheduledDate,
		r.DepositDay,
		r.DepositAmount,
		'ACH Rule',
		r.ruleachid,
		c.MultiDeposit,
		c.BankRoutingNumber,
		c.BankAccountNumber
	FROM
		tblRuleACH as r
		inner join tblClient as c on c.ClientID = r.ClientID
	WHERE
		r.RuleACHID in
		(SELECT
			min(RuleACHID)
		FROM
			tblRuleACH
		WHERE
			StartDate <= @ScheduledDate and	(EndDate is null or EndDate >= @ScheduledDate) 
			and	(r.DepositDay = day(@ScheduledDate) or (@lastdayofmonth = 1	and r.DepositDay >= day(@ScheduledDate)))
		GROUP BY
			ClientID
		)
	and c.CurrentClientStatusID not in (15, 17, 18)
	and lower(c.DepositMethod) = 'ach'
	and c.DepositStartDate <= @ScheduledDate
	and c.DepositStartDate is not null
	and c.DepositDay is not null
	and c.DepositDay > 0
	and c.MultiDeposit = 0
	--and c.clientid not in (SELECT clientid  FROM tblRegister WHERE ACHMonth = month(@ScheduledDate) and ACHYear = year(@ScheduledDate))

	--Insert ACH (MultiDeposit)
	Insert Into @deposits(ClientId, ScheduledDate, DepositDay, Amount, ACHType, AchId, MultiDepositClient, RoutingNumber, BankAccountNumber)
	SELECT
		c.ClientID,
		@ScheduledDate,
		d.DepositDay,
		d.DepositAmount,
		'ACH',
		d.ClientDepositId,
		c.MultiDeposit,
		ltrim(rtrim(b.RoutingNumber)),
		ltrim(rtrim(b.AccountNumber))
	FROM
		tblClient as c
		inner join tblClientDepositDay d on d.ClientID = c.ClientID
		left join tblClientBankAccount b on b.BankAccountID = d.BankAccountID
	WHERE
		d.ClientDepositID not in  
		(SELECT
				ClientDepositID
			FROM
				tblDepositRuleACH
			WHERE
				StartDate <= @ScheduledDate and	(EndDate is null or EndDate >= @ScheduledDate)
		) 
		and c.CurrentClientStatusID not in (15, 17, 18)
		and lower(d.DepositMethod) = 'ach'
		and	(d.DepositDay = day(@ScheduledDate) or (@lastdayofmonth = 1	and d.DepositDay >= day(@ScheduledDate)))
		and c.DepositStartDate is not null
		and c.DepositStartDate <= @ScheduledDate
		and c.MultiDeposit = 1
		and lower(d.Frequency) = 'month'
		and d.DeletedDate is null
		--and c.clientid not in (SELECT clientid  FROM tblRegister WHERE ACHMonth = month(@ScheduledDate) and ACHYear = year(@ScheduledDate))

	--Insert ACH Rule (MultiDeposit)
	Insert Into @deposits(ClientId, ScheduledDate, DepositDay, Amount, ACHType, AchId, MultiDepositClient, RoutingNumber, BankAccountNumber)
	SELECT
		c.ClientID,
		@ScheduledDate,
		r.DepositDay,
		r.DepositAmount,
		'ACH Rule',
		r.RuleAchId,
		c.MultiDeposit,
		ltrim(rtrim(b.RoutingNumber)),
		ltrim(rtrim(b.AccountNumber))
	FROM
		tblDepositRuleACH as r
		inner join tblClientDepositDay d on d.ClientDepositID = r.ClientDepositID
		left join tblClientBankAccount b on b.BankAccountID = r.BankAccountID
		inner join tblClient as c on c.ClientID = d.ClientID
	WHERE
		StartDate <= @ScheduledDate and	(EndDate is null or EndDate >= @ScheduledDate) 
		and	(r.DepositDay = day(@ScheduledDate) or (@lastdayofmonth = 1 and r.DepositDay >= day(@ScheduledDate)))
		and c.DepositStartDate <= @ScheduledDate
		and c.DepositStartDate is not null
		and c.CurrentClientStatusID not in (15, 17, 18)
		and c.MultiDeposit = 1
		and lower(d.Frequency) = 'month'
		and d.DeletedDate is null
		--and c.clientid not in (SELECT clientid  FROM tblRegister WHERE ACHMonth = month(@ScheduledDate) and ACHYear = year(@ScheduledDate))


	--Insert AdHoc
	Insert Into @deposits(ClientId, ScheduledDate, DepositDay, Amount, ACHType, AchId, MultiDepositClient, RoutingNumber, BankAccountNumber)
		SELECT
			a.ClientID,
			@ScheduledDate,
			day(@ScheduledDate),
			abs(a.DepositAmount),
			'Additional ACH',
			a.adhocachid,
			c.MultiDeposit,
			ltrim(rtrim(a.BankRoutingNumber)),
			ltrim(rtrim(a.BankAccountNumber))
		FROM
			tblAdHocACH as a
			inner join tblClient as c on c.ClientID = a.ClientID
		WHERE
			c.CurrentClientStatusID not in (15, 17, 18)
			and a.DepositDate = @ScheduledDate

	--Flag AdHocs if zero dollar rules
	Update @deposits Set
	AdhocZeroDollarRule = 1
	Where ACHType = 'Additional ACH'
	and MultiDepositClient = 0
	and ClientId in
	(select clientid from tblruleach 
	where depositamount = 0 
	and StartDate <= @ScheduledDate and	(EndDate is null or EndDate >= @ScheduledDate))

	Update @deposits Set
	AdhocZeroDollarRule = 1
	Where ACHType = 'Additional ACH'
	and MultiDepositClient = 1
	and ClientId in (select d.clientid from tbldepositruleach  r
					 inner join tblclientdepositday d on r.clientdepositid = d.clientdepositid
					 where r.depositamount = 0 
					 and r.StartDate <= @ScheduledDate and (r.EndDate is null or r.EndDate >= @ScheduledDate)
					 and d.deleteddate is null)

	Fetch Next From sched_days Into @ScheduledDate

End
Close sched_days
Deallocate sched_days

--Report Table

--Deposits Table
select * from @deposits

--Clients Table
Select Distinct c.Clientid, c.AccountNumber, p.FirstName + ' ' + p.LastName as ClientName, m.ShortCoName as SA, t.DisplayName as Trust, c.MultiDeposit As MultiDepositClient, @reportdate As ReportDate
from @deposits tmp --#t
inner join tblclient c on c.clientid = tmp.clientid
left join tblperson p on c.clientid = p.clientid and p.relationship = 'prime'
inner join tblcompany m on c.companyid = m.companyid
inner join tbltrust t on c.trustid = t.trustid
order by 3


Select Distinct ReportDate from @CollectionDay

--Table Collection Dates
Select Distinct ReportDate, CollectionDate from @CollectionDay
Order By CollectionDate

--Table Scheduled Dates
select c.ScheduledDate, c.CollectionDate, d.ProcBankDate,  b.[Name] as Holiday  from @collectionday c
inner join 
(Select Max(ScheduledDate) as ProcBankDate, CollectionDate from @collectionday group by CollectionDate) d on d.CollectionDate = c.CollectionDate
left join tblBankHoliday b on b.[Date] = c.ScheduledDate

--Exclude Items
delete from @deposits 
from @deposits d
inner join tblachwarning w 
on d.AchId = w.ItemId 
and d.AchType = w.ItemType 
and d.MultiDepositClient = w.MultiDeposit 
and d.ScheduledDate = w.Scheduled 

--Get clients with many achs in date range
Select  d.*, l.collectiondate
into #t
from @deposits d 
inner join @collectionday l on d.scheduleddate = l.scheduleddate 
left join
(Select d.clientid from @deposits d 
inner join @collectionday y on d.scheduleddate = y.scheduleddate
left join tblAchWarning w on d.AchId = w.ItemId and d.AchTYpe = w.ItemType and d.MultiDepositClient = w.MultiDeposit and d.ScheduledDate = w.Scheduled 
where d.amount > 0
and w.warningid is null
group by d.clientid 
having count(d.clientid) > 1) f on f.clientid = d.clientid
where (f.clientid is not null or d.AdhocZeroDollarRule = 1)
and d.amount > 0
order by d.clientid, l.collectiondate

--ACH Table
select * from #t

/*
select c.*, d.ProcBankDate, b.[Name] as Holiday  from @collectionday c
inner join 
(Select Max(ScheduledDate) as ProcBankDate, CollectionDate from @collectionday group by CollectionDate) d on d.CollectionDate = c.CollectionDate
left join tblBankHoliday b on b.[Date] = c.ScheduledDate


Select c.Clientid, c.AccountNumber, l.collectiondate, p.FirstName + ' ' + p.LastName as ClientName, m.ShortCoName as SA, t.DisplayName as Trust, d.* from @deposits d 
inner join tblclient c on c.clientid = d.clientid
left join tblperson p on c.clientid = p.clientid and p.relationship = 'prime'
inner join tblcompany m on c.companyid = m.companyid
inner join tbltrust t on c.trustid = t.trustid
inner join @collectionday l on d.scheduleddate = l.scheduleddate 
left join
(Select d.clientid from @deposits d --, c.collectiondate 
inner join @collectionday y on d.scheduleddate = y.scheduleddate 
where d.amount > 0
group by d.clientid --,c.collectiondate
having count(d.clientid) > 1) f on f.clientid = d.clientid
where (f.clientid is not null or d.AdhocZeroDollarRule = 1)
and d.amount > 0
order by f.clientid, l.collectiondate
*/

drop table #t

End

GO

