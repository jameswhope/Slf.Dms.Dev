set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






/*
      Revision    : <06 - 02 March 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription : Returns Details of a Matter
*/
ALTER PROCEDURE [dbo].[stp_GetMatterInstance]
(
   @MatterId int,
   @AccountId int=0,
   @MatterTypeId int =1		
)
AS

BEGIN

If @AccountId>0 
Begin

DECLARE @latestCreditorInstanceId int

SET @LatestCreditorInstanceId=(select TOP 1 CreditorInstanceId from tblCreditorInstance where AccountId =@AccountId order by Created desc)

select 

m.MatterId, m.MatterTypeId,
m.ClientId,
m.MatterStatusCodeId,
msc.MatterStatusCode,
CONVERT(VARCHAR(10),m.MatterDate,  101) AS MatterDate,
IsNull(ISNULL(m.CreditorInstanceId,ci.CreditorInstanceId), -1) as CreditorInstanceId,
ci.AccountNumber as AccountNumber,
m.MatterNumber,
m.MatterMemo as Note,
isNull(m.AttorneyId,-1) as AttorneyId,
--ma.AttorneyId,
ISNULL((CASE WHEN MiddleName IS NULL THEN a.FirstName+' '+a.LastName
	 WHEN MiddleName IN('',' ') THEN a.FirstName+ ' '+a.LastName
	 ELSE a.FirstName +' '+a.MiddleName+' '+a.LastName END),' ') as LocalCounsel,
m.CreatedDateTime,
m.CreatedBy,
m.MatterStatusId, ms.MatterStatus,
m.MatterSubStatusId, 
(select Mattersubstatus from tblmattersubstatus where mattersubstatusid=m.MatterSubStatusId)
as mattersubstatus,
m.MatterCaseNumber



from dbo.tblMatter m
join dbo.tblMatterStatusCode msc on msc.MatterStatusCodeId=m.MatterStatusCodeId
--join dbo.tblMatterAttorney ma on ma.MatterId=m.MatterId
join dbo.tblAccount ac on ac.ClientId= m.ClientId  and ac.AccountId=@AccountId
join tblCreditorInstance ci on ac.CurrentCreditorInstanceId = ci.CreditorInstanceId
left join dbo.tblAttorney a on a.AttorneyId=m.AttorneyId
left outer join dbo.tblmatterstatus ms on ms.MatterStatusId=m.MatterstatusId

Where m.MatterId=@MatterId

End

Else If @AccountId=0 
Begin

select 

m.MatterId, m.MatterTypeId,
m.ClientId,
m.MatterStatusCodeId,
msc.MatterStatusCode,
CONVERT(VARCHAR(10),m.MatterDate,  101) AS MatterDate,
IsNull(ISNULL(m.CreditorInstanceId,ci.CreditorInstanceId),-1) as CreditorInstanceId,
c.AccountNumber as AccountNumber,
m.MatterNumber,
m.MatterMemo as Note,
isNull(m.AttorneyId,-1) as AttorneyId,
--ma.AttorneyId,
ISNULL((CASE WHEN MiddleName IS NULL THEN a.FirstName+' '+a.LastName
	 WHEN MiddleName IN('',' ') THEN a.FirstName+ ' '+a.LastName
	 ELSE a.FirstName +' '+a.MiddleName+' '+a.LastName END),' ') as LocalCounsel,
m.CreatedDateTime,
m.CreatedBy,
m.MatterStatusId, ms.MatterStatus,
m.MatterSubStatusId, 
(select Mattersubstatus from tblmattersubstatus where mattersubstatusid=m.MatterSubStatusId)
as mattersubstatus,
m.MatterCaseNumber

from dbo.tblMatter m
join dbo.tblMatterStatusCode msc on msc.MatterStatusCodeId=m.MatterStatusCodeId
--join dbo.tblMatterAttorney ma on ma.MatterId=m.MatterId
left outer join tblCreditorInstance ci on m.CreditorInstanceId = ci.CreditorInstanceId
left outer join dbo.tblAttorney a on a.AttorneyId=m.AttorneyId
left outer join tblClient c on c.clientid=m.clientid
left outer join dbo.tblmatterstatus ms on ms.MatterStatusId=m.MatterstatusId

Where m.MatterId=@MatterId

End

--select 
--
--m.MatterId,
--m.ClientId,
--m.MatterStatusCodeId,
--msc.MatterStatusCode,
--CONVERT(VARCHAR(10),m.MatterDate,  101) AS MatterDate,
--ci.CreditorInstanceId,
--ci.AccountNumber as AccountNumber,
--m.MatterNumber,
--m.MatterDescription as Note,
--ma.AttorneyId,
--(CASE WHEN MiddleName IS NULL THEN a.FirstName+' '+a.LastName
--	 WHEN MiddleName IN('',' ') THEN a.FirstName+ ' '+a.LastName
--	 ELSE a.FirstName +' '+a.MiddleName+' '+a.LastName END) as LocalCounsel,
--m.CreatedDateTime,
--m.CreatedBy
--
--
--from dbo.tblMatter m
--join dbo.tblMatterStatusCode msc on msc.MatterStatusCodeId=m.MatterStatusCodeId
--join dbo.tblMatterAttorney ma on ma.MatterId=m.MatterId
--join dbo.tblAttorney a on a.AttorneyId=ma.AttorneyId
--join dbo.tblAccount ac on ac.ClientId= m.ClientId and ac.AccountId=@AccountId
--join tblCreditorInstance ci on ac.CurrentCreditorInstanceId = ci.CreditorInstanceId
--
--Where m.MatterId=@MatterId

END





