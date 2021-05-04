 
  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DialerGetClientLawFirmAni')
	BEGIN
		DROP  Procedure  stp_DialerGetClientLawFirmAni
	END

GO

CREATE Procedure stp_DialerGetClientLawFirmAni
@ClientId int,
@ReasonId int
AS
Select isnull(p.phonenumber,'') as CustomAni, m.name as CustomAniName from tblClient c
Inner Join tblCompany m on c.companyId = m.companyId
Left Join tblCompanyPhones p on p.CompanyId = m.CompanyId
Left Join tblDialerCallReasonType r on r.PhoneTypeId = p.PhoneType
Where c.clientid  = @ClientId
And r.ReasonId = @ReasonId

GO


