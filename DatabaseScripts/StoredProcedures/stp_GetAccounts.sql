/****** Object:  StoredProcedure [dbo].[stp_GetAccounts]    Script Date: 11/19/2007 15:27:03 ******/
DROP PROCEDURE [dbo].[stp_GetAccounts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetAccounts]
	(
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

exec
(
	'select
		tblaccount.*,
		tblcreditorinstance.creditorid,
		tblcreditorinstance.forcreditorid,
		tblcreditorinstance.acquired,
		tblcreditorinstance.accountnumber,
		tblcreditorinstance.referencenumber,
		tblcreditor.[name] as creditorname,
		tblcreditor.street as creditorstreet,
		tblcreditor.street2 as creditorstreet2,
		tblcreditor.city as creditorcity,
		tblcreditor.stateid as creditorstateid,
		tblstate.[name] as creditorstatename,
		tblstate.abbreviation as creditorstateabbreviation,
		tblcreditor.zipcode as creditorzipcode,
		tblforcreditor.[name] as forcreditorname,
		tblforcreditor.street as forcreditorstreet,
		tblforcreditor.street2 as forcreditorstreet2,
		tblforcreditor.city as forcreditorcity,
		tblforcreditor.stateid as forcreditorstateid,
		tblforstate.[name] as forcreditorstatename,
		tblforstate.abbreviation as forcreditorstateabbreviation,
		tblforcreditor.zipcode as forcreditorzipcode,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname,
		tblsettledby.firstname + '' '' + tblsettledby.lastname as settledbyname,
		isnull(n.numnotes,0) + isnull(pc.numphonecalls,0) as numcomms,
		tblcreditor.validated as creditorvalidated,
		tblforcreditor.validated as forcreditorvalidated,
		tblcreditor.creditorgroupid as creditorgroupid,
		tblforcreditor.creditorgroupid as forcreditorgroupid
	from
		tblaccount inner join
		tblcreditorinstance on tblaccount.currentcreditorinstanceid = tblcreditorinstance.creditorinstanceid inner join
		tblcreditor on tblcreditorinstance.creditorid = tblcreditor.creditorid left outer join
		tblcreditor as tblforcreditor on tblcreditorinstance.forcreditorid = tblforcreditor.creditorid left outer join
		tblstate on tblcreditor.stateid = tblstate.stateid left outer join
		tblstate as tblforstate on tblforcreditor.stateid = tblforstate.stateid left outer join
		tbluser as tblcreatedby on tblaccount.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tblaccount.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tbluser as tblsettledby on tblaccount.settledby = tblsettledby.userid left outer join
		(
			select
				isnull(count(distinct noteid),0) as numnotes,
				relationid
			from
				tblnoterelation
			where
				relationtypeid = 2
			group by
				relationid
		)
		as n on tblaccount.accountid = n.relationid left outer join
		(
			select
				isnull(count(distinct phonecallid),0) as numphonecalls,
				relationid
			from
				tblphonecallrelation
			where
				relationtypeid = 2
			group by
				relationid
		)
		as pc on tblaccount.accountid = pc.relationid
	' + @where + ' ' + @orderby
)
GO
