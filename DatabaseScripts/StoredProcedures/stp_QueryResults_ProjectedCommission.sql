/****** Object:  StoredProcedure [dbo].[stp_QueryResults_ProjectedCommission]    Script Date: 11/19/2007 15:27:36 ******/
DROP PROCEDURE [dbo].[stp_QueryResults_ProjectedCommission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryResults_ProjectedCommission]
(
	@commrecid int = null,	
	@monthdate datetime,
	@col int,
	@ach bit = null
)
as

set @col=@col+1

declare @ismca bit

if @col in (1,3) begin --potential

	if @col=1 begin
		set @ismca=1
	end else begin
		set @ismca=0
	end

	select 
		'client' as [type],
		isnull(pc.clientid,0) as typeid,
		firstname [First Name],
		lastname [Last Name],
		mca MonthlyCommitAmt,
		da ProjectedDepAmt,
		depositmethod DepMethod,
		isnull(sum(commissionearned),0) as ProjectedCommEarned
	from 
		tblprojectedclient c left outer join 
		tblprojectedcommission pc on 
			c.clientid=pc.clientid 
			and c.[month]=pc.[month]
			and c.[year]=pc.[year]
	where
		ach=isnull(@ach,ach)
		and (ismca is null or ismca=@ismca)
		and (@commrecid is null or @commrecid=commrecid)
		and month(@monthdate)=c.[month]
		and year(@monthdate)=c.[year]
	group by
		pc.clientid,
		firstname,
		lastname,
		mca,
		da,
		depositmethod,
		ach,
		exceptionreason
	order by
		lastname,
		firstname
end else if @col=2 begin  --exceptions

	select 
		'client' as [type],
		c.clientid as typeid,
		firstname [First Name],
		lastname [Last Name],
		mca MonthlyCommitAmt,
		da ProjectedDepAmt,
		depositmethod DepMethod,
		isnull(sum(case when ismca=0 then commissionearned else 0 end),0) as ProjectedCommEarned,
		exceptionreason as Reason
	from 
		tblprojectedclient c left outer join 
		tblprojectedcommission pc on 
			c.clientid=pc.clientid 
			and c.[month]=pc.[month]
			and c.[year]=pc.[year]
	where
		ach=isnull(@ach,ach)
		and not c.exceptionreason is null
		and (@commrecid is null or @commrecid=commrecid)
		and month(@monthdate)=c.[month]
		and year(@monthdate)=c.[year]
		
	group by
		c.clientid,
		firstname,
		lastname,
		mca,
		da,
		depositmethod,
		ach,
		exceptionreason
	order by
		lastname,
		firstname
end else if @col in (6,7) begin
	select 
		'client' as [type],
		ca.clientid as typeid,
		p.firstname [First Name],
		p.lastname [Last Name],
		isnull(c.depositmethod,'Check') DepMethod,
		isnull(sum(ca.FeePaymentAmount),0) as SumOfPayments,
		isnull(sum(ca.CommissionEarned),0) as Commission
	from 
		tblprojectedcommissionactual ca inner join
		tblclient c on ca.clientid=c.clientid inner join
		tblperson p on c.primarypersonid=p.personid
	where
		(case when depositmethod='ach' then 1 else 0 end )=isnull(@ach,(case when depositmethod='ach' then 1 else 0 end))
		and (@commrecid is null or @commrecid=commrecid)
		and month(@monthdate)=ca.[month]
		and year(@monthdate)=ca.[year]
		and ca.col=@col
	group by
		ca.clientid,
		p.firstname,
		p.lastname,
		c.depositmethod
	order by 
		p.lastname,
		p.firstname
end else if @col in (4,5,8) begin
	select 
		'client' as [type],
		hc.typeid,
		FirstName,
		LastName,
		c.depositamount MonthlyCommitAmt,
		customvalue3 as ProjectedDepAmt,
		isnull(c.depositmethod,'Check') DepMethod,
		customvalue2 as ProjectedCommMissed,
		customvalue as Reason
	from
		tblhomepageclientcache hc inner join
		tblclient c on hc.typeid=c.clientid inner join
		tblperson p on c.primarypersonid=p.personid
	where
		month(@monthdate)=hc.[month]
		and year(@monthdate)=hc.[year]		
		and ((hc.commrecid is null and @commrecid is null) or 
			@commrecid=hc.commrecid)
		and hc.col=@col
		and hc.ach=isnull(@ach,ach)
	order by 
		p.lastname,
		p.firstname
end
GO
