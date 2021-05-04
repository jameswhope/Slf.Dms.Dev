 
if not exists (select 1 from tblMatterGroup where MatterGroup = 'NonDeposit') begin
	INSERT INTO tblMatterGroup(MatterGroup,MattergRoupDescr,Created,CreatedBy,LastModified,LastModifiedBy)
	VALUES('NonDeposit','Non Deposits',getdate(),785,getdate(),785)
end

DECLARE @MatterGroup INT, @TaskTypeCategory INT;
SET @MatterGroup = (select MatterGroupId from tblMatterGroup where MatterGroup = 'NonDeposit');

if not exists (select 1 from tblMatterType where MatterTypeCode = 'NonDeposit') begin	
	INSERT INTO tblMatterType(MatterTypeCode, MatterTypeShortDescr, IsActive, Created, CreatedBy, LastModified, LastModifiedBy, MatterGroupId)
	VALUES('NonDeposit','Non Deposits', 1, getdate(), 785, getdate(), 785, @MatterGroup);
end

if not exists (select 1 from tblMattergroupUserGroupXRef where mattergroupid = @MatterGroup) begin
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(@MatterGroup,27) -- Retention
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(@MatterGroup,11) --System Admins
end

--Start MatterStatus
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_CR') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'ND_CR','Client Non Deposit Process Record Created', getdate(), 785, getdate(), 785)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_CC') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'ND_CC','Pending to contact client', getdate(), 785, getdate(), 785)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_RD') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'ND_RD','Pending Replacement Deposit', getdate(), 785, getdate(), 785)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_RE') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'ND_RE','Client Non Deposit Process Record Reopened', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_RC') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'ND_RC','Pending to recontact client', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_DC') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'ND_DC','Client Deposit Collected', getdate(), 785, getdate(), 785)
end
if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_UN') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'ND_UN','Client unable to make deposit', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_NA') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'ND_NA','Closed for no client action', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_ER') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'ND_ER','Created in Error', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'ND_CQ') begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'ND_CQ','Cancellation Request', getdate(), 785, getdate(), 785)
end


--End MatterStatus

Declare @MatterSubStatusId INT;
--Start MatterSubSTatus
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Contact Client') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'Pending Contact Client','Pending to Contact Client', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Recontact Client') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Pending Recontact Client','Pending to Recontact Client', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Client Unable Deposit') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'Client Unable Deposit','Client is unable to send deposit', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Pending Client Deposit') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Pending Client Deposit','Waiting for client to send replacement deposit', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Replacement Deposit Collected') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'Replacement Deposit Collected','Client deposit has been collected ', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
end
if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Closed for Inaction') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'Closed for Inaction','Non deposit closed for lack of activity', getdate(), 785, getdate(), 785)
	
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
	
	if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Cancellation Requested') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(2,'Cancellation Requested','Non deposit client requests to cancel', getdate(), 785, getdate(), 785)
	
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(5,@MatterSubStatusId)
end

--End MatterSubStatus
if not exists (select 1 from tblTaskTypeCategory where [Name] = 'NonDeposit') begin
	INSERT INTO tblTaskTypeCategory([Name], Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES('NonDeposit', getdate(), 785, getdate(), 785)
end

SET @TaskTypeCategory = (select TaskTypeCategoryId from tblTaskTypeCategory where [Name] = 'NonDeposit');

if not exists (select 1 from tblTaskType where [Name] = 'Contact Client - NonDeposit') begin
	INSERT INTO tblTaskType(TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, TaskInstruction)
	VALUES(@TaskTypeCategory, 'Contact Client - NonDeposit', 'Call the client for non deposit', getdate(), 1480, getdate(), 1480,null)
end

if not exists (select 1 from tblTaskType where [Name] = 'Recontact Client - NonDeposit') begin
	INSERT INTO tblTaskType(TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, TaskInstruction)
	VALUES(@TaskTypeCategory, 'Recontact Client - NonDeposit', 'Call the client because replacement for non deposit failed', getdate(), 1480, getdate(), 1480,null)
end



--End sub reasons

--Scan Relations
if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 48) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('matter', 48);
end

if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 214) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
	VALUES('matter', 214);
end

if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 215) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
	VALUES('matter', 215);
end

if not exists (select 1 from tblScanRelation where RelationType = 'matter' and DocumentTypeId = 216) begin	
	INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
	VALUES('matter', 216);
end
GO 

if not exists(select 1 from tblFunction where FullName = 'Non Deposit') begin
	INSERT INTO tblFunction([Name], FullName, IsSystem, IsOPeration)
	VALUES('NonDeposit', 'Non Deposit', 0, 0)
end
GO

if not exists(select 1 from tblFunction where FullName = 'Non Deposit-Change Resolve') begin
	INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
	VALUES('NonDeposit', 264, 'Non Deposit-Change Resolve', 0, 0)
end

if not exists(select 1 from tblFunction where FullName = 'Non Deposit-Close created in error') begin
	INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
	VALUES('NonDeposit', 264, 'Non Deposit-Close created in error', 0, 0)
end

if not exists(select 1 from tblFunction where FullName = 'Non Deposit-Close created in error') begin
	INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
	VALUES('NonDeposit Close Created in Error', 264, 'Non Deposit-Close created in error', 0, 0)
end

if not exists(select 1 from tblFunction where FullName = 'Non Deposit-Manage Exceptions') begin
	INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
	VALUES('NonDeposit Manage Exceptions ', 264, 'Non Deposit-Manage Exceptions', 0, 0)
end

if not exists(select 1 from tblFunction where FullName = 'Non Deposit-Pending Cancellations') begin
	INSERT INTO tblFunction([Name], ParentFunctionId, FullName, IsSystem, IsOPeration)
	VALUES('NonDeposit-Pending Cancellations', 264, 'Non Deposit-Pending Cancellations', 0, 0)
end
GO

delete from tblNonDepositType
Insert Into tblNonDepositType(NonDepositTypeId,  ShortDescription, Description)
Values(1, 'Missed', 'Deposit Missed')
Insert Into tblNonDepositType(NonDepositTypeId, ShortDescription, Description)
Values(2, 'Bounced', 'Deposit Bounced')

GO