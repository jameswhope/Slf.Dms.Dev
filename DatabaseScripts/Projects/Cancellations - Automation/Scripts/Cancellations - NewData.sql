
if not exists (select 1 from tblMatterGroup where MatterGroup = 'Cancellation') begin
	INSERT INTO tblMatterGroup(MatterGroup,MattergRoupDescr,Created,CreatedBy,LastModified,LastModifiedBy)
	VALUES('Cancellation','Client Cancellations',getdate(),1460,getdate(),1460)
end

DECLARE @MatterGroup INT, @TaskTyepCategory INT;
SET @MatterGroup = (select MatterGroupId from tblMatterGroup where MatterGroup = 'Cancellation');

if not exists (select 1 from tblMatterType where MatterTypeCode = 'Cancellation') begin	
	INSERT INTO tblMatterType(MatterTypeCode, MatterTypeShortDescr, IsActive, Created, CreatedBy, LastModified, LastModifiedBy, MatterGroupId)
	VALUES('Cancellation','Client Cancellations', 1, getdate(), 1460, getdate(), 1460, @MatterGroup);
end

if not exists (select 1 from tblMattergroupUserGroupXRef where mattergroupid = @MatterGroup) begin
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(@MatterGroup,40) -- Seideman Accounting
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(@MatterGroup,27) -- Retention
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(@MatterGroup,11) --System Admins
end

--Start MatterStatus
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'CS') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'CS','Client Cancellation Process Started', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'RC') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'RC','The Client is re-activated', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'PFR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'PFR','Pending Fee Recovery', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'SC') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'SC','Cancellation Survey Completed', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'PMR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'PMR','One or more Matters belonging to Client are still pending', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'PCR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'PCR','Client is yet to send the Cancellation request', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'CRR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'CRR','Client Request Received', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'PBD') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'PBD','Pending Bankruptcy documents', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'PDC') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'PDC','Pending death certificate', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'BDR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'BDR','Bankruptcy Document Received', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'DCR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'DCR','Death Certificate Received', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'CAN') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(4,'CAN','Client Cancelled', getdate(), 1460, getdate(), 1460)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'COMP') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(4,'COMP','Client Completed', getdate(), 1460, getdate(), 1460)
end
--End MatterStatus

Declare @MatterSubStatusId INT;
--Start MatterSubSTatus
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Survey') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Pending Survey','Pending Cancellation Survey', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'RC') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'RC','Re-activate the client', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Survey Completed') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'Survey Completed','Cancellation Survey Completed', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Matter Resolution') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Pending Matter Resolution','One or more Matters belonging to Client are still pending', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Receipt of Cancellation Request') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Pending Receipt of Cancellation Request','Client is yet to send the Cancellation request', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'ClientRequest Received') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'ClientRequest Received','Received Client''s Cancellation Request', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Fee Recovery') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Pending Fee Recovery','Waiting on pending fee to be deposited', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Waiting on Bankruptcy Document') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Waiting on Bankruptcy Document','The client is yet to send in the proof for bankruptcy', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Waiting on Death Certificate') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Waiting on Death Certificate','The Death certificate for the client is yet to be received', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Bankruptcy Document Received') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'Bankruptcy Document Received','The Bankruptcy documeny for the client is received', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Death Certificate Received') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'Death Certificate Received','The Death certificate for the client is received', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Client Cancelled') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(4,'Client Cancelled','Cancellation of Client completed', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Client Completed') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(4,'Client Completed','Client marked as completed', getdate(), 1460, getdate(), 1460 )
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(4,@MatterSubStatusId)
end
--End MatterSubStatus


if not exists (select 1 from tblTaskTypeCategory where [Name] = 'Cancellation') begin
	INSERT INTO tblTaskTypeCategory([Name], Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES('Cancellation', getdate(), 1480, getdate(), 1480)
end

SET @TaskTyepCategory = (select TaskTypeCategoryId from tblTaskTypeCategory where [Name] = 'Cancellation');

if not exists (select 1 from tblTaskType where [Name] = 'Call Client For Cancellation') begin
	INSERT INTO tblTaskType(TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, TaskInstruction)
	VALUES(@TaskTyepCategory, 'Call Client For Cancellation', 'Call the client to start the cancellation process', getdate(), 1480, getdate(), 1480,null)
end

if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'SNA') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Services not Affordable', 'SNA', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'DS') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Dissatisfied With Services', 'DS', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'NEG') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Negative opinion based on external source', 'NEG', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'PL') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Afraid of Potential or current lawsuits/garnishments/bank levy', 'PL', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'LCC') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Advised by LC to cancel', 'LCC', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'CRED') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Cannot have credit affected at this time', 'CRED', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'DC') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Client Passed awat', 'DC', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'COL') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Cancellation letter from outside counsel', 'COL', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'BKDR') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Bankruptcy documents received', 'BKDR', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'RS') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Not disclosed/Refused to disclose', 'RS', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'OT') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Other', 'OT', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'CR') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Completing representation', 'CR', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'CRES') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Client Unresponsive', 'CRES', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'NSF') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Did not make monthly deposits/ Multiple NSF', 'NSF', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'FC') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Regulatory Agency Complaint', 'FC', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'SA') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Settlement Attorney (Other)', 'SA', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'BK') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Filed Bankruptcy', 'BK', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'RA') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Joining/Seeking other services', 'RA', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'HD') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Handling debt on their own', 'HD', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'NOA') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('No action to be taken/Judgement Proof', 'NOA', 1480, getdate())
end
if not exists (select 1 from tblClientCancellationReason where [CancellationCode] = 'DK') begin
	INSERT INTO tblClientCancellationReason(CancellationReason, CancellationCode, CreatedBy, Created)
	VALUES('Not Sure/Dont Know', 'DK', 1480, getdate())
