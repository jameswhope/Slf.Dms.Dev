/****** Object:  StoredProcedure [dbo].[get_ClientAccountOverviewList]    Script Date: 11/19/2007 15:26:46 ******/
DROP PROCEDURE [dbo].[get_ClientAccountOverviewList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_ClientAccountOverviewList]
(
	@clientId int,
	@settled bit=null,
	@removed bit=null
)

AS

SET NOCOUNT ON

select distinct
	a.AccountId,
	a.OriginalAmount,
	a.CurrentAmount, cci.creditorinstanceid,
	oci.accountnumber as OriginalAccountNumber,
	oci.referencenumber as OriginalReferenceNumber,
	oc.creditorid as OriginalCreditorID,
	isnull(og.name,oc.name) as OriginalCreditorName,
	(ocp.areacode + ocp.number + ' ' + isnull(ocp.extension,'')) as OriginalCreditorPhone,
	cci.accountnumber as CurrentAccountNumber,
	cci.referencenumber as CurrentReferenceNumber,
	cc.creditorid as CurrentCreditorID,
	isnull(cg.name,cc.name) as CurrentCreditorName,
	cc.name+'-'+RIGHT(cci.accountnumber,4) as CreditorName,
	(ccp.AreaCode + ccp.Number + ' ' + isnull(ccp.Extension,'')) as CurrentCreditorPhone,
	[as].AccountStatusID,
	[as].Code as AccountStatusCode,
	[as].Description as AccountStatusDescription,
	isnull(n.numnotes,0) + isnull(pc.numphonecalls,0) as numcomms,
	case when verified is null then 0 else 1 end as verified,
	a.settled,
	a.removed,
	(select count(*) from tblmatter m inner join tblmatterstatus s on s.matterstatusid=m.matterstatusid 
		left outer join tblcreditorinstance c on m.creditorinstanceid=c.creditorinstanceid
		where IsNull(m.IsDeleted,0)=0 and c.accountid=a.accountid and IsNull(s.IsMatterActive,0)=0) as ClosedMatters,
	(select count(*) from tblmatter m inner join tblmatterstatus s on s.matterstatusid=m.matterstatusid 
		left outer join tblcreditorinstance c on m.creditorinstanceid=c.creditorinstanceid
		where IsNull(m.IsDeleted,0)=0 and c.accountid=a.accountid and IsNull(s.IsMatterActive,0)=1) as ActiveMatters

from
	tblaccount a inner join
	tblcreditorinstance oci ON a.originalcreditorinstanceid = oci.creditorinstanceid inner join
	tblcreditor oc ON oci.creditorid = oc.creditorid left join
	tblcreditorgroup og on og.creditorgroupid = oc.creditorgroupid inner join
	tblcreditorinstance cci ON a.currentcreditorinstanceid = cci.creditorinstanceid inner join
	tblcreditor cc ON cci.creditorid = cc.creditorid left join
	tblcreditorgroup cg on cg.creditorgroupid = cc.creditorgroupid left join
	tblaccountstatus [as] ON a.accountstatusid = [as].accountstatusid left outer join
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
	as n on a.accountid = n.relationid left outer join
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
	as pc on a.accountid = pc.relationid left outer join
	(
		select 
			creditorid,
			p.*
		from
			tblcreditorphone cp inner join
			tblphone p on cp.phoneid=p.phoneid
		where 
			p.phoneid = (select top 1 cp2.phoneid from tblcreditorphone cp2 where cp2.creditorid = cp.creditorid)
	)
	ocp on ocp.creditorid = oci.creditorid left outer join
	(
		select 
			creditorid,
			p.*
		from
			tblcreditorphone cp inner join
			tblphone p on cp.phoneid=p.phoneid
		where 
			p.phoneid = (select top 1 cp2.phoneid from tblcreditorphone cp2 where cp2.creditorid = cp.creditorid)
	)
	ccp on ccp.creditorid = cci.creditorid
where
	clientid = @clientId
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
GO
