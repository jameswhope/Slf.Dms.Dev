IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementStipulations')
	BEGIN
		DROP  Procedure  stp_GetSettlementStipulations
	END

GO

CREATE Procedure stp_GetSettlementStipulations
AS
BEGIN
	select 
	s.settlementid
	, c.clientid
	, p.FirstName + ' ' + p.LastName AS [Client Name]
	, cg.Name AS [Creditor Name]
	, a.CurrentAmount
	, s.SettlementAmount
	, s.RegisterBalance [SDABalance]
	, cu.FirstName + ' ' + cu.LastName AS [Created By] 
	, s.created
	, a.accountid
	, c.accountnumber
	from tblSettlements s with(nolock)
	join tblAccount a with(nolock) ON a.AccountID = s.CreditorAccountID
	join tblCreditorInstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
	join tblcreditor cr with(nolock) on cr.creditorid = ci.creditorid
	join tblcreditorgroup cg with(nolock) on cg.creditorgroupid = cr.creditorgroupid
	join tblclient c with(nolock) on c.clientid = s.clientid
	join tblperson p with(nolock) on p.personid = c.primarypersonid
	join tblUser cu with(nolock) ON cu.UserID = s.CreatedBy 
	where IsClientStipulation = 1 and status='A' and active = 1
END

GO


GRANT EXEC ON stp_GetSettlementStipulations TO PUBLIC

GO


