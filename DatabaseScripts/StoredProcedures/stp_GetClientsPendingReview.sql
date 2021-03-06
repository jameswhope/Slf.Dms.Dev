/****** Object:  StoredProcedure [dbo].[stp_GetClientsPendingReview]    Script Date: 11/19/2007 15:27:06 ******/
DROP PROCEDURE [dbo].[stp_GetClientsPendingReview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetClientsPendingReview]
	(
		@agencyId int=null
	)

as

select
	c.clientid,
	a.name as agencyname,
	p.firstname + ' ' + p.lastname as clientname,
	tblAgencyExtraFields01.DebtTotal,
	c.created  as HireDate,
	(SELECT Top 1 Created FROM tblRoadmap WHERE ClientId=c.ClientId order by roadmapid desc) as StatusChanged
	
from
	tblclient c inner join
	tblperson p on c.primarypersonid=personid inner join
	tblagency a on c.agencyid=a.agencyid LEFT OUTER JOIN 
	tblAgencyExtraFields01 ON c.ClientId=tblAgencyExtraFields01.ClientId
where 
	c.currentclientstatusid=23
	and a.agencyid=isnull(@agencyid, a.agencyid)
GO
