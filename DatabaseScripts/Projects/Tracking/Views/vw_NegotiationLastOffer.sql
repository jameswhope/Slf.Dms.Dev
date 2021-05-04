IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_NegotiationLastOffer')
	BEGIN
		DROP  View vw_NegotiationLastOffer
	END
GO

CREATE view [dbo].[vw_NegotiationLastOffer] as

select CreditorAccountID [AccountID], Created [LastOffer], OfferDirection
from tblSettlements s
join (
	select max(nr.SettlementID) [SettlementID]
	from dbo.tblSettlements 
	join tblnegotiationroadmap as nr on tblSettlements.settlementid = nr.settlementid
	where nr.settlementstatusid not in (3,5,6,7,8,9,10,14)
	group by ClientID,CreditorAccountID
) t on t.SettlementID = s.SettlementID

GO

GRANT SELECT ON vw_NegotiationLastOffer TO PUBLIC


