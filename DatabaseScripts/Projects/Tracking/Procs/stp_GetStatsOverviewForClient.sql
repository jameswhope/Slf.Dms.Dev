/****** Object:  StoredProcedure [dbo].[stp_GetStatsOverviewForClient]    Script Date: 11/19/2007 15:27:16 ******/
DROP PROCEDURE [dbo].[stp_GetStatsOverviewForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetStatsOverviewForClient]
	(
		@clientid int
	)

as

-- discretionary variables
declare @numaccounts int
declare @sumaccounts money
declare @registerbalance money
declare @frozenbalance money
declare @pfobalance money

select
	@numaccounts = count(accountid),
	@sumaccounts = sum(currentamount)
from
	tblaccount
where
	tblaccount.clientid = @clientid


--09/16/2008 UG.  Changed to tblclient to exclude transactions that haven't happened yet
select top 1
	@registerbalance = sdabalance,
	@pfobalance = pfobalance
from
	tblclient
where
	tblclient.clientid = @clientid


SELECT     TOP (1) 
	@frozenbalance = tblRegister.Amount
FROM
	tblSettlements AS s INNER JOIN
    tblRegister ON s.SettlementRegisterHoldID = tblRegister.RegisterId
WHERE
	(s.ClientID = @clientid) 
ORDER BY 
	s.Created DESC



select
	coalesce(@numaccounts, 0) as numaccounts,
	coalesce(@sumaccounts, 0) as sumaccounts,
	coalesce(@registerbalance, 0) as registerbalance,
	coalesce(@frozenbalance, 0) as frozenbalance,
	coalesce(@pfobalance, 0) as pfobalance
GO
