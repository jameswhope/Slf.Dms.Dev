IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_CreditLiabilitiesFiltered')
		DROP  view  vw_CreditLiabilitiesFiltered
GO

create view vw_CreditLiabilitiesFiltered
as

select a.leadapplicantid, l.*
from tblcreditliability l
join tblcreditsource s on s.reportid = l.reportid
join tblleadapplicant a on replace(a.ssn,'-','') = s.ssn
where l.unpaidbalance > 0 
and l.accounttype <> 'Mortgage' 
and l.loantype not in (
	'Automobile',
	'AutoLease',
	--'ReturnedCheck',
	'FamilySupport',
	'ChildSupport',
	'Business',
	'BusinessCreditCard',
	'ConventionalRealEstateMortgage',
	'Educational',
	'FHARealEstateMortgage',
	'GovernmentOverpayment',
	'GovernmentUnsecuredGuaranteeLoan',
	'HomeEquityLineOfCredit',
	'HomeImprovement',
	'HouseholdGoodsAndOtherCollateralAuto',
	'HouseholdGoodsSecured',
	'Lease',
	'MobileHome',
	'Mortgage',
	'PartiallySecured',
	'RealEstateJuniorLiens',
	'RealEstateMortgageWithoutOtherCollateral',
	'RealEstateSpecificTypeUnknown',
	'Secured',
	'SecuredHomeImprovement',
	'TimeSharedLoan'
	) 