SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 05/06/2008
-- Description:	Insert values into tables for commission payouts
-- =============================================
CREATE PROCEDURE stp_InsertCommishValues 
	@Percent INT = 0,
	@EntryTypeID INT = 0,
	@AgencyName VARCHAR(100) = NULL,
	@FromAgencyName VARCHAR(100) = NULL,
	@ToAgencyName VARCHAR(100) = NULL,
	@CompanyID INT
AS
BEGIN
	SET NOCOUNT ON;

----This is for testing only comment out for production----*
--	declare @EntryTypeID INT							 --*
--	set @EntryTypeID = 2
--	declare @AgencyName varchar(100)					 --*
--	set @AgencyName = 'Epic'               
--	declare @CompanyID int								 --*
--	set @CompanyID = 2									 	
--*******************************************************--*

	DECLARE @AgencyID INT
	DECLARE @Delimeter CHAR(1)
	DECLARE @DefaultScenario INT
	DECLARE @EntryType INT
	DECLARE @CommStruct INT
	DECLARE @DefaultStructures VARCHAR(MAX)
	DECLARE @DefaultFees VARCHAR(MAX)
	DECLARE @IsEntryTypeValid BIT
	DECLARE @IsCommRecValid BIT
	DECLARE @IsPayerValid BIT
	DECLARE @AllCommScens VARCHAR(MAX)
	DECLARE @AllCommStructs VARCHAR(MAX)
	DECLARE @AllEntryTypes VARCHAR(MAX)
	DECLARE @AllMissingFees VARCHAR(MAX)
	DECLARE @AllCommRecs VARCHAR(MAX)
	DECLARE @tblCommScens TABLE(CommScen VARCHAR(4))
	DECLARE @tblCommStructs TABLE(CommStruct VARCHAR(4))
	DECLARE @tblCommRecs TABLE(CommRec VARCHAR(4))
	DECLARE @tblDefaultStructures TABLE(CommStruct VARCHAR(4))
	DECLARE @tblDefaultFees TABLE(CommStruct VARCHAR(4), EntryType VARCHAR(4))
	DECLARE @tblEntryTypes TABLE(EntryTypeCommFee VARCHAR(4))
	DECLARE @tblMissingFees TABLE(MissingFee VARCHAR(4))
	DECLARE @tblCommsPaidTo TABLE
	(
		CommStruct INT, 
		PaidBy INT, 
		[From] VARCHAR(75), 
		PaidTo INT, 
		[To] VARCHAR(75),
		FeeType VARCHAR(100),
		EntryType INT,
		[Percent] Money,
		[PayOrder] INT
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

	INSERT INTO @tblCommScens(CommScen) SELECT DISTINCT(Item) FROM fnParseListToTable(@AllCommScens, @Delimeter)

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
	SELECT @IsEntryTypeValid = MissingFee FROM @tblMissingFees WHERE MissingFee = @EntryTypeID

--Create a list of CommRecs associated with this CommScen
	SELECT @AllCommRecs = COALESCE(@AllCommRecs +',','') + CAST(CommRecID AS VARCHAR(4)) 
	FROM tblCommStruct ct
	WHERE ct.CommStructID in (SELECT CommStruct FROM @tblCommStructs)

	INSERT INTO @tblCommRecs(CommRec) SELECT DISTINCT(Item) FROM fnParseListToTable(@AllCommRecs, @Delimeter)
	SET @AllCommRecs = NULL

--Create the parent commrecs with no corresponding commrecid in this table
	SELECT @AllCommRecs = COALESCE(@AllCommRecs +',','') + CAST(ParentCommRecID AS VARCHAR(4)) 
	FROM tblCommStruct ct
	WHERE ct.CommStructID IN (SELECT CommStruct FROM @tblCommStructs)

	INSERT INTO @tblCommRecs(CommRec) 
	SELECT ParentCommRecID 
	FROM tblCommStruct	
	WHERE ParentCommRecID NOT IN (SELECT CommRec FROM @tblCommRecs)
	AND CommStructID IN (SELECT CommStruct FROM @tblCommStructs)

--Create the current Fee Scenarios
	--Find all CommStructs, Pay order, CommRecs and Percents From and To the Commission Recipients
		INSERT INTO @tblCommsPaidTo(CommStruct, PaidBy, [From], PaidTo, [To], FeeType, EntryType, [Percent], PayOrder) 
		SELECT ct.Commstructid, ct.ParentCommRecID, cr1.Display, ct.CommRecID, cr2.Display, et.DisplayName, et.EntryTypeId, cf.[Percent], ct.[order] 
		FROM tblcommStruct ct
		INNER JOIN tblcommRec cr1 ON ct.ParentCommRecID = cr1.CommRecID
		INNER JOIN tblCommRec cr2 ON ct.commrecid = cr2.commrecid
		INNER JOIN tblCommFee cf ON cf.CommStructID = ct.CommStructID
		INNER JOIN tblEntryType et ON et.EntryTypeId = cf.EntryTypeID
		WHERE ct.CommStructID IN (SELECT commstruct FROM @tblcommstructs)
		ORDER BY cr1.IsTrust DESC, et.EntryTypeId, ct.[Order] DESC

--Get Default information
	--Scenario
	SET @DefaultScenario = 10
	
	--Structures
	SELECT @DefaultStructures = COALESCE(@DefaultStructures +',','') + CAST(CommStructID AS VARCHAR(4)) 
	FROM tblCommStruct ct
	WHERE ct.CommScenID = @DefaultScenario

	INSERT INTO @tblDefaultStructures(CommStruct) SELECT DISTINCT(Item) FROM fnParseListToTable(@DefaultStructures, @Delimeter)

	--CommFee Entrie Types
	SELECT @DefaultFees = COALESCE(@DefaultFees +',','') + CAST(EntryTypeID AS VARCHAR(4)) 
	FROM tblCommFee cf
	WHERE cf.CommStructID in (SELECT DISTINCT(CommStruct) FROM @tblDefaultStructures)

	INSERT INTO @tblDefaultFees(EntryType) SELECT DISTINCT(Item) FROM fnParseListToTable(@DefaultFees, @Delimeter)

	--Loop through the fees and scenarios to make sure they are all in the table if any are missing insert them
	--DECLARE c_DefaultStructures CURSOR LOCAL FAST_FORWARD FOR
	--SELECT CommStruct FROM @tblDefaultStructures
	--OPEN c_DefaultStructures
	--FETCH NEXT FROM c_DefaultStructures INTO @CommStruct
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
			DECLARE c_DefaultFees CURSOR LOCAL FAST_FORWARD FOR
			SELECT EntryType FROM @tblDefaultFees
			OPEN c_DefaultFees
				FETCH NEXT FROM c_DefaultFees INTO @EntryType
				WHILE @@FETCH_STATUS = 0
				BEGIN
					--Does this Entry type exist for these CommStructs
					SELECT @IsEntryTypeValid = EntryTypeID 
					FROM tblCommFee 
					WHERE EntryTypeID = @EntryType AND (CommStructID = 117 OR CommStructID = 118)
					--If nothing came back we need to put the entry type in the database
					IF @IsEntryTypeValid IS NULL
						BEGIN
							IF @EntryType < 20
								BEGIN
									EXEC stp_InsertDefaultFees @EntryType, 118
								END
							IF @EntryType > 19
								BEGIN
									EXEC stp_InsertDefaultFees @EntryType, 117
								END
						END
					SET @IsEntryTypeValid = NULL
				FETCH NEXT FROM c_DefaultFees INTO @EntryType
				END
			CLOSE c_DefaultFees
			DEALLOCATE c_DefaultFees
	--FETCH NEXT FROM c_DefaultStructures INTO @CommStruct
	--END
	--CLOSE c_DefaultStructures
	--DEALLOCATE c_DefaultStructures

--Who are the commission recipients for this scenario
	SELECT @IsCommRecValid = PaidTo FROM @tblCommsPaidTo WHERE [To] NOT IN (SELECT CommRec FROM @tblCommRecs) 

	IF @IsCommRecValid IS NOT NULL
		BEGIN
			Print 'Commission recipient is already part of the scenario.'
		END

	--Make sure this fee type is valid and not already in the scenario
	SELECT @IsEntryTypeValid = EntryTypeCommFee FROM @tblEntryTypes WHERE EntryTypeCommFee = @EntryTypeID
	IF @IsEntryTypeValid IS NOT NULL
		BEGIN
			Print 'Entry type is already part of the scenario.'
		END
END
GO