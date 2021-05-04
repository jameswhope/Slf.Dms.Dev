SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 05/06/2008
-- Description:	Insert values into tables for commission payouts
-- =============================================
--CREATE PROCEDURE stp_InsertCommishValues 
--	@ParentCommRecName VARCHAR(100),
--	@Percent int = 0,
--	@EntryType VARCHAR(100) = NULL,
--	@AgencyName VARCHAR(100),
--	@CompanyID INT = 0
--AS
--BEGIN
--	SET NOCOUNT ON;

-----This is for testing only comment out for production----*
	declare @AgencyName varchar(100)						 --*
	set @AgencyName = 'Lexxiom'               
	declare @CompanyID int										 --*
	set @CompanyID = 2											 --*	
--*****************************************--*

	DECLARE @AgencyID INT
	DECLARE @Delimeter CHAR(1)
	DECLARE @AllCommScens VARCHAR(MAX)
	DECLARE @AllCommStructs VARCHAR(MAX)
	DECLARE @AllEntryTypes VARCHAR(MAX)
	DECLARE @AllMissingFees VARCHAR(MAX)
	DECLARE @tblCommScens TABLE(CommScen VARCHAR(4))
	DECLARE @tblCommStructs TABLE(CommStruct VARCHAR(4))
	DECLARE @tblEntryTypes TABLE(EntryTypeCommFee VARCHAR(4))
	DECLARE @tblMissingFees TABLE(MissingFee VARCHAR(4))
	DECLARE @tblCommsPaidTo TABLE
	(
		CommStruct INT, 
		PaidBy INT, 
		[From] VARCHAR(75), 
		PaidTo INT, 
		[To] VARCHAR(75)
	)
	SET @Delimeter = ','
	
--Find the Agency ID
	SELECT @AgencyID = AgencyID
	FROM tblAgency 
	WHERE [name] like '%' + @AgencyName + '%'

--Does the Agency exist
	IF @AgencyID IS NULL
		BEGIN
			PRINT 'Agency does not exist.'
		END

--Find the Commission Scenario ID
	SELECT @AllCommScens = COALESCE(@AllCommScens + ',','') + CAST(CommScenID AS VARCHAR(4))
	FROM tblCommScen 
	WHERE AgencyID = @AgencyID

	INSERT INTO @tblCommScens(CommScen) SELECT Item FROM fnParseListToTable(@AllCommScens, @Delimeter)

--Find all CommStructIDs related to this CommScenID that currently exist.
	SELECT @AllCommStructs = COALESCE(@AllCommStructs + ',','') + CAST(CommStructID AS VARCHAR(4))
	FROM tblCommStruct
	WHERE CommScenID in (SELECT CAST(CommScen AS INT) FROM @tblCommScens) AND CompanyID = @CompanyID

	INSERT INTO @tblCommStructs(CommStruct) SELECT Item FROM fnParseListToTable(@AllCommStructs, @Delimeter)

--Find all Existing Fee EntryTypeIDs related to these CommStructIDs
	SELECT @AllEntryTypes = COALESCE(@AllEntryTypes +',','') + CAST(EntryTypeID AS VARCHAR(4))
	FROM tblCommFee
	WHERE CommStructID in (SELECT CAST(CommStruct AS INT) FROM @tblCommStructs)

	INSERT INTO @tblEntryTypes(EntryTypeCommFee) SELECT Item FROM fnParseListToTable(@AllEntryTypes, @Delimeter)

--Create a list of missing EntryTypes
	SELECT @AllMissingFees = COALESCE(@AllMissingFees +',','') + CAST(EntryTypeID AS VARCHAR(4)) 
	FROM tblEntryType et 
	WHERE et.Fee = 1 AND EntryTypeId NOT IN (SELECT EntryTypeCommFee FROM @tblEntryTypes)

	INSERT INTO @tblMissingFees(MissingFee) SELECT Item FROM fnParseListToTable(@AllMissingFees, @Delimeter)

--Insert the Fee Scenarios
	--Find all CommStructs, Pay order, CommRecs and Money From and To the Commission Recipients
		INSERT INTO @tblCommsPaidTo(CommStruct, PaidBy, [From], PaidTo, [To]) SELECT ct.Commstructid, ct.ParentCommRecID, cr1.Display, ct.CommRecID, cr2.Display 
		FROM tblcommStruct ct
		INNER JOIN tblcommRec cr1 ON ct.ParentCommRecID = cr1.CommRecID
		INNER JOIN tblCommRec cr2 ON ct.commrecid = cr2.commrecid
		WHERE ct.CommStructID IN (SELECT commstruct FROM @tblcommstructs)
		ORDER BY cr1.IsTrust DESC, ct.[Order] DESC

select * from @tblCommsPaidTo
	
--Default scenarios

	
	

--END
--GO