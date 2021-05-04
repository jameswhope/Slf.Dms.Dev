IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_workflow_CreateWorkflowStep')
	BEGIN
		DROP  Procedure  stp_workflow_CreateWorkflowStep
	END

GO

CREATE Procedure stp_workflow_CreateWorkflowStep
	(
		@WorkFlowName varchar(500),
		@WorkFlowStepName varchar(500),
		@WorkFlowTaskID numeric(18,0),
		@WorkFlowSequence numeric(18,0),
		@UserID int
	)
AS
BEGIN
	INSERT INTO [tblWorkflow]
	([WorkFlowName],[WorkFlowStepName],[WorkFlowTaskID],[WorkFlowSequence],[Created],[CreatedBy],[LastModified],[LastModifiedBy])
	VALUES
	(@WorkFlowName,@WorkFlowStepName,@WorkFlowTaskID,@WorkFlowSequence,getdate(),@UserID,getdate(),@UserID)
END

GO


GRANT EXEC ON stp_workflow_CreateWorkflowStep TO PUBLIC

GO


