-- Ran in prod 7/15/10 (jh)

-- select * from tblMatterGroup
SET IDENTITY_INSERT tblMatterGroup ON

INSERT INTO tblMatterGroup(MatterGroupId, MatterGroup,MattergRoupDescr,Created,CreatedBy,LastModified,LastModifiedBy)
VALUES(3,'Settlement','For Settlements',getdate(),1460,getdate(),1460)

SET IDENTITY_INSERT tblMatterGroup OFF
GO

-- select * from tblTaskTypeCategory
INSERT INTO tblTaskTypeCategory( [Name], Created, CreatedBy, LastModified, LastModifiedBy)
VALUES( 'Settlement', getdate(), 1460,getdate(), 1460)
GO


Declare @TaskCategory int;
SET @TaskCategory = (SELECT TaskTypeCategoryId FROM tblTaskTypeCategory WHERE [Name] = 'Settlement');

set identity_insert tblTaskType on

INSERT INTO tblTaskType(tasktypeid, TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, taskinstruction)
VALUES(71, @TaskCategory,'Settlement Verification' , 'Verify the Settlement with SIF Data' , getdate(), 1460, getdate(), 1460, '')

INSERT INTO tblTaskType(tasktypeid, TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, taskinstruction)
VALUES(72, @TaskCategory,'Client Approval' , 'Get Client Approval for settlement' , getdate(), 1460, getdate(), 1460, '')

INSERT INTO tblTaskType(tasktypeid, TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, taskinstruction)
VALUES(73, @TaskCategory,'Payment Processing' , 'Process the payment associated with a settlement' , getdate(), 1460, getdate(), 1460, '')

INSERT INTO tblTaskType(tasktypeid, TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, taskinstruction)
VALUES(74, @TaskCategory,'Manager Approval' , 'Manager must approve the settlement' , getdate(), 1460, getdate(), 1460, '')

INSERT INTO tblTaskType(tasktypeid, TaskTypeCategoryId, [Name], DefaultDescription, Created, CreatedBy, LastModified, LastModifiedBy, taskinstruction)
VALUES(75, @TaskCategory,'Local Counsel Approval' , 'Settlement to be approved by Local Counsel' , getdate(), 1460, getdate(), 1460, '')

set identity_insert tblTaskType off

-- select * from tblMatterType
INSERT INTO tblMatterType(MatterTypeCode, MatterTypeShortDescr, IsActive, Created, CreatedBy, LastModified, LastModifiedBy, MatterGroupId)
VALUES('Settlement', 'Settlement', 1, getdate(), 1460, getdate(), 1460, 3)

-- select * from tblMatterTypeTaskXRef
Declare @MatterType int, @Task1 int, @Task2 int, @Task3 int, @Task4 int;
set @MatterType = (select MatterTypeId FROM tblMatterType where MatterTypeCode = 'Settlement');
set @Task1 = (select TaskTypeId from tblTaskType where [Name] = 'Settlement Verification');
set @Task2 = (select TaskTypeId from tblTaskType where [Name] = 'Payment Processing');
set @Task3 = (select TaskTypeId from tblTaskType where [Name] = 'Client Approval');
set @Task4 = (select TaskTypeId from tblTaskType where [Name] = 'Manager Approval');

INSERT INTO tblMatterTypeTaskXRef(MatterTypeId, TaskTypeId, IsAuto)
VALUES(@MatterType, @Task2, 0)
INSERT INTO tblMatterTypeTaskXRef(MatterTypeId, TaskTypeId, IsAuto)
VALUES(@MatterType, @Task1, 0)
INSERT INTO tblMatterTypeTaskXRef(MatterTypeId, TaskTypeId, IsAuto)
VALUES(@MatterType, @Task3, 0)
INSERT INTO tblMatterTypeTaskXRef(MatterTypeId, TaskTypeId, IsAuto)
VALUES(@MatterType, @Task4, 0) 
GO

-- END ran in prod 7/15/10 (jh)


if not exists (select 1 from tblMattergroupUserGroupXRef where mattergroupid = 3) begin
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(3,3) -- Client Services Personnel
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(3,22) -- Creditor Services Processing
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(3,19) -- Mediation Personnel
	INSERT INTO tblMattergroupUserGroupXRef(MatterGroupId, UserGroupId)
	VALUES(3,35) -- Local Council
