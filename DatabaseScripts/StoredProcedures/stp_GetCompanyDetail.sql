if exists (select * from sysobjects where name = 'stp_GetCompanyDetail')
	drop procedure stp_GetCompanyDetail
go

create procedure stp_GetCompanyDetail
(
  @CompanyID int
)
as
begin
/*
	History:
	jhernandez		11/20/07		Created.
	jhernandez		12/03/07		Added attorney list to output.
	jhernandez		03/04/08		Employed attorneys based on flag. Bug 414
	jhernandez		03/11/08		Return the default user account for this SA. Bug 471
*/


-- Company Detail
select
  c.CompanyID
, c.[Name]
, c.[Default]
, c.ShortCoName
, c.Contact1
, c.Contact2
, c.BillingMessage
, isnull(c.Website,'') [Website]
, isnull(c.SigPath,'') [SigPath]
, c.Created
, isnull(u1.Username,'') [CreatedBy]
, c.LastModified
, isnull(u2.Username,'') [LastModifiedBy]
from
 tblCompany c
left join tblUser u1
 on u1.UserID = c.CreatedBy
left join tblUser u2
 on u2.UserID = c.LastModifiedBy
where
 c.CompanyID = @CompanyID


-- Addresses
select
  a.CompanyAddressID
, a.CompanyID
, a.AddressTypeID
, t.AddressTypeName
, a.Address1
, isnull(a.Address2,'') [Address2]
, a.City
, a.State
, a.Zipcode
from
 tblCompanyAddresses a
join
 tblCompanyAddressTypes t
  on t.AddressTypeID = a.AddressTypeID
where
 a.CompanyID = @CompanyID
order by
 t.AddressTypeName


-- Phones
select
  p.CompanyPhoneID
, p.CompanyID
, t.PhoneTypeID
, t.Name [PhoneType]
, p.PhoneNumber
from
 tblCompanyPhones p
join
 tblPhoneType t
  on t.PhoneTypeID = p.PhoneType
where
 p.CompanyID = @CompanyID
order by 
 t.Name


-- State Bar Information (obsolete)
select 
  s.StateBarID
, s.CompanyID
, s.State
, s.StateBarNum
from
 tblCompanyStateBar s
join tblCompany c
 on c.CompanyID = s.CompanyID
  and c.CompanyID = @CompanyID
order by
 s.State


-- Commission Recipients
select
  r.CommRecID
, r.CompanyID
, r.CommRecTypeID
, t.Name [CommRecType]
, r.Abbreviation
, r.Display
, r.IsCommercial
, r.IsLocked
, r.IsTrust
, r.Method
, r.BankName
, r.RoutingNumber --, cast(DecryptByPassphrase(@Passphrase,r.RoutingNumber) as varchar) [RoutingNumber]
, r.AccountNumber --, cast(DecryptByPassphrase(@Passphrase,r.AccountNumber) as varchar) [AccountNumber]
, isnull(r.Type,'C') [Type]
, r.AccountTypeID
from 
 tblCommRec r
join tblCommRecType t
  on t.CommRecTypeID = r.CommRecTypeID

where
 r.CompanyID = @CompanyID
order by
 r.BankName


-- Recipient Addresses
select
  a.CommRecAddressID
, a.CommRecID
, a.Contact1
, a.Contact2
, a.Address1
, a.Address2
, a.City
, a.State
, a.Zipcode
from
 tblCommRecAddress a
join tblCommRec r
 on r.CommRecID = a.CommRecID
  and r.CompanyId = @CompanyID
order by
 a.CommRecID, a.Address1


-- Recipient Phones
select 
  p.CommRecPhoneID
, p.CommRecID
, p.PhoneNumber
from
 tblCommRecPhone p
join tblCommRec r
 on r.CommRecID = p.CommRecID
  and r.CompanyID = @CompanyID
order by
 p.PhoneNumber


-- FTP Information
select
  tblNachaRoot
, CompanyID
, CommRecID
, Bank
, DestinationRoutingNo [RoutingNo]
, OriginTaxID
, OriginName
, ftpServer
, ftpUsername
, ftpPassword
, ftpFolder
, ftpControlPort
, Passphrase
, PublicKeyring
, PrivateKeyring
, FileLocation
, LogPath
from
 tblNachaRoot
where
 CompanyID = @CompanyID


---- Employed Attorneys
select
	a.AttorneyID
,	a.FirstName
,	isnull(a.MiddleName,'') [MiddleName]
,	a.LastName
,	isnull(s.State,'') [State]
,	isnull(s.StateBarNum,'') [StateBarNum]
,	r.CompanyID
,	r.AttyRelation
,	case when r.AttyRelation = 'Principle' then 1 else 0 end [IsPrimary]
from
 tblAttorney a
join tblAttyRelation r
 on r.AttorneyID = a.AttorneyID
  and r.CompanyID = @CompanyID
join tblAttorneyType t
 on t.Type = r.AttyRelation and t.Employed = 1
left join tblAttyStates s
 on s.AttorneyID = r.AttorneyID
  and s.State = r.EmployedState
order by
 a.FirstName, a.LastName


-- Table 9 (User Account)
select top 1
	u.UserID
,	u.Username
from
	tblUser u
join
	tblUserCompany c on c.UserID = u.UserID and c.CompanyIDs = cast(@CompanyID as varchar(10))
where
	u.UserTypeID = 6 and u.UserGroupID = 20
order by
	u.Created


end
go