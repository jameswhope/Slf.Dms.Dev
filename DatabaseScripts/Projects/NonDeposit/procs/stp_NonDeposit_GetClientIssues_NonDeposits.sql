IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetClientIssues_NonDeposits')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetClientIssues_NonDeposits
	END

GO

CREATE Procedure stp_NonDeposit_GetClientIssues_NonDeposits
@ClientId int
AS
SELECT Distinct
	m.MatterId,
	m.MatterStatusCodeId,
	m.MatterSubStatusId,
	m.MatterDate,
	t.TaskId,
	m.ClientId,
	t.[Description],
	t.Due As TaskDueDate
FROM 
	tblTask t inner join
	tblMatterTask mt ON mt.TaskId = t.TaskId inner join
	tblMatter m ON m.MatterId = mt.MatterId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) inner join
	tblNonDeposit n ON n.MatterId = m.MatterId 
WHERE 
	t.TaskTypeId in (76,77) and (t.TaskResolutionId is null or t.TaskResolutionId not in  (1,2,3,4))
	and n.clientid = @ClientId
			

GO

