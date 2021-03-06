set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go









ALTER procedure [dbo].[stp_GetMattersbyClientAccount]
(
	@ClientId int,
    @AccountId int
)
AS


/**** Get Matter detail information based on ClientId and AccountId ****/
/**** Created 11/23/2009 ...***/ 
/***  by usutyono ****/


BEGIN


select

m.MatterId,
MatterDate,
MatterNumber,
MatterMemo,
c.ClientId,
c.AccountNumber,
m.MatterNumber,
ti.AccountNumber,
p.FirstName+' '+ p.LastName as ClientName,
co.[Name] as Firm,
at.FirstName+' '+ at.MiddleName+ ' '+ at.LastName as Attorney,
msc.MatterStatusCodeId,
msc.MatterStatusCode,
*

 



from 

dbo.tblMatter m
join dbo.tblClient c on c.ClientId=m.ClientId
join dbo.tblPerson p on c.PrimaryPersonId =p.PersonId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
join dbo.tblMatterStatusCode as msc on msc.MatterStatusCodeId = m.MatterStatusCodeId

join tblAccount ac on ac.ClientId=c.ClientId 
and ac.AccountId= @AccountId
join tblCreditorInstance ti on ti.CreditorInstanceId=ac.CurrentCreditorInstanceId 
and Right(m.MatterNumber,4)= Right(ti.AccountNumber,4)
--left join dbo.tblMatterAttorney ma on ma.MatterId = m.MatterId
left join dbo.tblAttorney at on at.AttorneyId = m.AttorneyId 
--and AttyRelation ='Primary'

where c.ClientId=@ClientId

order by MatterDate,MatterNumber



--select
--
--m.MatterId,
--MatterDate,
--MatterNumber,
--MatterDescription,
--c.ClientId,
--c.AccountNumber,
--m.MatterNumber,
--ti.AccountNumber,
--p.FirstName+' '+ p.LastName as ClientName,
--co.[Name] as Firm,
--at.FirstName+' '+ at.MiddleName+ ' '+ at.LastName as Attorney,
--msc.MatterStatusCodeId,
--msc.MatterStatusCode,
--*
--
-- 
--
--
--
--from 
--
--dbo.tblMatter m
--join dbo.tblClient c on c.ClientId=m.ClientId
--join dbo.tblPerson p on c.PrimaryPersonId =p.PersonId
--join dbo.tblCompany co on co.CompanyId=c.CompanyId
--join dbo.tblMatterStatusCode as msc on msc.MatterStatusCodeId = m.MatterStatusCodeId
--
--join tblAccount ac on ac.ClientId=c.ClientId 
--and ac.AccountId= @AccountId
--join tblCreditorInstance ti on ti.CreditorInstanceId=ac.CurrentCreditorInstanceId 
--and Right(m.MatterNumber,4)= Right(ti.AccountNumber,4)
--left join dbo.tblMatterAttorney ma on ma.MatterId = m.MatterId
--left join dbo.tblAttorney at on at.AttorneyId = ma.AttorneyId and AttyRelation ='Primary'
--
--where c.ClientId=@ClientId
--
--order by MatterDate,MatterNumber

END










