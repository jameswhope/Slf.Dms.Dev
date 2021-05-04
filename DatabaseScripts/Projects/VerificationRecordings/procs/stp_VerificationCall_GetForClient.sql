IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_GetForClient')
	BEGIN
		DROP  Procedure  stp_VerificationCall_GetForClient
	END

GO

CREATE Procedure stp_VerificationCall_GetForClient
@ClientId int
AS
Select v.VerificationCallId, 
v.StartDate as [Submitted],
v.EndDate as [Completed],
isnull(u.firstname,'') + ' ' + left(u.lastname,1) + '.' [SubmittedBy],
v.RecordedCallPath,
v.DocumentPath,
v.RecordedCallPath,
v.RecCallIdKey,
isnull(LastStep, 'Error') as LastStep
from tblVerificationCall v
inner join tbluser u on u.userid = v.executedby
Where v.ClientId = @ClientId
Order By v.StartDate Desc

GO


