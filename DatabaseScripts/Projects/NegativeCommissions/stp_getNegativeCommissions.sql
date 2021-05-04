IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getNegativeCommissions')
	BEGIN
		DROP  Procedure  stp_getNegativeCommissions
	END

GO

CREATE PROCEDURE  stp_getNegativeCommissions 
AS
Begin

Declare @mastertable table(
MasterId int identity(1,1) 	Primary Key,
CompanyID int,
TrustID int,
CommScenID int,
CommRecID int,
ParentCommRecID int,
[Order] int, 
CommPaid money,
ChargeBack money)

SELECT
	CompanyID,
	TrustID,
	ID,
	[Type],
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	Amount,
	[Date]
Into #t
FROM
(
	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
		cp.CommPayID as ID,
		'CP' as [Type],
		cs.CommScenID,
		cs.CommRecID,
		cs.ParentCommRecID,
		cs.[Order],
		cp.Amount,
		rp.PaymentDate [Date]
	FROM
		tblCommPay as cp
		inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
		inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cp.CommBatchID is null

	UNION ALL

	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
		cc.CommChargebackID as ID,
		'CB' as [Type],
		cs.CommScenID,
		cs.CommRecID,
		cs.ParentCommRecID,
		cs.[Order],
		-cc.Amount,
		cc.chargebackdate [Date]
	FROM
		tblCommChargeback as cc
		inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
		inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblCommStruct as cs on cs.CommStructID = cc.CommStructID
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cc.CommBatchID is null
) as d

Insert @mastertable(
	CompanyID,	
	TrustID, 
	CommScenID, 
	CommRecID,	
	ParentCommRecID, 
	[Order],
	CommPaid,
	ChargeBack)
SELECT
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	sum(Case When [Type] = 'CP' Then Amount Else 0 End) [Paid Amount],
	sum(Case When [Type] <> 'CP' Then Amount Else 0 End) [CB Amount]
From #t
GROUP BY
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order]
Having sum(Amount) <= 0
order by
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order]

select distinct isnull(m.CommRecId,0) [RecId],
isnull(cr.Display, 'N/A') [RecipientName] 
from @masterTable m
left join tblCommRec cr on cr.commrecid = m.commrecid
Order By 2

select m.masterid [MasterId],
isnull(t.DisplayName, 'N/A') [Trust],
isnull(c.ShortCoName, 'N/A') [Company],
isnull(m.CommScenId, 0) [CommScenId],
isnull(pcr.Abbreviation, 'N/A') [ParentCommRec],
isnull(cr.CommRecId, 0) [CommRecId],
isnull(cr.Abbreviation, 'N/A') [CommRec],
m.CommPaid [CommPaid],
m.ChargeBack [ChargeBack]
from @masterTable m
left join tblTrust t on t.trustid = m.trustid
left join tblCompany c on c.companyid = m.companyid
left join tblCommRec pcr on pcr.commrecid = m.parentcommrecid
left join tblCommRec cr on cr.commrecid = m.commrecid
Order By 1,2,3,4,5,6,7

select t1.masterId [MasterId], 
	   t.Type [Type], 
	   t.id [TypeId], 
	   t.Amount [Amount], 
	   t.[Date] [Udate], 
	   convert(varchar, t.[Date], 101) [Date] 
from #t t
inner join @mastertable t1 on t1.companyid = t.companyid 
and t1.trustid = t.trustid 
and t1.commscenid = t.commscenid 
and t1.commrecid = t.commrecid 
and t1.parentcommrecid = t.parentcommrecid 
and t1.[order] = t.[order]
order by t1.masterid, t.[date] desc

drop table #t

End

GO

