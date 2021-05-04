IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_NonDeposit_ActiveCompletedClients')
	BEGIN
		DROP  View vw_NonDeposit_ActiveCompletedClients
	END
GO

CREATE View vw_NonDeposit_ActiveCompletedClients AS
select c.clientid
from tblclient c
where c.CurrentClientStatusID not in (15, 17, 18, 22)
and pfobalance <= 0 
and sdabalance >= 0
and not (select count(acc.accountid) from tblaccount acc where acc.accountstatusid not in  (54, 55, 168, 169, 170, 171) and acc.clientid = c.clientid) > 0
GO

 