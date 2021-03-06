/****** Object:  StoredProcedure [dbo].[stp_GetStatsOverviewForClient]    Script Date: 11/19/2007 15:27:16 ******/
/***Modified by JHope 02/17/2010***/
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
declare @numUVaccounts int
declare @sumUnVerified money

select
	@numaccounts = count(accountid),
	@sumaccounts = sum(currentamount)
from
	tblaccount
where
	tblaccount.clientid = @clientid
	AND accountid in (select accountid from tblaccount where removed is null)
	AND accountid in (select accountid from tblaccount where Settled is null)
	AND accountid in (select accountid from tblaccount where accountstatusid <> 171)

--01/15/2010 J Hope added unverified count and sum to overview page.
select 
	@numUVaccounts = count(accountid),
	@sumUnVerified = sum(currentamount)
from
	tblaccount
where
	tblaccount.clientid = @clientid
	AND verified IS NULL
	AND accountid IN (select accountid from tblaccount where removed is null)
	AND accountid IN (select accountid from tblaccount where Settled is null)
	AND accountid in (select accountid from tblaccount where accountstatusid <> 171)

--09/16/2008 UG.  Changed to tblclient to exclude transactions that haven''t happened yet
select top 1
	@registerbalance = sdabalance,
	@pfobalance = pfobalance
from
	tblclient
where
	tblclient.clientid = @clientid

/*
10.1.2008 - do not hold funds.
SELECT     TOP (1) 
	@frozenbalance = tblRegister.Amount
FROM
	tblSettlements AS s INNER JOIN
    tblRegister ON s.SettlementRegisterHoldID = tblRegister.RegisterId
WHERE
	(s.ClientID = @clientid) 
ORDER BY 
	s.Created DESC
*/


select
	coalesce(@numaccounts, 0) as numaccounts,
	coalesce(@sumaccounts, 0) as sumaccounts,
	coalesce(@registerbalance, 0) as registerbalance,
	coalesce(@frozenbalance, 0) as frozenbalance,
	coalesce(@pfobalance, 0) as pfobalance,
	coalesce(@numUVaccounts, 0) as numUnverifiedAccounts,
	coalesce(@sumUnVerified, 0) as sumUnVerified
GO
