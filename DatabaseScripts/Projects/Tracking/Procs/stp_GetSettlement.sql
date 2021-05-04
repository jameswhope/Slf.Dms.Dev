IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlement')
	BEGIN
		DROP  Procedure  stp_GetSettlement
	END

GO

create Procedure [dbo].[stp_GetSettlement]
@SettlmentID int
as
	BEGIN
		select
			tblsettlements.*,
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
			tblsettlements  with(nolock) inner join
			tblaccount with(nolock) on tblsettlements.creditoraccountid = tblaccount.accountid inner join
			tblcreditorinstance with(nolock) on tblaccount.currentcreditorinstanceid = tblcreditorinstance.creditorinstanceid inner join
			tblcreditor with(nolock) on tblcreditorinstance.creditorid = tblcreditor.creditorid left outer join
			tbluser as tblcreatedby with(nolock) on tblsettlements.createdby = tblcreatedby.userid left outer join
			tbluser as tbllastmodifiedby with(nolock) on tblsettlements.lastmodifiedby = tbllastmodifiedby.userid
		where
			tblsettlements.settlementid = @SettlmentID
	END

GO


GRANT EXEC ON stp_GetSettlement TO PUBLIC

GO


