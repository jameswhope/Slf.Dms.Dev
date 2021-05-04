IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_GetSettledSettlementWithActivePmts')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_GetSettledSettlementWithActivePmts
	END

GO

CREATE Procedure stp_PaymentArrangement_GetSettledSettlementWithActivePmts
@AccountId int
AS
select st.settlementid
from tblmatter ms
join
(select top 1 s.matterid, s.settlementid 
from tblsettlements s
join tblaccount a on s.creditoraccountid = a.accountid 
where s.active = 1
and s.creditoraccountid = @AccountId
and s.ispaymentarrangement = 1
and a.accountstatusid = 54
order by s.settlementid desc) st on st.matterid = ms.matterid
where
ms.isdeleted = 0
and ms.matterstatusid = 3

GO

 
