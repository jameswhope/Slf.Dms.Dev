/****** Object:  StoredProcedure [dbo].[stp_GetCreditorInstancesForAccount]    Script Date: 11/19/2007 15:27:07 ******/
DROP PROCEDURE [dbo].[stp_GetCreditorInstancesForAccount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCreditorInstancesForAccount]
	(
		@accountid int
	)

as

select
	tblcreditorinstance.*,
	convert(bit, (
		case
			when tblaccount.currentcreditorinstanceid = tblcreditorinstance.creditorinstanceid
			then 1
			else 0
		end
	))
	as iscurrent,
	isnull(tblaccount.settlementfeecredit,0) as settlementfeecredit,
	tblaccount.originalamount,
	tblaccount.currentamount,
	tblaccount.originalduedate,
	isnull(g.name,tblcreditor.name) as creditorname,
	isnull(f.name,forcreditor.name) as forcreditorname,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname,
	case when tblcreditor.validated = 0 then 'red' else 'black' end [Color],
	tblcreditor.validated
from
	tblcreditorinstance inner join
	tblaccount on tblcreditorinstance.accountid = tblaccount.accountid inner join
	tblcreditor on tblcreditorinstance.creditorid = tblcreditor.creditorid left outer join
	tblcreditor forcreditor on tblcreditorinstance.forcreditorid = forcreditor.creditorid left outer join
	tbluser as tblcreatedby on tblcreditorinstance.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblcreditorinstance.lastmodifiedby = tbllastmodifiedby.userid left join
	tblcreditorgroup g on g.creditorgroupid = tblcreditor.creditorgroupid left join
	tblcreditorgroup f on f.creditorgroupid = forcreditor.creditorgroupid
where
	tblcreditorinstance.accountid = @accountid
order by
	tblcreditorinstance.created,
	tblcreditorinstance.creditorinstanceid
GO
 