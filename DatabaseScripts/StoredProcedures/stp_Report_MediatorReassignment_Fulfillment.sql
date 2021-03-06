/****** Object:  StoredProcedure [dbo].[stp_Report_MediatorReassignment_Fulfillment]    Script Date: 11/19/2007 15:27:39 ******/
DROP PROCEDURE [dbo].[stp_Report_MediatorReassignment_Fulfillment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Report_MediatorReassignment_Fulfillment]
(
	@userid int
)

as

select
	c.clientid,
	c.assignedmediator,
	p.lastname,
	(select top 1 balance from tblregister where clientid = c.clientid order by transactiondate desc, registerid desc) as sdabalance,
	count(a.accountid) as accounts
from
	tblclient c inner join
	tblperson p on c.primarypersonid=p.personid inner join
	tblaccount a on c.clientid=a.clientid
where
	c.assignedmediator=@userid
group by
	c.clientid,
	c.assignedmediator,
	p.lastname
GO
