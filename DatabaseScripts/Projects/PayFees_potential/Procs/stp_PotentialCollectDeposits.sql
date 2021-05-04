
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PotentialCollectDeposits')
	BEGIN
		DROP Procedure stp_PotentialCollectDeposits
	END
GO 

create procedure stp_PotentialCollectDeposits
(
	@fordate datetime
)
as
BEGIN
-- based off stp_CollectACHDeposits and stp_CollectAdHocACHDeposits
-- grabs ach and check deposits

set nocount on
set ansi_warnings off


insert tblpotentialregistertmp
(
	clientid,
	transactiondate,
	amount,
	entrytypeid,
	achmonth,
	achyear,
	fee,
	isfullypaid
)	
SELECT
	drvDeposits.ClientID,
	cast(convert(varchar(50), @fordate, 101) as datetime),
	abs(drvDeposits.DepositAmount),
	3,
	month(@fordate),
	year(@fordate),
	0,
	0
FROM
(
	SELECT
		c.ClientID,
		c.DepositAmount
	FROM
		tblClient as c
		inner join tblPerson as p on p.PersonID = c.PrimaryPersonID
		inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
	WHERE
		c.ClientID not in
		(
			SELECT
				ClientID
			FROM
				tblRuleACH
			WHERE
				StartDate <= cast(convert(varchar(10), @fordate, 101) as datetime) and
				(
					EndDate is null
					or EndDate >= cast(convert(varchar(10), @fordate, 101) as datetime)
				)
		) 
		and c.DepositDay = day(@fordate)
		and c.DepositStartDate <= cast(convert(varchar(10), @fordate, 101) as datetime)
		and c.CurrentClientStatusID not in (15, 17, 18)
		and (lower(c.DepositMethod) = 'ach' or lower(c.DepositMethod) = 'check')
		and c.DepositDay is not null
		and c.DepositDay > 0
		--and c.BankRoutingNumber is not null
		--and c.BankAccountNumber is not null
		--and len(c.BankRoutingNumber) > 0
		--and len(c.BankAccountNumber) > 0
		and c.DepositStartDate is not null

	UNION ALL

	SELECT
		c.ClientID,
		r.DepositAmount
	FROM
		tblRuleACH as r
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblPerson as p on PersonID = c.PrimaryPersonID
		inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
	WHERE
		r.RuleACHID in
		(
			SELECT
				min(RuleACHID)
			FROM
				tblRuleACH
			WHERE
				StartDate <= cast(convert(varchar(10), @fordate, 101) as datetime) and
				(
					EndDate is null
					or EndDate >= cast(convert(varchar(10), @fordate, 101) as datetime)
				) 
				and r.DepositDay = day(@fordate)
			GROUP BY
				ClientID
		)
		and c.DepositStartDate <= cast(convert(varchar(10), @fordate, 101) as datetime)
		and c.CurrentClientStatusID not in (15, 17, 18)
		and (lower(c.DepositMethod) = 'ach' or lower(c.DepositMethod) = 'check')
		and c.DepositDay is not null
		and c.DepositDay > 0
		--and c.BankRoutingNumber is not null
		--and c.BankAccountNumber is not null
		--and len(c.BankRoutingNumber) > 0
		--and len(c.BankAccountNumber) > 0
		and c.DepositStartDate is not null		
) as drvDeposits
where not exists (select 1 from tblpotentialregistertmp r where r.clientid = drvDeposits.clientid and r.achmonth = month(@fordate) and r.achyear = year(@fordate))



--adhocs
insert tblpotentialregistertmp
(
	clientid,
	transactiondate,
	amount,
	entrytypeid,
	fee,
	isfullypaid
)
SELECT
	a.ClientID,
	cast(convert(varchar(50), @fordate, 101) as datetime),
	abs(a.DepositAmount),
	3,
	0,
	0
FROM
	tblAdHocACH as a
	inner join tblClient as c on c.ClientID = a.ClientID
WHERE
	c.CurrentClientStatusID not in (15, 17, 18)
	and cast(convert(varchar(10), a.DepositDate, 101) as datetime) = cast(convert(varchar(10), @fordate, 101) as datetime)
	and a.RegisterID is null


declare @count int
select @count = count(*) from tblpotentialregistertmp where entrytypeid = 3 and transactiondate = @fordate
print cast(@count as varchar(5)) + ' deposits added'


END
go