if exists (select * from sysobjects where name = 'stp_GetAgencyDetail')
	drop procedure stp_GetAgencyDetail
go

CREATE PROCEDURE [dbo].[stp_GetAgencyDetail] 
	-- Parameters for the stored procedure here only one
	@AgencyID int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Get the Agency table 0
	SELECT a.[Name],
		isnull(a.ImportAbbr, '') [ImportAbbr],
		a.UserID,
		a.Created,
        isnull(u1.UserName,'') [CreatedBy],
		a.LastModified,
		isnull(u2.UserName,'') [LastModifiedBy],
		isnull(a.CheckingSavings, '') [CheckingSavings],
		isnull(a.Contact1, '') [Contact1],
		isnull(a.Contact2, '') [Contact2],
		isnull(a.commercial, '') [Commercial],
		NULL, -- change this
		a.IsCommRec,
		NULL [PaidTo] -- change this
	FROM tblAgency a
	LEFT JOIN tblUser u1
	ON u1.UserID = a.CreatedBy
	LEFT JOIN tblUser u2
	ON u2.UserID = a.LastModifiedBy
	WHERE a.AgencyID = @AgencyID

	-- Get the AgencyAddress 1
	SELECT aa.AddressTypeID,
		isnull(aa.Address1, '') [Address1],
		isnull(aa.Address2,'') [Address2],
		isnull(aa.City, '') [City],
		isnull(aa.[State], '') [State],
		isnull(aa.ZipCode, '') [ZipCode],
		aa.AgencyID
	FROM tblAgencyAddress aa
	WHERE aa.AgencyID = @AgencyID
	
	-- Get the AgencyPhone 2
	SELECT ap.AgencyPhoneID,
		ap.AgencyId,
		ap.PhoneID
	FROM tblAgencyPhone ap
    WHERE ap.AgencyID = @AgencyID

	SELECT ap.PhoneID,
		aph.AreaCode,
		aph.Number,
		aph.PhoneTypeID,
		aph.PhoneID
	FROM tblAgencyPhone ap
	INNER JOIN tblPhone aph
	ON aph.PhoneID = ap.PhoneID
    WHERE ap.AgencyID = @AgencyID

	-- Get the ChildAgency 3
	SELECT a.AgencyID,
		isnull(a.[Name], '') [Name],
		isnull(a.ImportAbbr, '') [ImportAbbr],
		UserID,
		isnull(a.CheckingSavings, 'C') [CheckingSavings],
		isnull(a.Contact1, '') [Contact1],
		isnull(a.Contact2, '') [Contact2],
		@AgencyId [ParentAgency]
	FROM tblChildAgency c  
	inner join tblAgency a on (c.AgencyId = a.AgencyId )
	WHERE c.ParentAgencyId = @AgencyID
	
	-- Get the CommRec 4
	SELECT CommRecId, 
		CommRecTypeID,
		isnull(Abbreviation, '') [Abbreviation],
		isnull(Display, '') [Display],
		isnull(Method, '') [Method],
		isnull(BankName, '') [BankName],
		isnull(RoutingNumber, '') [RoutingNumber],
		isnull(AccountNumber, '') [AccountNumber],
		isnull(Type,'C') [Type],
		isnull(IsCommercial, 'False') [IsCommercial],
		isnull(IsLocked, 'False') [IsLocked],
		isnull(IsTrust, 'False') [IsTrust],
		CompanyID,
		AgencyID,
		AccountTypeID
	FROM tblCommRec
	WHERE AgencyID = @AgencyID
		
	-- Get the CommRecAddress 5
	SELECT a.CommRecAddressId, 
		a.CommRecID, 
		a.Contact1,
		isnull(a.Contact2, '') [Contact2],
		isnull(a.Address1, '') [Address1],
		isnull(a.Address2, '') [Address2],
		isnull(a.City, '') [City],
		isnull(a.[State], '') [State],
		isnull(a.ZipCode, '') [ZipCode]
	FROM tblCommRecAddress a
	INNER JOIN tblCommRec cr ON (cr.CommRecId = a.CommRecId)
	WHERE cr.AgencyID = @AgencyID 

	-- Get the CommRecPhone 6
	SELECT p.CommRecPhoneId, 
		p.CommRecID,
		p.PhoneNumber
	FROM tblCommRecPhone p
	INNER JOIN tblCommRec cr ON (cr.CommRecId = p.CommRecId)
	WHERE cr.AgencyID = @AgencyID 

	-- Get the Agent 8 (oops look down)
	SELECT t.AgentId, 
		t.AgencyID,
		isnull(t.FirstName, '') [FirstName],
		isnull(t.LastName, '') [LastName],
		isnull(t.Street, '') [Street],
		isnull(t.Street2, '') [Street2],
		isnull(t.City, '') [City],
		t.StateID,
		isnull(t.ZipCode, '') [ZipCode]
	FROM tblAgent t
	INNER JOIN tblAgencyAgent a ON (a.AgentId = t.AgentId)
	WHERE a.AgencyID = @AgencyID 

	-- Get the AgentPhone 7 (sorry about that)
	SELECT agp.AgentID,
		agp.PhoneID,
		tp.AreaCode,
		tp.Number,
		tp.PhoneTypeID
	FROM tblAgentPhone agp
	INNER JOIN tblPhone tp
	ON tp.phoneID = agp.AgentPhoneID
	WHERE agp.AgentID IN (SELECT AgentID FROM tblAgent WHERE AgencyID = @AgencyID)
END
GO