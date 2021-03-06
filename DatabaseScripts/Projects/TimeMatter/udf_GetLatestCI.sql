set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER function [dbo].[udf_GetlatestCI](@ClientId int,@4Creditor varchar(10)) 
returns varchar(100)
as
begin
   --- 03.15.2010 get latestCI
	declare @assignedto varchar(100)
	set @assignedto = ''
	

	select distinct
	
	 @assignedTo = cci.creditorinstanceid

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
where  clientid = @ClientId 
		and  RIGHT(cci.accountnumber,4) = @4Creditor

	return @assignedto

end




