
alter procedure stp_GetNextDeposit
(
	@ClientID int
)
as
begin

declare @tblNextDeposits table (DepositType varchar(10), DepositDate datetime, DepositAmount money)
declare @bMulti bit


-- get multi deposit bit value
select @bMulti = MultiDeposit from tblclient where clientid = @clientid

IF @bMulti > 0
	BEGIN
		/*
		1 = Multi deposit client
		*/
		-- get this month's scheduled ach if it hasn't passed
		insert @tblNextDeposits
		select 'ach', dbo.udf_GetDepositDate(depositday,0), depositamount
		from tblClientDepositDay
		where depositday is not null
		and depositday > day(getdate())
		and clientid = @clientid

		-- get next month's scheduled ach
		insert @tblNextDeposits
		select 'ach', dbo.udf_GetDepositDate(depositday,1), depositamount
		from tblClientDepositDay
		where depositday is not null
		and clientid = @clientid

		-- get rules for this month
		insert @tblNextDeposits
		select 'rule', dbo.udf_GetDepositDate(depositday,0), depositamount
		from tblDepositRuleAch
		where startdate <= getdate()
		and enddate > dbo.udf_GetDepositDate(depositday,0)
		and ClientDepositId in(select clientdepositid from tblClientDepositDay	where clientid = @clientid) 

		-- get rules for next month
		insert @tblNextDeposits
		select 'rule', dbo.udf_GetDepositDate(depositday,1), depositamount
		from tblDepositRuleAch
		where startdate <= cast(month(getdate()) as varchar(2)) + '/1/' + cast(year(getdate()) as varchar(4))
		and enddate > dbo.udf_GetDepositDate(depositday,1)
		and ClientDepositId in(select clientdepositid from tblClientDepositDay	where clientid = @clientid)

	END
ELSE
	BEGIN
		/*
		0 = Non-multi deposit client
		*/

		-- get active adhocs
		insert @tblNextdeposits
		select 'adhoc', DepositDate, DepositAmount
		from tblAdHocACH 
		where DepositDate > GETDATE() 
		and clientid = @clientid

		-- get this month's scheduled ach if it hasn't passed
		insert @tblNextDeposits
		select 'ach', dbo.udf_GetDepositDate(depositday,0), depositamount
		from tblclient
		where depositday is not null
		and depositday > day(getdate())
		and clientid = @clientid

		-- get next month's scheduled ach
		insert @tblNextDeposits
		select 'ach', dbo.udf_GetDepositDate(depositday,1), depositamount
		from tblclient
		where depositday is not null
		and clientid = @clientid

		-- get rules for this month
		insert @tblNextDeposits
		select 'rule', dbo.udf_GetDepositDate(depositday,0), depositamount
		from tblruleach
		where startdate <= getdate()
		and enddate > dbo.udf_GetDepositDate(depositday,0)
		and clientid = @clientid

		-- get rules for next month
		insert @tblNextDeposits
		select 'rule', dbo.udf_GetDepositDate(depositday,1), depositamount
		from tblruleach
		where startdate <= cast(month(getdate()) as varchar(2)) + '/1/' + cast(year(getdate()) as varchar(4))
		and enddate > dbo.udf_GetDepositDate(depositday,1)
		and clientid = @clientid

	END;

-- rules replace scheduled ach deposits in a given month
delete 
from @tblNextDeposits
where deposittype = 'ach' 
and month(depositdate) in (select month(depositdate) from @tblNextDeposits where deposittype = 'rule')
and year(depositdate) in (select year(depositdate) from @tblNextDeposits where deposittype = 'rule')

-- return the next deposit info
select top 1 DepositType, DepositDate [NextDepositDate], DepositAmount [NextDepositAmount]
from @tblNextDeposits
where depositdate > getdate()
order by depositdate

end
go