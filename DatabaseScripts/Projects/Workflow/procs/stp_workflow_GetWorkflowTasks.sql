IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_workflow_GetWorkflowTasks')
	BEGIN
		DROP  Procedure  stp_workflow_GetWorkflowTasks
	END

GO

CREATE Procedure stp_workflow_GetWorkflowTasks
	(
		@workflowName varchar(500)
	)
AS
BEGIN
	SELECT 
		[WorkFlowID]
		,[WorkFlowName]
		,[WorkFlowStepName]
		,[WorkFlowTaskID]
		,[WorkFlowSequence]
		,[Created]
		,[CreatedBy]
		,[LastModified]
		,[LastModifiedBy] 
	FROM tblWorkflow 
	WHERE workflowname = @workflowName 
	ORDER BY workflowsequence
END

GO


GRANT EXEC ON stp_workflow_GetWorkflowTasks TO PUBLIC

GO


