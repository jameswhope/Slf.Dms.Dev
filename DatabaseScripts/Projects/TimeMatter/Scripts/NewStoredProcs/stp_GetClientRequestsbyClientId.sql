set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*
      Revision    : <00 - 19 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Description : List ClientRequests
*/


CREATE procedure [dbo].[stp_GetClientRequestsbyClientId]
(
	@ClientId int,
	@OrderBy varchar(100)='cr.Created'
)
AS


BEGIN

declare @clientjoin varchar(1000)

set @clientjoin = 'Select cr.* ,
u1.FirstName+'' ''+u1.LastName as CreatedByName,
u2.FirstName+'' ''+u2.LastName as LastModifiedName,
crs.ClientRequestStatusCode

from dbo.tblClientRequests cr
join dbo.tblClientRequestStatusCode crs on crs.ClientRequestStatusCodeId= cr.ClientRequestStatusCodeId
join dbo.tblClient c on c.ClientId=cr.ClientId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
join dbo.tblUser u1 on u1.Userid = cr.CreatedBy
left outer join dbo.tblUser u2 on u2.Userid = cr.LastModifiedBy

where cr.ClientId= ' + cast(@ClientId as varchar) +' Order by ' + @Orderby

exec(@clientjoin)

END











