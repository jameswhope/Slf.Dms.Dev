IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getPending')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getPending
	END

GO

create procedure stp_settlementimport_reports_getPending
(
@year int,
@month int,
@UseOriginalBalance bit = null
)
as
BEGIN
	declare @tblR table(rOrder int,Pending varchar(100),Fees money,Units int)
	declare @AutomatedClause varchar(500)

	if @month <8 
		BEGIN
			set @AutomatedClause = ''
		END
	else
		BEGIN
			set @AutomatedClause = 'and s.matterid is not null '
		END

	if @UseOriginalBalance = 1
	BEGIN
		insert into @tblR 
		select 
		rOrder = 0,[Pending] = Team, [Fees] = convert(money,sum((a.originalamount-s.settlementamount)*c.SettlementFeePercentage)), [Units] = count(*)
		from tblSettlementTrackerImports sti with (nolock) 
		inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid
		inner join tblaccount a  with(nolock) on a.accountid = s.creditoraccountid
		inner join tblclient c with(nolock) on c.clientid = s.clientid
		where paid is null and year(date) = @year and month(date) = @month and canceldate is null and s.matterid is not null
		group by team order by team
	END
ELSE
	BEGIN	
		insert into @tblR 
		exec('select rOrder = 0,[Pending] = Team, [Fees] = convert(money,sum(settlementfees)), [Units] = count(*)
		from tblSettlementTrackerImports sti with (nolock) inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid
		where paid is null and year(date) = ' + @year + ' and month(date) = ' + @month + ' and canceldate is null ' + @AutomatedClause + '
		group by team order by team')
	END

	insert into @tblR 
	select 
	rOrder = 1
	,[Pending] = 'TOTAL'
	, [Fees] = sum(Fees)
	, [Units] = sum(Units)
	from @tblR

	select [Pending], [Fees] , [Units] from @tblR order by rorder
END

GRANT EXEC ON stp_settlementimport_reports_getPending TO PUBLIC


