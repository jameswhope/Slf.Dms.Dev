-- not in use

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getLeads2')
	BEGIN
		DROP  Procedure  stp_enrollment_getLeads2
	END
GO

CREATE Procedure stp_enrollment_getLeads2
(
	@SearchStr varchar(100) = '%',
	@StartRowIndex int,
	@PageSize int
)
as
BEGIN
	-- everyone sees all available leads
	
	declare @PhoneSearchStr varchar(12)
	
	select @PhoneSearchStr = replace(replace(replace(replace(@SearchStr,'(',''),')',''),' ',''),'-','')
	
	set @StartRowIndex = @StartRowIndex + 1


	select * from (
		SELECT     
			  la.LeadApplicantID
			, la.LeadTransferInDate
			, case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName]
			, case when rtrim(ltrim(la.LeadPhone)) = '(   )    -' then la.HomePhone else la.LeadPhone end [HomePhone]
			, lc.TotalDebt
			, so.Name
			, st.Description
			, ROW_NUMBER() OVER(order by la.LeadTransferInDate) as RowNum
		FROM 
			tblLeadApplicant la 
		LEFT JOIN
			tblLeadCalculator lc on lc.LeadApplicantID = la.LeadApplicantID
		LEFT OUTER JOIN		
			tblLeadStatus AS st ON la.StatusID = st.StatusID 
		LEFT OUTER JOIN	
			tblLeadSources AS so ON la.LeadSourceID = so.LeadSourceID
		WHERE     
			la.RepID = 0 
			AND (la.FullName like @SearchStr 
					or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr 
					or replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
					or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
					or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				)
	) d
	where RowNum between @StartRowIndex and (@StartRowIndex + @PageSize) - 1
	
	
	-- get the total # of records this query returns
	SELECT     
		count(*)
	FROM 
		tblLeadApplicant la 
	LEFT JOIN
		tblLeadCalculator lc on lc.LeadApplicantID = la.LeadApplicantID
	LEFT OUTER JOIN		
		tblLeadStatus AS st ON la.StatusID = st.StatusID 
	LEFT OUTER JOIN	
		tblLeadSources AS so ON la.LeadSourceID = so.LeadSourceID
	WHERE     
		la.RepID = 0 
		AND (la.FullName like @SearchStr 
				or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr 
				or replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
				or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @PhoneSearchStr
			)

	
END
GO