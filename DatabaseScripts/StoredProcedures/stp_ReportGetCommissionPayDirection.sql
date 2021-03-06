/****** Object:  StoredProcedure [dbo].[stp_ReportGetCommissionPayDirection]    Script Date: 11/19/2007 15:27:43 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'stp_ReportGetCommissionPayDirection')
	DROP PROCEDURE [dbo].[stp_ReportGetCommissionPayDirection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[stp_ReportGetCommissionPayDirection]
(
	@companyid int,
	@date datetime = null
)

as

if @date is null
begin
	set @date = getdate()
end

SELECT
	cs.CommStructID,
	cr.CommRecId,
	cs.ParentCommRecId,
	cr.Display + ' ('+ cr.Abbreviation + ')' as CommRec,
	a.AgencyId,
	a.Name as Agency,
	ft.EntryTypeID,
	ft.Name,
	ft.[Percent],
	sce.CommScenID,
	cr.IsTrust
FROM
	tblCommStruct as cs
	inner join tblCommRec as cr on cs.CommRecId = cr.CommRecId
	inner join tblCommScen as sce on cs.CommScenId = sce.CommScenId
	inner join tblAgency as a on a.AgencyId = sce.AgencyId
	inner join
	(
		SELECT
			cf.CommStructID,
			et.EntryTypeID,
			et.DisplayName as [Name],
			cf.[Percent],
			et.[Order]
		FROM
			tblCommFee as cf
			inner join tblEntryType as et on et.EntryTypeID = cf.EntryTypeID
	) as ft on ft.CommStructID = cs.CommStructID
WHERE
	sce.StartDate < @date
	and
	(
		sce.EndDate > @date
		or sce.EndDate is null
	)
	and cs.CompanyID = @companyid
ORDER BY
	ft.[Order]
GO
