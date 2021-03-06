IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AgencyBatchSummary')
	BEGIN
		DROP  Procedure  stp_AgencyBatchSummary
	END

GO

create procedure stp_AgencyBatchSummary
(
	@UserID int,
	@CompanyID int = -1
)
as
begin
/*
	Logic based off stp_ReportGetCommissionBatchTransfers. This proc will replace 
	stp_ReportGetAgencyCommission and is used used when displaying the Agency Batches summary 
	on the agency home page. New proc allows client filtering by creation date.

	12.15.08
	Joins streamlined to match other procs used on the agency portal interface so that all are pulling
	the same results.
	
	01.06.09
	Join to tblUserClientAccess to filter by client created.
	
	01/23/09
	Optional filtering by company id
	
	02/05/09
	Join to tblUserAgencyAccess
*/

declare @vtblCal table (BatchDate datetime)
declare @minBatchDate datetime;

-- fill calendar
with mycte as
(
select cast('1/1/' + cast(year(getdate()) as varchar) as datetime) DateValue
union all
select DateValue + 1
from    mycte    
where   DateValue + 1 < getdate()
)

insert into @vtblCal
select  top 5 DateValue
from    mycte
where CONVERT(BIT, CASE WHEN datepart(dw, DateValue) IN (1,7) THEN 0 ELSE 1 END) = 1 and datevalue < getdate() order by datevalue desc
OPTION  (MAXRECURSION 0)

select @minBatchDate = min(BatchDate)
from @vtblCal


SELECT 
	CommBatchID
,	BatchDate
,	sum(Amount) as Amount 
,	CommRecID
,	CommRec
,	Company
FROM 
(
	SELECT 
		cp.CommBatchID
	,	b.BatchDate
	,	cp.Amount 
	,	cr.CommRecID
	,	cr.Display [CommRec]
	,	ShortCoName [Company]
	FROM 
		tblCommPay cp
		join tblcommbatch b on b.commbatchid = cp.commbatchid and b.batchdate >= @minBatchDate  
		join tblcommstruct cs on cs.commstructid = cp.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
		join tblcompany comp on comp.companyid = uca.companyid
		join tblCommRec cr on cr.CommRecID = cs.CommRecID
		join tblRegisterPayment rp on rp.RegisterPaymentID = cp.RegisterPaymentID 
		join tblRegister r on r.RegisterID = rp.FeeRegisterID 
		join tblClient c on c.ClientID = r.ClientID 
		join tbluserclientaccess uc on uc.userid = uca.userid and c.Created between uc.ClientCreatedFrom and uc.ClientCreatedTo
		join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = c.agencyid

	UNION ALL 

	SELECT 
		cp.CommBatchID
	,	b.BatchDate
	,	-cp.Amount as Amount 
	,	cr.CommRecID
	,	cr.Display [CommRec]
	,	ShortCoName [Company]
	FROM 
		tblCommChargeback cp 
		join tblcommbatch b on b.commbatchid = cp.commbatchid and b.batchdate >= @minBatchDate  
		join tblcommstruct cs on cs.commstructid = cp.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
		join tblcompany comp on comp.companyid = uca.companyid
		join tblCommRec cr on cr.CommRecID = cs.CommRecID
		join tblRegisterPayment rp on rp.RegisterPaymentID = cp.RegisterPaymentID 
		join tblRegister r on r.RegisterID = rp.FeeRegisterID 
		join tblClient c on c.ClientID = r.ClientID 
		join tbluserclientaccess uc on uc.userid = uca.userid and c.Created between uc.ClientCreatedFrom and uc.ClientCreatedTo
		join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = c.agencyid

) as derivedtable 

GROUP BY 
	CommBatchID
,	BatchDate
,	CommRecID
,	CommRec
,	Company
ORDER BY 
	CommBatchID desc, CommRec


end