/****** Object:  StoredProcedure [dbo].[stp_Statistic_TrustAccount]    Script Date: 11/19/2007 15:27:46 ******/
DROP PROCEDURE [dbo].[stp_Statistic_TrustAccount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_TrustAccount]

as

select
	c.trustid,
	t.[name] as trustname,
	sum(r.balance) as balance
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
				clientid,
				max(transactiondate) as transactiondate
			from
				tblregister 
			where
				bounce is null and
				void is null
			group by
				clientid
		)
		as nnr on nr.clientid = nnr.clientid and nr.transactiondate = nnr.transactiondate
	group by
		nr.clientid
	)
	as nr on r.registerid = nr.registerid inner join
	tblclient c on r.clientid = c.clientid inner join
	tbltrust t on c.trustid=t.trustid
where
	r.balance > 0 
group by
	c.trustid, t.[name]
order by
	c.trustid, t.[name]
GO
