IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetClientIntakeInfo')
	BEGIN
		DROP  Procedure  stp_GetClientIntakeInfo
	END

GO

CREATE procedure [dbo].[stp_GetClientIntakeInfo]
@AccoutnID  bigint
As
Begin
select [FirmAccount#] = cif.AccountID,  [Litigation Document]=LitigationDocument,
[Date Client Received Document]=convert(varchar,ClientDocReceivedDate,110), [How Documents Received]=HowDocReceived,
[Is plaintiff a collection company?]=case isplaintiffcompany when 1 then 'Yes' when 0 then 'No' else '' end,
[Do you dispute the amount?]=case isamountdispute when 1 then 'Yes' when 0 then 'No' else '' end,
[Amount]=Amount,
[Do you own any real estate?]=case isrealestateowner when 1 then 'Yes' when 0 then 'No' else '' end,
[is this your primary residence1?]=case isresidenceofpropertyone  when 1 then 'Yes' when 0 then 'No' else '' end,
[How long have you owned it1?]=durationownerdpropertyone,
[Approximate fair market value1]= Convert(varchar,Convert(money,AppMarketvalpropertyone ),1),--AppMarketvalpropertyone,
[What is the payoff1]=Convert(varchar,Convert(money,payoffpropertyone ),1),--payoffpropertyone,
[Any liens on property1]=case Liensonpropertyone when 1 then 'Yes' else 'No' end ,
[Mortgage Payment1]=Convert(varchar,Convert(money,Totalequitypropertyone ),1),--Totalequitypropertyone,
[Are you current on house payments1]=Housepaymentspropertyone,
[How many people live there1]=peoplelivepropertyone,
[Is this a rental property1?]=case IsRentalPropertyOne  when 1 then 'Yes' when 0 then 'No' else '' end,
[How much is the rent1?]=Convert(varchar,Convert(money,RentOnPropertyOne ),1),--RentOnPropertyOne,
[is this your primary residence2?]=case isresidenceofpropertytwo  when 1 then 'Yes' when 0 then 'No' else '' end,
[How long have you owned it2?]=durationownerdpropertytwo,
[Approximate fair market value2]=Convert(varchar,Convert(money,AppMarketvalpropertytwo ),1),--AppMarketvalpropertytwo,
[What is the payoff2]=Convert(varchar,Convert(money,payoffpropertytwo ),1),--payoffpropertytwo,
[Any liens on property2]=case Liensonpropertytwo when 1 then 'Yes' else 'No' end ,
[Mortgage Payment2]=Convert(varchar,Convert(money,Totalequitypropertytwo ),1),--Totalequitypropertytwo,
[Are you current on house payments2]=Housepaymentspropertytwo,
[How many people live there2]=peoplelivepropertytwo,
[Is this a rental property2?]=case IsRentalPropertyTwo  when 1 then 'Yes' when 0 then 'No' else '' end,
[How much is the rent2?]=Convert(varchar,Convert(money,RentOnPropertyTwo ),1),--RentOnPropertyTwo,
[Are you employed?]=case Iscurrentlyworking when 1 then 'Yes' when 0 then 'No' else '' end,
[Are you self employed?]=case IsSelfEmployed when 1 then 'Yes' when 0 then 'No' else '' end,
[Employer/Company]=employername,
[Length of the current employment]= cast(cast(currentemployerduration /12 as int) as varchar) +' years ' + cast(cast(currentemployerduration %12 as int) as varchar)+' months',
[Take home pay]=Convert(varchar,Convert(money,takehomepay ),1),--takehomepay,
[Per]=per,
[Any other wage garnishments]=otherwage,
[Other sources of income]=otherincomesource,
[Receiving any type of Aid?]=case isreceivingaid when 1 then 'Yes' when 0 then 'No' else '' end,
[Type of Aid?]=typeofaid,
[Do you have bank accounts?]=case haveBankAccs when 1 then 'Yes' when 0 then 'No' else '' end,
[Name of the bank1]=bankaccone,
[Source of money deposited in account1]=BankAmtsourceaccone,
[Approximate balance in account1]=Convert(varchar,Convert(money,AppBalanceaccone ),1),--AppBalanceaccone,
[Account Type1]=case AccTypeOne when 1 then 'Checking' when 2 then 'Saving' when 3 then ' Others' end,
[Name of the bank2]=bankacctwo,
[Source of money deposited in account2]=BankAmtsourceacctwo,
[Approximate balance in account2]=Convert(varchar,Convert(money,AppBalanceacctwo ),1),--AppBalanceacctwo,
[Account Type2]=case AccTypeTwo when 1 then 'Checking' when 2 then 'Saving' when 3 then ' Others' end,
[Do you have other assets?]=case haveOtherAssets when 1 then 'Yes' when 0 then 'No' else '' end,
[Assets]=Assets ,
[Client declined additional legal services?]=case declinedlegalservices when 1 then 'Yes' when 0 then 'No' else '' end,
[Client sent to local counsel?]=case sentlocalcounsel when 1 then 'Yes' when 0 then 'No' else '' end,
[Note]=notes,
[Verified]=case isverified when 1 then 'Yes' when 0 then 'No' else '' end,
[VerifiedDate]=verifieddate,
[VerifiedBy]=(select FirstName +' '+isnull(lastname,'') from tbluser where userid=cif.VerifiedBy),
[LegalServicesClient]=(select FirstName +' '+isnull(lastname,'') from tbluser where userid=LegalServicesClientID),
 case [FeePaidBy] when -1 then 'By Client' 
else (select [name] from tblCompany  where companyid=[FeePaidBy])
end  as [FeePaid],
Phone=[Phone],
Levies1=[Levies1],
Levies2=[Levies2],
IReceived =Convert(varchar,Convert(money,[IReceived] ),1),
WageVal, TypeOfAidPension, TypeOfAidUnemp, TypeOfAidRetire, 
AmtReceivedPension =Convert(varchar,Convert(money,AmtReceivedPension ),1),
AmtReceivedUnemp =Convert(varchar,Convert(money,AmtReceivedUnemp ),1), 
AmtReceivedRetire =Convert(varchar,Convert(money,AmtReceivedRetire ),1),
[who is the plantiff?]=whoisplantiff
,[Language] = l.name
from tblclientintakeform cif with(nolock)
inner join tblaccount a with(nolock) on a.accountid = cif.accountid
inner join tblclient c with(nolock) on c.clientid = a.clientid
inner join tblperson p with(nolock) on p.personid = c.primarypersonid
inner join tbllanguage l with(nolock) on l.languageid = p.languageid
where cif.accountid=@AccoutnID  
End

GO


GRANT EXEC ON stp_GetClientIntakeInfo TO PUBLIC

GO


