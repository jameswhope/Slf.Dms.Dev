/****** Object:  StoredProcedure [dbo].[stp_Statistic_Deposits]    Script Date: 11/19/2007 15:27:45 ******/
DROP PROCEDURE [dbo].[stp_Statistic_Deposits]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_Deposits]
(
	@date1 datetime,
	@date2 datetime,
	@companyid int = null,
	@agencyid int = null
)

as

select
	'Total Deposits' as statistic,
	count(*) as [count],
	isnull(sum(amount),0) as [value]
from
	tblregister r
join
	tblclient c on c.clientid = r.clientid
	and (@companyid is null or c.companyid = @companyid)
	and (@agencyid is null or c.agencyid = @agencyid)		
where
	transactiondate between @date1 and @date2
	and r.entrytypeid in (3,10)

union all

select
	'Bounced Deposits' as statistic,
	count(*) as [count],
	isnull(sum(amount),0) as [value]
from
	tblregister r
join
	tblclient c on c.clientid = r.clientid
	and (@companyid is null or c.companyid = @companyid)
	and (@agencyid is null or c.agencyid = @agencyid)	
where
	not r.bounce is null
	and transactiondate between @date1 and @date2
	and r.entrytypeid in (3,10)

union all

select
	'Voided Deposits' as statistic,
	count(*) as [count],
	isnull(sum(amount),0) as [value]
from
	tblregister r
join
	tblclient c on c.clientid = r.clientid
	and (@companyid is null or c.companyid = @companyid)
	and (@agencyid is null or c.agencyid = @agencyid)		
where
	not r.void is null
	and transactiondate between @date1 and @date2
	and r.entrytypeid in (3,10)

union all

select
	'Deposits On Hold' as statistic,
	count(*) as [count],
	isnull(sum(amount),0) as [value]
from
	tblregister r
join
	tblclient c on c.clientid = r.clientid
	and (@companyid is null or c.companyid = @companyid)
	and (@agencyid is null or c.agencyid = @agencyid)		
where
	not r.hold is null and (r.hold >= @date2 and not r.[clear] <= @date1)
	and transactiondate between @date1 and @date2
	and r.entrytypeid in (3,10)

union all

select
	'Valid Deposits' as statistic,
	count(*) as [count],
	isnull(sum(amount),0) as [value]
from
	tblregister r
join
	tblclient c on c.clientid = r.clientid
	and (@companyid is null or c.companyid = @companyid)
	and (@agencyid is null or c.agencyid = @agencyid)		
where
	r.bounce is null
	and r.void is null
	and transactiondate between @date1 and @date2
	and r.entrytypeid in (3,10)

union all

select
	'ACH''d Deposits' as statistic,
	count(*) as [count],
	isnull(sum(amount),0) as [value]
from
	tblregister r
join
	tblclient c on c.clientid = r.clientid
	and (@companyid is null or c.companyid = @companyid)
	and (@agencyid is null or c.agencyid = @agencyid)		
where
	not achyear is null
	and transactiondate between @date1 and @date2
	and r.entrytypeid in (3,10)
GO