end


-- select * from tblClientRejectionReason where reasonname like 'client %'
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client Declined', 'Client declined the settlements due to the terms')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client cannot come up with Shortage', 'Client cannot come up with Shortage')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client chose a different settlement', 'Client decide to approve another open settlement')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client wants to settle a legal account', 'Client wants to first settle a legal account')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client wants to settle a different account', 'Client wants to settle a non-legal account first')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client is cancelling services', 'Client decided to cancel the services')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Client is removing the account', 'Client is removing the account')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Account recalled by creditor', 'Account has been recalled by the creditor')
INSERT INTO tblClientRejectionReason(ReasonName, ReasonDesc)
VALUES('Offer Expired', 'The offer made to the client has expired')
GO

UPDATE tblDocumentType SET DisplayName = 'Settlement Acceptance Form(Signed)', lastmodified = getdate(), lastmodifiedby = 1460 WHERE TypeId = 'D6004SCAN'
GO

if not exists (select 1 from tblDocumentType where typeid = 'D9011') begin
	INSERT INTO tblDocumentType(TypeID, TypeName, DisplayName, DocFolder, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES('D9011', 'SettlementCheck', 'Settlement Check', 'CreditorDocs', getdate(), 1460, getdate(), 1460)
end

if not exists (select 1 from tblLetters_TemplateInfo where TemplateDocTypeId = 'D9011') begin
	INSERT INTO tblLetters_TemplateInfo(TemplateDocTypeId, TemplateTypeName, TemplateType, TemplateDocFolder, TemplateDisplayName, TemplateArguments, TemplatePackages, RequiredFieldsList, DisplayTemplate)
	VALUES('D9011', 'SettlementCheck', 1, 'CreditorDocs', 'Settlement Check', 'DocumentType,SettlementID,CheckNumber,ChcekAmountText,UserID' , 'Creditor', 'DocumentType,SettlementID,CheckNumber,ChcekAmountText', 0)
end

-- select * from tblMatterStatusCode
SET IDENTITY_INSERT tblMatterStatusCode ON

INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(22,1,'Pending Verification','The settlement is pending verification', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(23,1,'Pending Client Approval','The settlement is pending clients approval', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(24,1,'Client Approved','Client has approved the settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(25,2,'Client Rejected','The client has rejected the settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(26,1,'Pending Payment Processing','The settlement payment needs to be processed', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(27,1,'Waiting Manager Approval','The settlement is waiting for manager''s approval', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(28,1,'LC Recommended','The LC has recommended the settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(29,1,'LC Not Recommended','The LC has not recommended the settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(30,2,'Verification Failed','The verification of the settlement was rejected', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(31,1,'Verification Completed','The verification of settlement is completed', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(32,1,'Manager  Approved','Manager Approved the Overriding of settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(33,2,'Manager  Rejected','Manager rejected the Overriding of settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(34,1,'Generate Check For Processing','Generating a check for the payment is completed', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(35,1,'Waiting In Print Queue','Waiting for the check to be printed', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(36,1,'Waiting In Confirmation Queue','waiting to confirm that the settlement is processed', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(37,1,'Settlement Processing Completed','Completed the process and posted the settlement amount to the creditor', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(38,3,'Pending Accounting Approval','Accounting department has to approve the payment', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(39,3,'Pending Phone Processing','The payment has to be processed using Check by phone', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(40,3,'Pending Email Processing','The payment has to be processed via EMail', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(41,2,'Accounting Rejected','Accounting dept rejected the payment', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(42,2,'Client Cancelled Settlement','Client cancelled the settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterStatusCode(MatterStatusCodeId, MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(43,2,'Settlement Expired','Settlement Expired', getdate(), 1460, getdate(), 1460)

SET IDENTITY_INSERT tblMatterStatusCode OFF
GO

-- select * from tblNegotiationSettlementStatus
--SET IDENTITY_INSERT tblNegotiationSettlementStatus ON

--INSERT INTO tblNegotiationSettlementStatus(SettlementStatusId, ParentSettlementStatusId, [NAme], Code,[Order], Created, CreatedBy, LastModified, LastModifiedBy)
--VALUES(15,7,'Manager Accepted', 'MA', 11,getdate(),1460, getdate(), 1460)
--INSERT INTO tblNegotiationSettlementStatus(SettlementStatusId, ParentSettlementStatusId, [NAme], Code, [Order], Created, CreatedBy, LastModified, LastModifiedBy)
--VALUES(16,7,'Manager Rejected', 'MR', 12,getdate(),1460, getdate(), 1460)
--INSERT INTO tblNegotiationSettlementStatus(SettlementStatusId,ParentSettlementStatusId, [Name], Code, [Order], Created, CreatedBy, LastModified, LAstModifiedBy)
--VALUES(17,NULL, 'Payment Dept', 'pay', 13, getdate(), 1460, getdate(), 1460)
--INSERT INTO tblNegotiationSettlementStatus(SettlementStatusId,ParentSettlementStatusId, [Name], Code, [Order], Created, CreatedBy, LastModified, LAstModifiedBy)
--VALUES(18,17, 'Waiting in Print Queue', 'PQ', 14, getdate(), 1460, getdate(), 1460)
--INSERT INTO tblNegotiationSettlementStatus(SettlementStatusId,ParentSettlementStatusId, [Name], Code, [Order], Created, CreatedBy, LastModified, LAstModifiedBy)
--VALUES(19,17, 'Waiting For Settlement Confirmation', 'CS', 15, getdate(), 1460, getdate(), 1460)
--INSERT INTO tblNegotiationSettlementStatus(SettlementStatusId,ParentSettlementStatusId, [Name], Code, [Order], Created, CreatedBy, LastModified, LAstModifiedBy)
--VALUES(20,17, 'Settlement Processing Completed', 'SPC', 16, getdate(), 1460, getdate(), 1460)

SET IDENTITY_INSERT tblNegotiationSettlementStatus OFF
GO

-- select * from tblMatterSubStatus
SET IDENTITY_INSERT tblMatterSubStatus ON

INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(50,3,'Pending Verification','The settlement is pending verification', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(51,3,'Pending Client Approval','The settlement is pending clients approval', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(52,1,'Client Approved','Client has approved the settlement', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(53,2,'Client Rejected','The client has rejected the settlement', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(54,3,'Pending Payment Processing','The settlement payment needs to be processed', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(55,3,'Waiting Manager Approval','The settlement is waiting for manager''s approval', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(56,1,'LC Recommended','The LC has recommended the settlement', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(57,1,'LC Not Recommended','The LC has not recommended the settlement', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(58,2,'Verification Failed','The verification of the settlement was rejected', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(59,1,'Verification Completed','The verification of settlement is completed', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(60,1,'Manager Approved','Manager Approved the Overriding of settlement', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(61,2,'Manager  Rejected','Manager rejected the Overriding of settlement', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(62,1,'Generate Check For Processing','Generating a check for the payment is completed', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(63,3,'Waiting In Print Queue','Waiting for the check to be printed', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(64,3,'Waiting In Confirmation Queue','waiting to confirm that the settlement is processed', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(65,4,'Settlement Processing Completed','Completed the process and posted the settlement amount to the creditor', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(67, 3,'Pending Accounting Approval','Accounting department has to approve the payment', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(66, 3,'Pending Phone Processing','The payment has to be processed using Check by phone', getdate(), 1460, getdate(), 1460 )
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(68, 3,'Pending Email Processing','The payment has to be processed via EMail', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(69, 2,'Accounting Rejected','Accounting Dept rejected the payment', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(70, 2,'Client Cancelled Settlement','Client Cancelled Settlement', getdate(), 1460, getdate(), 1460)
INSERT INTO tblMatterSubStatus(MatterSubStatusId, MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES(71, 2,'Settlement Expired','Settlement Expired', getdate(), 1460, getdate(), 1460)
SET IDENTITY_INSERT tblMatterSubStatus OFF
GO

-- select * from tblCompanyAddressTypes
SET IDENTITY_INSERT tblCompanyAddressTypes ON

INSERT INTO tblCompanyAddressTypes(AddressTypeID, AddressTypeName, date_Created)
VALUES(7,'Check', getdate())

SET IDENTITY_INSERT tblCompanyAddressTypes OFF
GO

INSERT INTO tblCompanyAddresses(AddressTypeID, CompanyID, Address1, Address2, City, State, ZipCode, date_created)
VALUES(7,1, 'The Seidaman Law Firm', '701 Commerce Street, Suite 400', 'Dallas', 'TX', 75202, getdate())
INSERT INTO tblCompanyAddresses(AddressTypeID, CompanyID, Address1, Address2, City, State, ZipCode, date_created)
VALUES(7,2, 'The Palmer Firm, P.C.', '900 N. Zang Blvd.', 'Dalls', 'TX', 75208, getdate())
INSERT INTO tblCompanyAddresses(AddressTypeID, CompanyID, Address1, Address2, City, State, ZipCode, date_created)
VALUES(7,3, 'Lexxiom Payment Systems', '11690 Pacific Avenue', 'Fontana', 'CA', 92337, getdate())
INSERT INTO tblCompanyAddresses(AddressTypeID, CompanyID, Address1, Address2, City, State, ZipCode, date_created)
VALUES(7,4, 'Lexxiom Payment Systems', '11690 Pacific Avenue', 'Fontana', 'CA', 92337, getdate())
INSERT INTO tblCompanyAddresses(AddressTypeID, CompanyID, Address1, Address2, City, State, ZipCode, date_created)
VALUES(7,5, 'Lexxiom Payment Systems', '11690 Pacific Avenue', 'Fontana', 'CA', 92337, getdate())
INSERT INTO tblCompanyAddresses(AddressTypeID, CompanyID, Address1, Address2, City, State, ZipCode, date_created)
VALUES(7,6, 'Lexxiom Payment Systems', '11690 Pacific Avenue', 'Fontana', 'CA', 92337, getdate())

INSERT INTO tblCompanyTrust(CompanyID, BankDisplayName, Street, City, StateId, Zip, RoutingNumber, AccountNumber)
VALUES(1, 'Branch Banking and Trust', '717 N Harwood St, Suite 100', 'Dallas', '45',75201, 1111111111, 12345)
INSERT INTO tblCompanyTrust(CompanyID, BankDisplayName, Street, City, StateId, Zip, RoutingNumber, AccountNumber)
VALUES(2, 'Branch Banking and Trust', '717 N Harwood St, Suite 100', 'Dallas', '45', 75201,1111111111, 12345)
INSERT INTO tblCompanyTrust(CompanyID, BankDisplayName, Street, City, StateId, Zip, RoutingNumber, AccountNumber)
VALUES(3, 'Bank Of America', '100 North Tyron Street', 'Charlotte', '34', 28255,1111111111, 12345)
INSERT INTO tblCompanyTrust(CompanyID, BankDisplayName, Street, City, StateId, Zip, RoutingNumber, AccountNumber)
VALUES(4, 'Bank Of America', '100 North Tyron Street', 'Charlotte', '34', 28255,1111111111, 12345)
INSERT INTO tblCompanyTrust(CompanyID, BankDisplayName, Street, City, StateId, Zip, RoutingNumber, AccountNumber)
VALUES(5, 'Bank Of America', '100 North Tyron Street', 'Charlotte', '34', 28255,1111111111, 12345)
INSERT INTO tblCompanyTrust(CompanyID, BankDisplayName, Street, City, StateId, Zip, RoutingNumber, AccountNumber)
VALUES(6, 'Bank Of America', '100 North Tyron Street', 'Charlotte', '34', 28255,1111111111, 12345)
GO


-- *** get starting check numbers from Greg B. ***
if not exists (select 1 from tblProperty where name = 'SeidamanCheckNumber') begin
	insert tblproperty (propertycategoryid,name,display,nullable,multi,value,type,description,created,createdby,lastmodified,lastmodifiedby)
	values (4,'SeidamanCheckNumber','Current Check Number for Seidaman',0,0,'0050243','Number','The number assigend to the latest check',getdate(),820,getdate(),820)
end

if not exists (select 1 from tblProperty where name = 'PalmerCheckNumber') begin
	insert tblproperty (propertycategoryid,name,display,nullable,multi,value,type,description,created,createdby,lastmodified,lastmodifiedby)
	values (4,'PalmerCheckNumber','Current Check Number for Palmer',0,0,'0090001','Number','The number assigend to the latest check',getdate(),820,getdate(),820)
end

if not exists (select 1 from tblProperty where name = 'BOFACheckNumber') begin
	insert tblproperty (propertycategoryid,name,display,nullable,multi,value,type,description,created,createdby,lastmodified,lastmodifiedby)
	values (4,'BOFACheckNumber','Current Check Number for BOFA Customers',0,0,'0020016','Number','The number assigend to the latest check',getdate(),820,getdate(),820)
end

Insert Into tblEmailConfiguration(MailFrom, MailSubject, MailPurpose, MailContent, MailFooter, MType, CreatedBy, 
CreatedDate, LastModifiedBy, LastModifiedDate, LawFirmId)
Values('{FirmName<noreply@lawfirmsd.com>', 'Checks To Be Processed', 'Email To Process Settlement Checks',
'<table style=''width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2'' cellpadding=''8'' cellspacing=''0''><tr><td><h2>{FirmName}</h2></td></tr><tr><td>{FirmName}</td></tr><tr><td>{FirmStreet}</td></tr><tr><td>{FirmAddress}</td></tr><tr><td></td></tr><tr><td>{BankDisplay}</td></tr><tr><td>{BankStreet}</td></tr><tr><td>{BankAddress}</td></tr><tr><td></td></tr></table><table style=''width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2'' cellpadding=''8'' cellspacing=''0''><tr><td>Routing # :</td><td>{Routing}</td></tr><tr><td>Account # :</td><td>{AccountNumber}</td></tr><tr><td></td><td></td></tr><tr><td>Client Name :</td><td>{ClientName}</td></tr><tr><td>Pay To :</td><td>{CreditorName}</td></tr><tr><td>Acct # :</td><td>{CreditorAccount}</td></tr><tr><td></td><td></td></tr><tr><td>Check Number :</td><td>{CheckNumber}</td></tr><tr><td>Amount :</td><td>{Amount}</td></tr><tr><td></td><td></td></tr></table><table><tr><td style=''background-color: #326FA2; padding-top:30px'' align=''right''><img src=''{0}://{1}/public/images/poweredby.png'' /></td></tr></table>',
'The information contained in this transmission may contain privileged and confidential information. It is intended only for the use of the person(s) named above. If you are not the intended recipient, you are hereby notified that any review, dissemination, distribution or duplication of this communication is strictly prohibited. If you are not the intended recipient, please contact the sender by reply email and destroy all copies of the original message.',
'M', 1, getdate(),1,getdate(),0)

INSERT INTO tblAccountStatus(Code, [Description], [System], Display, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES('SP', 'Settlement Pending', 0, 1, getdate(), 1460, getdate(), 1460)
GO

INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('matter', 295)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('client', 295)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('account', 295)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('note', 295)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('phonecall', 295)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('account', 176)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('matter', 176)
INSERT INTO tblScanRelation(RelationType, DocumentTypeId)
VALUES('client', 176)
GO

--New Data for Client Stipulation
INSERT INTO tblDocumentType(TypeID, TypeName, DisplayName, DocFolder, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES('D9022SCAN', 'SignedClientStipulationSCAN', 'Client Stipulation Letter (Signed)', 'CreditorDocs', getdate(), 1480, getdate(), 1480)
INSERT INTO tblDocumentType(TypeID, TypeName, DisplayName, DocFolder, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES('D9022', 'SignedClientStipulation', 'Client Stipulation Letter', 'CreditorDocs', getdate(), 1480, getdate(), 1480)

DECLARE @DocTypeId INT;
SET @DocTypeId = (SELECT DocumentTypeID FROM tblDocumentType WHERE TypeID = 'D9022SCAN')
INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('account', @DocTypeId)
INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('matter', @DocTypeId)
INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('note', @DocTypeId)
GO