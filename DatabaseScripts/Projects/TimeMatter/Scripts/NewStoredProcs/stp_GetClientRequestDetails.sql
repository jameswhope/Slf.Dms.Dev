set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO







/*
      Revision    : <00 - 19 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Get ClientRequests Detail
*/


CREATE  procedure [dbo].[stp_GetClientRequestDetails]
(
	@ClientRequestId int
)
AS


BEGIN

Select 

CONVERT(VARCHAR(10),cr.ClientRequestDateTime,  101) [ClientRequestDateTime] ,
co.Name [Firm],
* 

from dbo.tblClientRequests cr
join dbo.tblClientRequestStatusCode crs on crs.ClientRequestStatusCodeId= cr.ClientRequestStatusCodeId
join dbo.tblClient c on c.ClientId=cr.ClientId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
where cr.ClientRequestId=@ClientRequestId


END











