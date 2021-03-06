/****** Object:  View [dbo].[vwCommissionReport]    Script Date: 11/19/2007 14:47:51 ******/
DROP VIEW [dbo].[vwCommissionReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwCommissionReport]
as
select
	Clientid,
	CName,
AccountNumber,
	convert(varchar,paymentdate,110) as PaymentDate,
	Company,
	Agency,
	FeeType,
	sum(Amount) as Amount,
	Bounced, 
	Voided, 
	BouncedDescription, 
	InitialDraft, 
	VoidAmount, 
	VoidReason
from
	(
	select
	c.clientid,
	c.accountnumber,
	p.firstname+' '+p.lastname as [CName],
	rp.paymentdate,
	cb.BatchDate,
	comp.[Name] as Company,
	a.[Name] as Agency,
	et.[Name] as FeeType,
	cp.Amount,
	r.Bounce AS Bounced, 
	r.Void AS Voided, 
	tblBouncedReasons.BouncedDescription, 
	CASE WHEN r.initialdraftyn = 1 THEN 'Yes' ELSE 'No' END AS InitialDraft, 
	ISNULL(vr.Amount, 0) AS VoidAmount, 
	vr.Reason AS VoidReason
from
	tblCommPay as cp
	left join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
	left join tblRegister as r on r.RegisterID = rp.FeeRegisterID
	left join tblClient as c on c.ClientID = r.ClientID
	left join tblEntryType as et on et.EntryTypeID = r.EntryTypeID
	left join tblAgency as a on a.AgencyID = c.AgencyID
	left join tblCompany as comp on comp.CompanyID = c.CompanyID
	inner join tblCommBatch as cb on cb.CommBatchID = cp.CommBatchID
	inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
	inner join tblperson p on c.primarypersonid = p.personid LEFT Outer JOIN
	(SELECT 
		Value, 
		Amount, 
		Reason 
	FROM 
		tblTransactionAudit 
	WHERE 
		(Type = N'register')
	) AS vr ON r.RegisterId = vr.Value LEFT OUTER JOIN
	tblBouncedReasons ON r.BouncedReason = tblBouncedReasons.BouncedID
where
	cp.CommBatchID is not null
	--and cs.CommRecID = @recid
		union all
SELECT     
	c.ClientID, 
	c.accountnumber,
	p.FirstName + ' ' + p.LastName AS CName, 
	rp.PaymentDate, 
	cb.BatchDate, 
	comp.Name AS Company, 
	a.Name AS Agency, 
	et.Name AS FeeType, 
	- cp.Amount AS Amount, 
	r.Bounce AS Bounced, 
	r.Void AS Voided, 
	tblBouncedReasons.BouncedDescription, 
	CASE WHEN r.initialdraftyn = 1 THEN 'Yes' ELSE 'No' END AS InitialDraft, 
	ISNULL(vr.Amount, 0) AS VoidAmount, 
vr.Reason AS VoidReason
FROM         
	tblCommChargeback AS cp LEFT OUTER JOIN
	tblRegisterPayment AS rp ON rp.RegisterPaymentId = cp.RegisterPaymentID LEFT OUTER JOIN
	tblRegister AS r ON r.RegisterId = rp.FeeRegisterId LEFT OUTER JOIN
	tblClient AS c ON c.ClientID = r.ClientId LEFT OUTER JOIN
	tblEntryType AS et ON et.EntryTypeId = r.EntryTypeId LEFT OUTER JOIN
	tblAgency AS a ON a.AgencyID = c.AgencyID LEFT OUTER JOIN
	tblCompany AS comp ON comp.CompanyID = c.CompanyID INNER JOIN
	tblCommBatch AS cb ON cb.CommBatchID = cp.CommBatchID INNER JOIN
	tblCommStruct AS cs ON cs.CommStructID = cp.CommStructID INNER JOIN
	tblPerson AS p ON c.PrimaryPersonID = p.PersonID LEFT OUTER JOIN
	(SELECT 
		Value, 
		Amount, 
		Reason 
	FROM 
		tblTransactionAudit 
	WHERE 
		(Type = N'register')
	) AS vr ON r.RegisterId = vr.Value LEFT OUTER JOIN
	tblBouncedReasons ON r.BouncedReason = tblBouncedReasons.BouncedID
WHERE     
	(cp.CommBatchID IS NOT NULL) 
	--AND (cs.CommRecID = @recid)
	) as commTable
--where	BatchDate >=@startdate and BatchDate < @enddate
group by
	FeeType,
	Agency,
	Company,
	CName,
	Clientid,
Accountnumber,
	PaymentDate,
	Bounced, 
	Voided, 
	BouncedDescription, 
	InitialDraft, 
	VoidAmount, 
	VoidReason
GO
