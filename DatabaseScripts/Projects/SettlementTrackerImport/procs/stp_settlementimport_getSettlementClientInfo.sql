IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_getSettlementClientInfo')
	BEGIN
		DROP  Procedure  stp_settlementimport_getSettlementClientInfo
	END

GO

CREATE procedure [dbo].[stp_settlementimport_getSettlementClientInfo]
(
	@clientaccountnumber numeric
)
as
BEGIN
	select top 1 
		c.agencyid
		,c.settlementfeepercentage
		, co.shortconame[LawFirm]
		, c.currentclientstatusid
		,c.SDABalance - c.PFOBalance - (SELECT ISNULL(SUM(Amount), 0) AS Expr1 FROM dbo.tblRegister WHERE (ClientId = c.ClientID) AND (EntryTypeId = 3) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) - (SELECT ISNULL(SUM(Amount), 0) AS Expr1 FROM dbo.tblRegister AS tblRegister_3 WHERE (ClientId = c.ClientID) AND (EntryTypeId = 43) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) [FundsAvail]
	from 
		tblclient c inner join tblcompany co on c.companyid = co.companyid
	where 
		accountnumber = @clientaccountnumber
END

GRANT EXEC ON stp_settlementimport_getSettlementClientInfo TO PUBLIC


