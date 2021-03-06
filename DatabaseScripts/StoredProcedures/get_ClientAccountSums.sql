/****** Object:  StoredProcedure [dbo].[get_ClientAccountSums]    Script Date: 11/19/2007 15:26:47 ******/
DROP PROCEDURE [dbo].[get_ClientAccountSums]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_ClientAccountSums]
(
	@clientId int,
	@settled bit=null,
	@removed bit=null
)

AS

SET NOCOUNT ON

select 
	sum(total.currentamount) as total,
	sum(total.originalamount) as originaltotal,
	sum(active.currentamount) as totalactive,
	sum(active.originalamount) as originaltotalactive
from
	(
		select 
			a.accountid,
			sum(currentamount) as currentamount,
			sum(ci.originalamount) as originalamount
		from
			tblaccount a inner join
			tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid
		where 
			clientid=@clientid
			and	(
					@settled is null or 
					(@settled=1 and not settled is null) or
					(@settled=0 and settled is null)
				)
			and	(
					@removed is null or 
					(@removed=1 and not removed is null) or
					(@removed=0 and removed is null)
				)
		group by
			a.accountid
	) as total left join

	(
		select 
			a.accountid,
			sum(currentamount) as currentamount,
			sum(ci.originalamount) as originalamount
		from 
			tblaccount a inner join
			tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid
		where 
			clientid=@clientid 
			and settled is null 
			and removed is null
			and	(
					@settled is null or 
					(@settled=1 and not settled is null) or
					(@settled=0 and settled is null)
				)
			and	(
					@removed is null or 
					(@removed=1 and not removed is null) or
					(@removed=0 and removed is null)
				)
		group by
			a.accountid
	) as active on total.accountid=active.accountid
GO
