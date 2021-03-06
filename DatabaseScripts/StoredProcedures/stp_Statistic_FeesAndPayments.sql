/****** Object:  StoredProcedure [dbo].[stp_Statistic_FeesAndPayments]    Script Date: 11/19/2007 15:27:45 ******/
DROP PROCEDURE [dbo].[stp_Statistic_FeesAndPayments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_FeesAndPayments]
(
	@date1 datetime,
	@date2 datetime,
	@companyid int = null,
	@agencyid int = null
)

as


select
	et.[name] as feetype,
	isnull(tblassessed.countassessed,0) as countassessed,
	isnull(tblassessed.sumassessed,0) as sumassessed,
	isnull(tblpaid.countpaid,0) as countpaid,
	isnull(tblpaid.sumpaid,0) as sumpaid
from 
	tblentrytype et left outer join
	(
		select
			entrytypeid,
			count(registerid) as countassessed,
			sum(-amount) as sumassessed
		from
			tblregister r
		join 
			tblclient c on c.clientid = r.clientid
			and (@companyid is null or c.companyid = @companyid)
			and (@agencyid is null or c.agencyid = @agencyid)
		where
			transactiondate between @date1 and @date2
		group by
			entrytypeid
	) tblassessed on et.entrytypeid=tblassessed.entrytypeid left outer join
	(
		select
			entrytypeid,
			count(registerpaymentid) as countpaid,
			sum(rp.amount) as sumpaid
		from
			tblregisterpayment rp inner join
			tblregister r on r.registerid=rp.feeregisterid
		join 
			tblclient c on c.clientid = r.clientid
			and (@companyid is null or c.companyid = @companyid)			
			and (@agencyid is null or c.agencyid = @agencyid)
		where
			paymentdate between @date1 and @date2
			and not voided is null
			and not bounced is null
		group by
			entrytypeid
	) tblpaid on et.entrytypeid=tblpaid.entrytypeid
where
	et.fee=1
order by
	feetype
GO
