
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DisbursementReport')
	BEGIN
		DROP  Procedure  stp_DisbursementReport
	END
GO 

CREATE PROCEDURE stp_DisbursementReport
(
	@UserID int
,	@StartDate datetime 
,	@EndDate datetime
,	@CompanyID int
)
AS
BEGIN

SELECT 
	FeeType, 
	Company, 
	Agency, 
	ClientID,
	CName,
	AccountNumber,
	BatchID,
	convert(varchar, PaymentDate, 110) as PaymentDate, 
	sum(Amount) as Amount,
	Bounced, 
	Voided, 
	BouncedDescription, 
	InitialDraft, 
	VoidAmount, 
	VoidReason 
FROM 
(
	SELECT 
		e.Name [FeeType]
	,	ShortCoName [Company]
	,	a.Name [Agency]
	,	c.ClientID
	,	p.FirstName + ' ' + p.LastName [CName]
	,	c.AccountNumber
	,	cp.CommBatchID [BatchID]
	,	rp.PaymentDate
	,	cp.Amount 
	,	r.Bounce [Bounced]
	,	r.Void [Voided]
	,	br.BouncedDescription
	,	(CASE WHEN r.InitialDraftYN = 1 THEN 'Yes' ELSE 'No' END) as InitialDraft
	,	ISNULL(vr.Amount, 0) as VoidAmount
	,	vr.Reason as VoidReason
	FROM 
		tblCommPay cp
		join tblcommbatch b on b.commbatchid = cp.commbatchid and b.batchdate between @StartDate and @EndDate  
		join tblcommstruct cs on cs.commstructid = cp.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
		join tblcompany comp on comp.companyid = uca.companyid
		join tblRegisterPayment rp on rp.RegisterPaymentID = cp.RegisterPaymentID 
		join tblRegister r on r.RegisterID = rp.FeeRegisterID 
		join tblEntryType e on e.EntryTypeID = r.EntryTypeID
		join tblClient c on c.ClientID = r.ClientID 
		join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto
		join tblAgency a on a.AgencyID = c.AgencyID
		join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = a.agencyid
		left join tblPerson p on p.PersonID = c.PrimaryPersonID
		left join tblBouncedReasons br on br.BouncedID = r.BouncedReason
		left outer join (SELECT [Value], Amount, Reason FROM tblTransactionAudit WHERE [Type] = 'register') as vr on r.RegisterId = vr.Value 

	UNION ALL 

	SELECT 
		e.Name [FeeType]
	,	ShortCoName [Company]
	,	a.Name [Agency]
	,	c.ClientID
	,	p.FirstName + ' ' + p.LastName [CName]
	,	c.AccountNumber
	,	cp.CommBatchID [BatchID]
	,	rp.PaymentDate
	,	-cp.Amount as Amount 
	,	r.Bounce [Bounced]
	,	r.Void [Voided]
	,	br.BouncedDescription
	,	(CASE WHEN r.InitialDraftYN = 1 THEN 'Yes' ELSE 'No' END) as InitialDraft
	,	ISNULL(vr.Amount, 0) as VoidAmount
	,	vr.Reason as VoidReason
	FROM 
		tblCommChargeback cp 
		join tblcommbatch b on b.commbatchid = cp.commbatchid and b.batchdate between @StartDate and @EndDate    
		join tblcommstruct cs on cs.commstructid = cp.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
		join tblcompany comp on comp.companyid = uca.companyid
		join tblRegisterPayment rp on rp.RegisterPaymentID = cp.RegisterPaymentID 
		join tblRegister r on r.RegisterID = rp.FeeRegisterID 
		join tblEntryType e on e.EntryTypeID = r.EntryTypeID
		join tblClient c on c.ClientID = r.ClientID 
		join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto
		join tblAgency a on a.AgencyID = c.AgencyID
		join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = a.agencyid
		left join tblPerson p on p.PersonID = c.PrimaryPersonID
		left join tblBouncedReasons br on br.BouncedID = r.BouncedReason
		left outer join (SELECT [Value], Amount, Reason FROM tblTransactionAudit WHERE [Type] = 'register') as vr on r.RegisterId = vr.Value 

) as derivedtable 

GROUP BY 
	FeeType,
	Company,
	Agency,
	CName,
	Clientid,
	Accountnumber,
	BatchID,
	PaymentDate,
	Bounced, 
	Voided, 
	BouncedDescription, 
	InitialDraft, 
	VoidAmount, 
	VoidReason
ORDER BY
	FeeType,
	Company,
	Agency,
	CName

END