/****** Object:  StoredProcedure [dbo].[stp_GetMediationsForClient]    Script Date: 11/19/2007 15:27:10 ******/
DROP PROCEDURE [dbo].[stp_GetMediationsForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetMediationsForClient]
	(
		@clientid int
	)

as

select
	tblmediation.*,
	tblaccount.clientid,
	tblaccount.originalamount,
	tblaccount.currentamount,
	tblaccount.currentcreditorinstanceid,
	tblcreditorinstance.accountnumber,
	tblcreditorinstance.creditorid as currentcreditorid,
	tblcreditor.name as currentcreditorname,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.lastname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblmediation inner join
	tblaccount on tblmediation.accountid = tblaccount.accountid inner join
	tblcreditorinstance on tblaccount.currentcreditorinstanceid = tblcreditorinstance.creditorinstanceid inner join
	tblcreditor on tblcreditorinstance.creditorid = tblcreditor.creditorid left outer join
	tbluser as tblcreatedby on tblmediation.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblmediation.lastmodifiedby = tbllastmodifiedby.userid
where
	tblaccount.clientid = @clientid
GO