end

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Lost Job' FROM tblClientCancellationReason 
WHERE CancellationCode = 'SNA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Change in income' FROM tblClientCancellationReason 
WHERE CancellationCode = 'SNA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Medical leave from work/disability' FROM tblClientCancellationReason 
WHERE CancellationCode = 'SNA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Getting Divorced' FROM tblClientCancellationReason 
WHERE CancellationCode = 'SNA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Death in family' FROM tblClientCancellationReason 
WHERE CancellationCode = 'SNA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Being garnished/bank levy' FROM tblClientCancellationReason 
WHERE CancellationCode = 'SNA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Unhappy with settlement percentage' FROM tblClientCancellationReason 
WHERE CancellationCode = 'DS'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Lack of settlement activity' FROM tblClientCancellationReason 
WHERE CancellationCode = 'DS'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Unable to resolve last debt' FROM tblClientCancellationReason 
WHERE CancellationCode = 'DS'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Misunderstood services' FROM tblClientCancellationReason 
WHERE CancellationCode = 'DS'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Better Business Bureau' FROM tblClientCancellationReason 
WHERE CancellationCode = 'FC'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Attorney General' FROM tblClientCancellationReason 
WHERE CancellationCode = 'FC'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Department of Justice' FROM tblClientCancellationReason 
WHERE CancellationCode = 'FC'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Other state Regulatory Agency' FROM tblClientCancellationReason 
WHERE CancellationCode = 'FC'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Filing - retained Attorney' FROM tblClientCancellationReason 
WHERE CancellationCode = 'BK'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Filing - have not retained Attorney' FROM tblClientCancellationReason 
WHERE CancellationCode = 'BK'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Filing BK' FROM tblClientCancellationReason 
WHERE CancellationCode = 'BK'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Consumer Credit counseling/Non-profit' FROM tblClientCancellationReason 
WHERE CancellationCode = 'RA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Local Attorney' FROM tblClientCancellationReason 
WHERE CancellationCode = 'RA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Debt Settlement Co' FROM tblClientCancellationReason 
WHERE CancellationCode = 'RA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Debt Consolidation' FROM tblClientCancellationReason 
WHERE CancellationCode = 'RA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Has already settled Debt' FROM tblClientCancellationReason 
WHERE CancellationCode = 'HD'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Refinancing to pay debts' FROM tblClientCancellationReason 
WHERE CancellationCode = 'HD'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Borrowed money from friends/family' FROM tblClientCancellationReason 
WHERE CancellationCode = 'HD'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, 'Made payment arrangements with creditors' FROM tblClientCancellationReason 
WHERE CancellationCode = 'HD'

--End sub reasons

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'NEG'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'PL'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'LCC'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'CRED'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'DC'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'COL'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'BKDR'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'RS'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'OT'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'CR'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'CRES'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'NSF'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'SA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'NOA'

INSERT INTO tblClientCancellationSubReason(CancellationReasonId, CancellationSubReason)
SELECT CancellationReasonId, CancellationReason FROM tblClientCancellationReason 
WHERE CancellationCode = 'DK'

--End sub reasons

--Scan Relations
if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 114) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('matter', 114);
end
if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 118) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
	VALUES('matter', 118);
end
if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 306) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
	VALUES('matter', 306);
end
GO
update tblDocumentType set DisplayName = 'Request For Bankruptcy Letter(Scanned)' where DocumentTypeId = 306;

if not exists(select 1 from tblFunction where FullName = 'Clients-Client Cancellation') begin
	INSERT INTO tblFunction([Name], FullName, IsSystem, IsOPeration)
	VALUES('Cancellation', 'Clients-Client Cancellation', 0, 0)
end

if not exists (select 1 from tblDocumentType where TypeId = 'D9014') begin
	INSERT INTO tblDocumentType(TypeId, TypeName, DisplayName, DocFolder, Created, CreatedBy,LastModified, LastModifiedBy)
	VALUES('D9014', 'CancellationCheck', 'Cancellation Check', 'ClientDocs', getdate(), 1480, getdate(), 1480)
end

GO