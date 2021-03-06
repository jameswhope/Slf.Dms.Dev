/****** Object:  StoredProcedure [dbo].[stp_GetAgencyDetail]    Script Date: 01/09/2008 12:25:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_GetAgencyDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_GetAgencyDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_GetAgencyDetail]    Script Date: 01/09/2008 12:25:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_GetAgencyDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Jim Hope
-- Create date: 12/19/2007
-- Description:	Agency detail
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetAgencyDetail] 
	-- Parameters for the stored procedure here only one
	@AgencyID int = -1,
	@UserID int = -1 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Get the Agency table 0
	SELECT a.[Name],
		isnull(a.ImportAbbr, '''') [ImportAbbr],
		a.UserID,
		a.Created,
        isnull(u1.UserName,'''') [CreatedBy],
		a.LastModified,
		isnull(u2.UserName,'''') [LastModifiedBy],
		isnull(a.CheckingSavings, '''') [CheckingSavings],
		isnull(a.Contact1, '''') [Contact1],
		isnull(a.Contact2, '''') [Contact2],
		isnull(a.commercial, '''') [Commercial],
		a.ParentAgency,
		a.IsCommRec,
		a1.[Name] as ''PaidTo''
	FROM tblAgency a
	LEFT JOIN tblUser u1
	ON u1.UserID = a.CreatedBy
	LEFT JOIN tblUser u2
	ON u2.UserID = a.LastModifiedBy
	LEFT JOIN tblAgency a1
	on a1.agencyid = a.parentagency
	WHERE a.AgencyID = @AgencyID

	-- Get the AgencyAddress 1
	SELECT aa.AddressTypeID,
		isnull(aa.Address1, '''') [Address1],
		isnull(aa.Address2,'''') [Address2],
		isnull(aa.City, '''') [City],
		isnull(aa.[State], '''') [State],
		isnull(aa.ZipCode, '''') [ZipCode],
		aa.AgencyID
	FROM tblAgencyAddresses aa
	WHERE aa.AgencyID = @AgencyID

	-- Get the AgencyPhone 2
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
	SELECT AgencyID,
		isnull([Name], '''') [Name],
		isnull(ImportAbbr, '''') [ImportAbbr],
		UserID,
		isnull(CheckingSavings, ''C'') [CheckingSavings],
		isnull(Contact1, '''') [Contact1],
		isnull(Contact2, '''') [Contact2],
		ParentAgency
	FROM tblAgency
	WHERE ParentAgency = @AgencyID
	
	-- Get the CommRec 4
	SELECT CommRecTypeID,
		isnull(Abbreviation, '''') [Abbreviation],
		isnull(Display, '''') [Display],
		isnull(Method, '''') [Method],
		isnull(BankName, '''') [BankName],
		isnull(RoutingNumber, '''') [RoutingNumber],
		isnull(AccountNumber, '''') [AccountNumber],
		isnull(Type,''C'') [Type],
		isnull(IsCommercial, ''False'') [IsCommercial],
		isnull(IsLocked, ''False'') [IsLocked],
		isnull(IsTrust, ''False'') [IsTrust],
		CompanyID,
		AgencyID,
		AccountTypeID
	FROM tblCommRec
	WHERE AgencyID = @AgencyID
		
	-- Get the CommRecAddress 5
	SELECT Contact1,
		isnull(Contact2, '''') [Contact2],
		isnull(Address1, '''') [Address1],
		isnull(Address2, '''') [Address2],
		isnull(City, '''') [City],
		isnull([State], '''') [State],
		isnull(ZipCode, '''') [ZipCode]
	FROM tblCommRecAddress
	WHERE CommRecID = (SELECT CommRecID FROM tblCommRec WHERE AgencyID = @AgencyID)

	-- Get the CommRecPhone 6
	SELECT CommRecID,
		PhoneNumber
	FROM tblCommRecPhone
	WHERE CommRecID = (SELECT CommRecID FROM tblCommRec WHERE AgencyID = @AgencyID)

	-- Get the Agent 8 (oops look down)
	SELECT AgencyID,
		isnull(FirstName, '''') [FirstName],
		isnull(LastName, '''') [LastName],
		isnull(Street, '''') [Street],
		isnull(Street2, '''') [Street2],
		isnull(City, '''') [City],
		StateID,
		isnull(ZipCode, '''') [ZipCode]
	FROM tblAgent
	WHERE AgencyID = @AgencyID 

	-- Get the AgentPhone 7 (sorry about that)
	SELECT agp.AgentID,
		agp.PhoneID,
		tp.AreaCode,
		tp.Number,
		tp.PhoneTypeID
	FROM tblAgentPhone agp
	INNER JOIN tblPhone tp
	ON tp.phoneID = agp.AgentPhoneID
	WHERE agp.AgentID = (SELECT AgentID FROM tblAgent WHERE AgencyID = @AgencyID)
END
' 
END
GO
