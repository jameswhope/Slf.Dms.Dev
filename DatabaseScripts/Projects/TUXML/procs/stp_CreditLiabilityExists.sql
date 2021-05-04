IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CreditLiabilityExists')
	BEGIN
		DROP  Procedure  stp_CreditLiabilityExists
	END

GO

CREATE Procedure stp_CreditLiabilityExists
@ReportId int,
@CreditLiabilityLookupId int,
@AccountNumber varchar(30),
@AccountType varchar(50),
@AccountStatus varchar(20),
@LoanType varchar(50),
@OriginalCreditor varchar(200),
@AccountOwnershipType varchar(50),
@UnpaidBalance money
AS
Select Count(CreditLiabilityId) as CT From tblcreditLiability
Where ReportId = @ReportId
and CreditLiabilityLookupId = @CreditLiabilityLookupId
and ((isnull(AccountNumber,'') =  isnull(@AccountNumber,'')) or (AccountNumber = @AccountNumber))
and (AccountType = @AccountType)
and (AccountStatus = @AccountStatus)
and (LoanType = @LoanType)
and ((isnull(OriginalCreditor,'') = isnull(@OriginalCreditor,'')) or (OriginalCreditor = @OriginalCreditor))
and ((isnull(AccountOwnershipType,'') = isnull(@AccountOwnershipType,'')) or (AccountOwnershipType = @AccountOwnershipType))
and (UnpaidBalance = @UnpaidBalance)

GO
 
