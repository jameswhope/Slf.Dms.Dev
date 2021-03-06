/****** Object:  StoredProcedure [dbo].[stp_Statistic_ClientDeposit]    Script Date: 11/19/2007 15:27:44 ******/
DROP PROCEDURE [dbo].[stp_Statistic_ClientDeposit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_ClientDeposit]
(
	@datapoints int = 9,
	@agencyid int = null,
	@attorneyid int = null
)	 
as

declare @attorneystateid int
declare @attorneycompanyid int
--if not @attorneyid is null begin
--	set @attorneystateid=(select stateid from tblattorney where attorneyid=@attorneyid)
--	set @attorneycompanyid=(select companyid from tblattorney where attorneyid=@attorneyid)
--end


declare @crAgency varchar(255)
declare @crattorney varchar(255)
set @cragency=''
set @crattorney=''

if not @agencyid is null 
	set @cragency=' and c.agencyid=' + convert(varchar,@agencyid)

if not @attorneyid is null 
	set @crattorney=' and c.companyid=' + convert(varchar,@attorneycompanyid) + 
					' and p.stateid=' + convert(varchar,@attorneystateid)


set @datapoints=@datapoints-1

declare @datefield varchar (500)
declare @datefield2 varchar (500)

declare @field varchar(50)
set @field='r.transactiondate'
set @datefield = 'convert(datetime, convert(varchar(2), month(' + @field + ')) + N''/1/'' + convert(varchar(4), year(' + @field + ')))'


/*
Last deposit
*/

exec('

select top ' + @datapoints + '
	count(timeago) as [count],
	timeago as monthsago
from
(
	select
		datediff
		(
			month,
			'+@datefield+',
			getdate()
		) as timeago,
		('+@datefield+') as transactiondate,
		c.currentclientstatusid
	from
		tblregister r inner join
		(
			select
				nr.clientid,
				max(registerid) as registerid
			from
				tblregister nr inner join
				(
					select
						tblregister.clientid,
						max(transactiondate) as transactiondate
					from
						tblregister
					where
						(
							entrytypeid = 3 or
							entrytypeid = 10
						)
						and bounce is null and void is null
					group by
						tblregister.clientid
				)
				as nnr on nr.clientid = nnr.clientid and nr.transactiondate = nnr.transactiondate
			group by
				nr.clientid
		)
		nr on r.registerid = nr.registerid inner join
		tblclient c on r.clientid = c.clientid inner join
		tblperson p on c.primarypersonid=p.personid
	where
		1=1 ' + @cragency + @crattorney + '
) t
where
	timeago >= 0
	and timeago < 12
	and not currentclientstatusid in (15,16,17)
group by
	t.timeago,t.transactiondate

union

select 
	count(*) as [count],
	-1 as monthsago
from 
	tblclient c inner join
	tblperson p on c.primarypersonid=p.personid
where
	not c.clientid in 
		(select clientid from tblregister where
			bounce is null and void is null and entrytypeid in (3,10)
		)
	and not currentclientstatusid in (15,16,17)
	' + @cragency + @crattorney + '

')


/*
Deposit Consistency
*/
exec('

select top ' + @datapoints + '
	count(timeago) as [count],
	timeago as monthsago
from
(
	select
		datediff
		(
			month,
			'+@datefield+',
			getdate()
		) as timeago,
		('+@datefield+') as transactiondate,
		c.currentclientstatusid
	from
		tblregister r inner join
		(
			select
				nr.clientid,
				max(registerid) as registerid
			from
				tblregister nr inner join
				(
					select
						tblregister.clientid,
						max(transactiondate) as transactiondate
					from
						tblregister
					where
						(
							entrytypeid = 3 or
							entrytypeid = 10
						)
						and bounce is null and void is null
					group by
						tblregister.clientid
				)
				as nnr on nr.clientid = nnr.clientid and nr.transactiondate = nnr.transactiondate
			group by
				nr.clientid
		)
		nr on r.registerid = nr.registerid inner join
		tblclient c on r.clientid = c.clientid inner join
		tblperson p on c.primarypersonid=p.personid
	where 
		1=1	' + @cragency + @crattorney + '
) t
where
	timeago >= 0
	and timeago < 12
	and not currentclientstatusid in (15,16,17)
group by
	t.timeago,t.transactiondate

union

select 
	count(*) as [count],
	-1 as monthsago
from 
	tblclient c inner join
	tblperson p on c.primarypersonid=p.personid
where
	not c.clientid in 
		(select clientid from tblregister where
			bounce is null and void is null and entrytypeid in (3,10)
		)
	and not currentclientstatusid in (15,16,17)
	' + @cragency + @crattorney + '

')
GO
