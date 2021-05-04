stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Attach SIF/CS',82,1,750;
go
stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Send Client Stipulation to Client',83,2,750;
go
stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Get Client Approval for Client Stipulation settlement.',78,3,750;
go
stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Attached signed Client Stipulation to settlement.',84,4,750;
go
stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Accounting Approval',80,5,750;
go
stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Pay Settlement',73,6,750;
go
stp_workflow_CreateWorkflowStep 'Client Stipulation Settlement','Send Finalized Settlement Kit',81,7,750;
go 