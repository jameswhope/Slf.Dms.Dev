IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAgencyCommissionDetail')
	BEGIN
		DROP  Procedure  stp_GetAgencyCommissionDetail
	END

GO

CREATE Procedure stp_GetAgencyCommissionDetail
(
	@AgencyId int
)
AS
BEGIN
	--Get Commission Structure Table
	SELECT Distinct
		cs.CommStructID as [CommStructId],
		cr.CommRecId as [CommRecId],
		cs.ParentCommRecId as [ParentCommRecId],
		cr.Display + ' ('+ cr.Abbreviation + ')' as [Recipient],
		a.AgencyId as [AgencyId],
		a.Name as [AgencyName],
		cr.AgencyId as [RecipientAgencyId],
		sce.CommScenID as [CommScenId],
		sce.Seq as [ScenarioSequence],
		sce.StartDate as [StartDate],
		sce.EndDate as [EndDate],
		cr.IsTrust as [IsTrust],
		cs.CompanyId as [CompanyId],
		c.[Name] as [CompanyName],
		a.IsCommRec as [IsCommRec]
	FROM
		tblCommStruct cs
		inner join tblCommRec cr on (cs.CommRecId = cr.CommRecId)
		inner join tblCommScen sce on (cs.CommScenId = sce.CommScenId)
		inner join tblAgency a on (a.AgencyId = sce.AgencyId)
		inner join tblCompany c on (cs.CompanyId = c.CompanyId)
	WHERE
		a.agencyid = @AgencyId
	--Get Fees	
	SELECT
		cf.CommStructID as [CommStructId],
		et.EntryTypeID as [EntryTypeId],
		et.DisplayName as [FeeName],
		cf.[Percent] as [Percent],
		et.[Order] as [Order]
	FROM
		tblCommFee cf
		inner join tblEntryType  et on (et.EntryTypeID = cf.EntryTypeID)
		inner join
		(SELECT 
			cs.CommStructID as [CommStructId]
		FROM
			tblCommStruct cs
			inner join tblCommRec cr on (cs.CommRecId = cr.CommRecId)
			inner join tblCommScen sce on (cs.CommScenId = sce.CommScenId)
			inner join tblAgency a on (a.AgencyId = sce.AgencyId)
		WHERE
			a.agencyid = @AgencyId
		) c on (c.CommStructId = cf.CommStructId)
	Order By cf.CommStructId, et.[Order] 
	
	
END


GO



