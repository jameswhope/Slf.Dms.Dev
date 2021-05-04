IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getFirmPaidLost')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getFirmPaidLost
	END

GO

CREATE Procedure stp_settlementimport_reports_getFirmPaidLost
	(
		@year int,
		@month int,
		@UseOriginalBalance bit = null
	)
AS
BEGIN

	declare @tblR table(rOrder int,LawFirm varchar(100),PaidUnits int,PaidFeesLost money,TotalUnits int,TotalPotentialLost money)

	if @UseOriginalBalance = 1
		BEGIN
			insert into @tblR 
			select 
				rOrder = 0
				,[LawFirm] 
				, [PaidUnits] =  sum(case when c.settlementfeepercentage = 0 and year(paid) = @year and month(paid) = @month then 1 else 0 end )
				, [PaidFeesLost] = sum(case when c.settlementfeepercentage = 0 and year(paid) = @year and month(paid) = @month then (a.originalamount-s.settlementamount)*.33 else 0 end )
				, [TotalUnits] = sum(case when c.settlementfeepercentage = 0 and year(date) = @year and month(date) = @month then 1 else 0 end )
				, [TotalPotentialLost] = sum(case when c.settlementfeepercentage = 0 and year(date) = @year and month(date) = @month then (a.originalamount-s.settlementamount)*.33 else 0 end )
			FROM tblSettlementTrackerImports sti
			inner join tblsettlements s on s.settlementid = sti.settlementid
			inner join tblaccount a  with(nolock) on a.accountid = s.creditoraccountid
			inner join tblclient c on c.clientid = s.clientid
			group by LawFirm
			
		END
	ELSE
		BEGIN	
			insert into @tblR 
			select 
				rOrder = 0
				,[LawFirm] 
				, [PaidUnits] =  sum(case when c.settlementfeepercentage = 0 and year(paid) = @year and month(paid) = @month then 1 else 0 end )
				, [PaidFeesLost] = sum(case when c.settlementfeepercentage = 0 and year(paid) = @year and month(paid) = @month then s.settlementsavings*.33 else 0 end )
				, [TotalUnits] = sum(case when c.settlementfeepercentage = 0 and year(date) = @year and month(date) = @month then 1 else 0 end )
				, [TotalPotentialLost] = sum(case when c.settlementfeepercentage = 0 and year(date) = @year and month(date) = @month then s.settlementsavings*.33 else 0 end )
			FROM tblSettlementTrackerImports sti
			inner join tblsettlements s on s.settlementid = sti.settlementid
			inner join tblclient c on c.clientid = s.clientid
			group by LawFirm
		END

	insert into @tblR 
	select 
		rOrder = 1
		,[LawFirm] = 'TOTAL' 
		, [PaidUnits] =  sum(PaidUnits)
		, [PaidFeesLost] = sum(PaidFeesLost)
		, [TotalUnits] = sum(TotalUnits)
		, [TotalPotentialLost] = sum(TotalPotentialLost)
	FROM @tblR


	select [LawFirm]=isnull(lawfirm,0), [PaidUnits]=isnull(paidunits,0), [PaidFeesLost]=isnull(PaidFeesLost,0), 
	[TotalUnits]=isnull(TotalUnits,0), [TotalPotentialLost]=isnull(TotalPotentialLost,0)
	from @tblR	order by rorder
END


GRANT EXEC ON stp_settlementimport_reports_getFirmPaidLost TO PUBLIC

