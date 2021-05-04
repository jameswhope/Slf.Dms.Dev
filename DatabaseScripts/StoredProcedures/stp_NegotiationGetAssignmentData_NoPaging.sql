IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationGetAssignmentData_NoPaging')
	BEGIN
		DROP  Procedure  stp_NegotiationGetAssignmentData_NoPaging
	END

GO

CREATE procedure [dbo].[stp_NegotiationGetAssignmentData_NoPaging]
(
	@userid int
)
as

declare @sqlTxt varchar(max)
declare @sqlFilters as varchar(max)
declare @DisplayColumns varchar(max)
declare @vtblFilters table
	(
		ClientID int,AccountID int,SSN varchar(50),ApplicantFullName varchar(101),ApplicantLastName varchar(50),ApplicantFirstName varchar(50),
		ApplicantState varchar(50),ApplicantCity varchar(50),ApplicantZipCode varchar(50),SDAAccount varchar(50),FundsAvailable money,
		OriginalCreditor varchar(50),CurrentCreditor varchar(50),CurrentCreditorState varchar(50),CurrentCreditorAccountNumber varchar(30),
		LeastDebtAmount money,CurrentAmount money,AccountStatus varchar(255),AccountAge int,ClientAge int,LastSettled int,NextDepositDate datetime,
		NextDepositAmount money,LastOffer datetime,OfferDirection varchar(50)
	)
DECLARE filterCursor CURSOR READ_ONLY FAST_FORWARD FOR 
SELECT nf.AggregateClause FROM  tblNegotiationFilters AS nf INNER JOIN tblNegotiationFilterXref AS fx ON nf.FilterId = fx.FilterId 
where fx.deleted = 0 and fx.filterid in (SELECT isnull(FilterID, 0) as FilterID FROM tblNegotiationFilterXref WHERE Deleted = 0 and EntityID in (Select top 1 NegotiationEntityID from tblNegotiationEntity where UserID = @userid))

OPEN filterCursor
	FETCH NEXT FROM filterCursor
	INTO @sqlFilters

	WHILE @@FETCH_STATUS = 0
		BEGIN
			insert into @vtblFilters
			exec('select ClientID ,AccountID ,SSN ,ApplicantFullName ,ApplicantLastName ,ApplicantFirstName ,ApplicantState ,
			ApplicantCity ,ApplicantZipCode ,SDAAccount ,FundsAvailable ,OriginalCreditor ,CurrentCreditor ,CurrentCreditorState ,
			CurrentCreditorAccountNumber ,LeastDebtAmount ,CurrentAmount ,AccountStatus ,AccountAge ,ClientAge ,LastSettled ,NextDepositDate ,
			NextDepositAmount ,LastOffer ,OfferDirection from vwNegotiationDistributionSource where ' + @sqlFilters)

			FETCH NEXT FROM filterCursor
			INTO @sqlFilters
		END

CLOSE filterCursor
DEALLOCATE filterCursor

SELECT distinct ClientID ,AccountID ,SSN ,ApplicantFullName ,ApplicantLastName ,ApplicantFirstName ,ApplicantState ,ApplicantCity ,ApplicantZipCode ,SDAAccount ,FundsAvailable ,OriginalCreditor ,CurrentCreditor ,CurrentCreditorState ,CurrentCreditorAccountNumber ,LeastDebtAmount ,CurrentAmount ,AccountStatus ,AccountAge ,ClientAge ,LastSettled ,NextDepositDate ,NextDepositAmount ,LastOffer ,OfferDirection  
FROM @vtblFilters Order By LastOffer desc


GRANT EXEC ON stp_NegotiationGetAssignmentData_NoPaging TO PUBLIC

