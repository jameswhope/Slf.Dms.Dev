IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getLeads')
	BEGIN
		DROP  Procedure  stp_enrollment_getLeads
	END
GO

CREATE Procedure stp_enrollment_getLeads
(
	@UserID int,
	@SearchStr varchar(100) = '%'
)
as
BEGIN
	-- everyone sees all available leads
	
	declare @PhoneSearchStr varchar(12), @days int, @dropoffdays int, @AgencyID int;
	
	select @AgencyID=AgencyID from tblUser where UserID = @UserID
	
	if len(@SearchStr) > 2 begin
		set @days = datediff(day,'3/1/12',getdate()) -- since restart
		set @dropoffdays = @days
	end
	else begin
		set @days = 30 
		set @dropoffdays = 2
	end
	
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
		, dateadd(n,60,isnull(cm.lastcallmade,'1/1/2000')) [DialerRetryAfter]
	FROM 
		tblLeadApplicant la with(nolock)
	JOIN tblLeadProducts p on p.ProductID = la.ProductID
	JOIN tblLeadVendors v on v.VendorID = p.VendorID
		and ((v.Internal = 0 and v.AgencyID = @AgencyID) or (v.Internal = 1 and @AgencyID < 1))
	LEFT JOIN
		tblLeadCalculator lc with(nolock) on lc.LeadApplicantID = la.LeadApplicantID
	LEFT JOIN
		tblLeadHardship h with(nolock) on h.LeadApplicantID = la.LeadApplicantID
	LEFT OUTER JOIN		
		tblLeadStatus AS st with(nolock) ON la.StatusID = st.StatusID 
	LEFT OUTER JOIN	
		tblLeadSources AS so with(nolock) ON la.LeadSourceID = so.LeadSourceID
	left join 
		vw_enrollment_CallsMade cm on cm.LeadApplicantID = la.LeadApplicantID
	WHERE     
		(la.RepID = 0 or la.RepID is null)
		AND (la.FullName like @SearchStr 
					or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr 
					or replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
					or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
					or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				)
		AND datediff(day,la.LeadTransferInDate,getdate()) < @days
		--and not (datediff(day,la.LeadTransferInDate,getdate()) > @dropoffdays and la.statusid in (8,12,14)) -- drop off does not qualify, declined, bad lead after 2 days
	ORDER BY
		Seq, la.LeadTransferInDate desc
		
END 