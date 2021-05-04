IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getPipelines')
	BEGIN
		DROP  Procedure  stp_enrollment_getPipelines
	END
GO

create procedure stp_enrollment_getPipelines
(
	@UserId int = 0,
	@Manager bit = 0,
	@SearchStr varchar(100) = '%'
)
as
BEGIN
	-- pipelines are leads that have been assigned and are not closed(7)
	
	declare @PhoneSearchStr varchar(12), @days int, @excludestatuses varchar(50), @AgencyID int;
	
	select @AgencyID=AgencyID from tblUser where UserID = @UserID
	
	-- override
	if (@AgencyID < 1) begin
		set @Manager = 1; -- internal users can see all assigned leads
	end
	
	set @days = datediff(day,'3/1/12',getdate()) -- since restart
	
	if len(@SearchStr) > 2
		set @excludestatuses = '-1' -- none
	else
		set @excludestatuses = '7,8,9,10,12,14,17,19,22' -- Approved, DNQ, DNC, In Process, Declined, Bad, Recycled, Returned To Comp, Return to Atty
	
	select @PhoneSearchStr = replace(replace(replace(replace(@SearchStr,'(',''),')',''),' ',''),'-','')

	SELECT 
		  la.LeadApplicantID
		, la.LeadTransferInDate
		, case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName]
		, case when rtrim(ltrim(la.LeadPhone)) = '(   )    -' then la.HomePhone else la.LeadPhone end [HomePhone]
		, lc.TotalDebt
		, so.Name
		, st.Description
		, u.FirstName + ' ' + u.LastName AS AssignedTo
		, '' [LastContacted] -- date avail?
		, u.UserID [AssignedToID]
		, case 
			when lsa.completed is not null then '16x16_pdf.png'
			when lsa.leadapplicantid is not null then '16x16_pdf_grey.png'
			else 'spacer.gif' end [LSAImg]
		, case 
			when ver.completed is not null then '16x16_check.png'
			when ver.leadapplicantid is not null then '16x16_check_grey.png'
			else 'spacer.gif' end [VerImg]
		, isnull(la.EnrollmentPage, '') as EnrollmentPage
		, case when la.PublisherId is not null and la.created = la.lastmodified then 99 else 0 end [PublisherId]
		, case when la.RgrId is not null and la.created = la.lastmodified then 99 else 0 end [RgrId]
		, case when st.StatusID in (18,21) then 1 else 0 end [StatusWeight]
		, case when la.CreatedById is not null and la.created = la.lastmodified and la.CreatedById = 29 then 29 else 0 end [CreatedById]
	FROM tblLeadApplicant AS la 
		JOIN tblUser AS u ON la.RepID = u.UserID 
			and (u.UserID = @UserID or @Manager = 1)
		JOIN tblLeadProducts p on p.ProductID = la.ProductID
		JOIN tblLeadVendors v on v.VendorID = p.VendorID
			and ((v.Internal = 0 and v.AgencyID = @AgencyID) or (v.Internal = 1 and @AgencyID < 1))
		LEFT JOIN tblLeadCalculator lc on lc.LeadApplicantID = la.LeadApplicantID
		LEFT OUTER JOIN tblLeadStatus AS st ON la.StatusID = st.StatusID 
		LEFT OUTER JOIN tblLeadSources AS so ON la.LeadSourceID = so.LeadSourceID
		LEFT JOIN vw_enrollment_LSA_complete lsa on lsa.leadapplicantid = la.leadapplicantid
		LEFT JOIN vw_enrollment_Ver_complete ver on ver.leadapplicantid = la.leadapplicantid
	WHERE     
		la.StatusID NOT IN (select value from dbo.ufn_split(@excludestatuses,','))
		AND (la.FullName like @SearchStr 
				or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr 
				or replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
			)
		AND datediff(day,la.LeadTransferInDate,getdate()) < @days
	ORDER BY
		[StatusWeight] desc, la.LeadTransferInDate desc
		
END
GO