IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementRoadmap')
	BEGIN
		DROP  Procedure  stp_GetSettlementRoadmap
	END

GO

CREATE Procedure [dbo].[stp_GetSettlementRoadmap]
	(
		@SettlementId int
	)

as

SELECT
	ms.MatterStatusCode as [Status],
	sr.Created as CreatedDate,
	u.FirstName + ' ' + u.LastName as CreatedBy,
	isnull(n.[Value],'') as Comment
FROM
	tblSettlementRoadmap sr inner join
	tblMatterStatusCode ms on sr.MatterStatusCodeId = ms.MatterStatusCodeId inner join
	tblUser u on u.UserId = sr.CreatedBy left join
	tblNote n on n.NoteId = sr.NoteId 
WHERE
	sr.SettlementId = @SettlementId
ORDER BY sr.Created

GO


GRANT EXEC ON stp_GetSettlementRoadmap TO PUBLIC

GO


