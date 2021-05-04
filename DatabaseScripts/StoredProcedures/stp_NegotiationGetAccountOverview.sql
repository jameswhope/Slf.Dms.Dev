IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'Stored_Procedure_Name')
	BEGIN
		DROP  Procedure  Stored_Procedure_Name
	END

GO

CREATE PROCEDURE [dbo].[stp_NegotiationGetAccountOverview]
(
	@clientId int,
	@ids nvarchar(MAX) = null,
	@settled bit = null,
	@removed bit = null
)

AS

SET NOCOUNT ON

declare @vtblIDs table
(
	AccountID int
)

if @ids is not null
begin
	declare @filterclause nvarchar(MAX)

	declare @fcTable table
	(
		FilterClause nvarchar(MAX)
	)

	INSERT INTO
		@fcTable
	EXEC
	(
		'declare @fc nvarchar(MAX)

		SELECT
			@fc = coalesce(@fc + '' or '', '''') + ''('' + cast(AggregateClause as nvarchar(MAX)) + '')''
		FROM
			tblNegotiationFilters
		WHERE
			FilterID in (' + @ids + ')

		SELECT @fc'
	)

	SELECT TOP 1 @filterclause = FilterClause FROM @fcTable

	if @filterclause is null or len(@filterclause) = 0
	begin
		set @filterclause = '1 = 0'
	end

	INSERT INTO
		@vtblIDs
	EXEC 
	('
		SELECT
			DISTINCT AccountID
		FROM
			tblCache_vwNegotiationDistributionSource
		WHERE
			' + @filterclause
	)
end
else
begin
	INSERT INTO
		@vtblIDs
	SELECT
		AccountID
	FROM
		tblAccount
	WHERE
		ClientID = @clientid
end

select
	a.AccountId,
	a.OriginalAmount,
	a.CurrentAmount,
	oci.accountnumber as OriginalAccountNumber,
	oci.referencenumber as OriginalReferenceNumber,
	oc.creditorid as OriginalCreditorID,
	oc.name as OriginalCreditorName,
	(ocp.areacode + ocp.number + ' ' + isnull(ocp.extension,'')) as OriginalCreditorPhone,
	cci.accountnumber as CurrentAccountNumber,
	cci.referencenumber as CurrentReferenceNumber,
	cc.creditorid as CurrentCreditorID,
	cc.name as CurrentCreditorName,
	(ccp.AreaCode + ccp.Number + ' ' + isnull(ccp.Extension,'')) as CurrentCreditorPhone,
	[as].AccountStatusID,
	[as].Code as AccountStatusCode,
	[as].Description as AccountStatusDescription,
	isnull(n.numnotes,0) + isnull(pc.numphonecalls,0) as numcomms,
	case when verified is null then 0 else 1 end as verified,
	a.settled,
	a.removed
from
	tblaccount a inner join
	tblcreditorinstance oci ON a.originalcreditorinstanceid = oci.creditorinstanceid inner join
	tblcreditor oc ON oci.creditorid = oc.creditorid inner join
	tblcreditorinstance cci ON a.currentcreditorinstanceid = cci.creditorinstanceid inner join
	tblcreditor cc ON cci.creditorid = cc.creditorid left join
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
			(@settled is null) or 
			(@settled=1 and not settled is null) or
			(@settled=0 and settled is null)
		)
	and	(
			(@removed is null) or 
			(@removed=1 and not removed is null) or
			(@removed=0 and removed is null)
		)
	and (
			a.accountid in (SELECT AccountID FROM @vtblIDs)
		)