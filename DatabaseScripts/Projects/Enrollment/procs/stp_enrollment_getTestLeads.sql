IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getTestLeads')
	BEGIN
		DROP  Procedure  stp_enrollment_getTestLeads
	END
GO

CREATE Procedure stp_enrollment_getTestLeads
(
	@userid int = 0, -- not needed
	@SearchStr varchar(100) = '%'
)
as
BEGIN
-- ** same as stp_enrollment_getLeads **

	-- everyone sees all available leads
	
	declare @PhoneSearchStr varchar(12), @days int
	
	if len(@SearchStr) > 1 
		set @days = -1500 -- 3+ yrs
	else
		set @days = -30
	
	select @PhoneSearchStr = replace(replace(replace(replace(@SearchStr,'(',''),')',''),' ',''),'-','')

	SELECT     
		  la.LeadApplicantID
		, la.LeadTransferInDate
		, case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName]
		, case when rtrim(ltrim(la.LeadPhone)) = '(   )    -' then la.HomePhone else la.LeadPhone end [HomePhone]
		, lc.TotalDebt
		, so.Name
		, st.Description
		, isnull(la.EnrollmentPage, '') as EnrollmentPage
		, case when la.rgrid is not null and la.created = la.lastmodified then 99 else 0 end [RgrId]
		, case when la.CreatedById is not null and la.created = la.lastmodified and la.CreatedById = 29 then 29 else 0 end [CreatedById]
		, la.ProductID
		, case when la.productid = 156 and la.statusid = 16 then 0 else 1 end [Seq]
	FROM 
		tblLeadApplicant la with(nolock)
	LEFT JOIN
		tblLeadCalculator lc with(nolock) on lc.LeadApplicantID = la.LeadApplicantID
	LEFT JOIN
		tblLeadHardship h with(nolock) on h.LeadApplicantID = la.LeadApplicantID
	LEFT OUTER JOIN		
		tblLeadStatus AS st with(nolock) ON la.StatusID = st.StatusID 
	LEFT OUTER JOIN	
		tblLeadSources AS so with(nolock) ON la.LeadSourceID = so.LeadSourceID
	WHERE     
		(la.RepID = 0 or la.RepID is null)
		AND (la.FullName like @SearchStr 
					or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr 
					or replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
					or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
					or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				)
		AND la.LeadTransferInDate > dateadd(day,@days,getdate())
		AND (h.BankAccount is null or h.BankAccount in ('checking','savings') or @days = -1500)
		AND la.productid in (160,161,162) -- Test product codes
	ORDER BY
		Seq, la.LeadTransferInDate desc
		
END  