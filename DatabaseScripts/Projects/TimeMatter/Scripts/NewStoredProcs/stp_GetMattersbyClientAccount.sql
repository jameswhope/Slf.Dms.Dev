set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*
      Revision    : <07 - 23 February 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription  : Get Matter detail information based on ClientId and AccountId
*/

CREATE procedure [dbo].[stp_GetMattersbyClientAccount]
(
	@ClientId int,
    @AccountId int
)
AS


BEGIN


select

m.MatterId, m.MatterTypeId,
m.MatterDate,
m.MatterNumber,
m.MatterMemo,
c.ClientId,
c.AccountNumber,
m.MatterNumber,
ti.AccountNumber,
p.FirstName+' '+ p.LastName as ClientName,
co.[Name] as Firm,
(CASE WHEN MiddleName IS NULL THEN at.FirstName+' '+at.LastName
	 WHEN MiddleName IN('',' ') THEN at.FirstName+ ' '+at.LastName
	 ELSE at.FirstName +' '+at.MiddleName+' '+at.LastName END) as Attorney,
msc.MatterStatusCodeId,
--msc.MatterStatusCode,
m.CreatedDateTime, m.CreatedBy, m.CreditorInstanceId, 
ms.MatterStatusId,
ms.MatterStatus as MatterStatusCode



from 

dbo.tblMatter m
join dbo.tblClient c on c.ClientId=m.ClientId
join dbo.tblPerson p on c.PrimaryPersonId =p.PersonId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
join dbo.tblMatterStatusCode as msc on msc.MatterStatusCodeId = m.MatterStatusCodeId

join tblAccount ac on ac.ClientId=c.ClientId 
and ac.AccountId= @AccountId

join tblCreditorInstance ti on ti.CreditorInstanceId=m.CreditorInstanceId 
and ti.AccountId= ac.AccountId

--join tblCreditorInstance ti on ti.CreditorInstanceId=ac.CurrentCreditorInstanceId 
--and Right(m.MatterNumber,4)= Right(ti.AccountNumber,4)
left join dbo.tblAttorney at on at.AttorneyId = m.AttorneyId 
left outer join dbo.tblMatterStatus as ms on ms.MatterStatusId = m.MatterStatusId

where c.ClientId=@ClientId and IsNull(m.IsDeleted,0)=0

order by m.MatterDate,m.MatterNumber

END






