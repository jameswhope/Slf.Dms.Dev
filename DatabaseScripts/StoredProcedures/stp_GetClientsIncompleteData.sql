/****** Object:  StoredProcedure [dbo].[stp_GetClientsIncompleteData]    Script Date: 11/19/2007 15:27:05 ******/
DROP PROCEDURE [dbo].[stp_GetClientsIncompleteData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetClientsIncompleteData]
	(
		@agencyId int
	)

as

select
	c.clientid,
	p.firstname,
	p.lastname,
	tblAgencyExtraFields01.DebtTotal,
	c.created  as HireDate,
	(SELECT Top 1 Created FROM tblRoadmap WHERE ClientId=c.ClientId order by roadmapid desc) as StatusChanged
	
from
	tblclient c 
	inner join tblperson p on c.primarypersonid=personid 
	left outer join tblAgencyExtraFields01 ON c.ClientId=tblAgencyExtraFields01.ClientId
where 
	c.currentclientstatusid=24
	and C.agencyid=@agencyid
GO
