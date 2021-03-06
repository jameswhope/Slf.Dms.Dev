/****** Object:  StoredProcedure [dbo].[stp_AgencyGetClientInfo]    Script Date: 11/19/2007 15:26:50 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetClientInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_AgencyGetClientInfo]
	(
		@agencyId int,
		@strWhere varchar (8000) = '',
		@orderby varchar (8000) = 'tblPerson.LastName ASC'
	)

as

declare @userId int
set @userId = (SELECT UserID FROM tblAgency WHERE AgencyId=@agencyId)

exec('

SELECT 
	tblClient.ClientID,
	tblClient.AccountNumber,
	tblClient.DepositMethod, 
	tblClient.DepositAmount, 
	tblPerson.FirstName, 
	tblPerson.LastName, 
	tblPerson.SSN,
	tblNote.[Value] AS Comments,
	tblAgencyExtraFields01.LeadNumber, 
	tblAgencyExtraFields01.DateSent, 
	tblAgencyExtraFields01.DateReceived, 
	tblAgencyExtraFields01.SeidemanPullDate, 
	tblAgencyExtraFields01.DebtTotal, 
	tblAgencyExtraFields01.MissingInfo,
	tblCurrentStatus.ClientStatusId as ClientStatusId,
	tblClientStatus.[Name] as ClientStatusName,
	tblClient.ReceivedLSA

FROM 
	tblClient INNER JOIN 
	tblPerson ON tblClient.PrimaryPersonId=tblPerson.PersonId LEFT OUTER JOIN 
	tblAgencyExtraFields01 ON tblClient.ClientId=tblAgencyExtraFields01.ClientId LEFT OUTER JOIN
	(SELECT RoadmapId, ClientId, ClientStatusId FROM tblRoadmap WHERE RoadmapId=
		(SELECT TOP 1 RoadmapId FROM tblRoadmap a where a.ClientId=tblRoadmap.ClientId ORDER BY RoadmapId DESC))  tblCurrentStatus ON tblClient.ClientId=tblCurrentStatus.ClientId LEFT OUTER JOIN
	tblClientStatus ON tblCurrentStatus.ClientStatusId=tblClientStatus.ClientStatusId LEFT OUTER JOIN
	(SELECT RoadmapId, ClientId, Created AS Enrolled FROM tblRoadmap WHERE ClientStatusId=5) tblEnrolled ON tblClient.ClientId=tblEnrolled.ClientId LEFT OUTER JOIN
	tblNote ON tblAgencyExtraFields01.NoteId=tblNote.NoteId

WHERE
	tblClient.AgencyId = ' + @agencyId + ' ' + @strWhere + '
ORDER BY '
	+ @OrderBy
)
GO
