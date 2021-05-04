 --New Data for Client Stipulation
If not exists( SElect * from tblDocumentType where typeid =  'D9022SCAN')
BEGIN
INSERT INTO tblDocumentType(TypeID, TypeName, DisplayName, DocFolder, Created, CreatedBy, LastModified, LastModifiedBy)
VALUES('D9022SCAN', 'SignedClientStipulationSCAN', 'Client Stipulation Letter (Signed)', 'CreditorDocs', getdate(), 1480, getdate(), 1480)
--INSERT INTO tblDocumentType(TypeID, TypeName, DisplayName, DocFolder, Created, CreatedBy, LastModified, LastModifiedBy)
--VALUES('D9022', 'SignedClientStipulation', 'Client Stipulation Letter', 'CreditorDocs', getdate(), 1480, getdate(), 1480)

DECLARE @DocTypeId INT;
SET @DocTypeId = (SELECT DocumentTypeID FROM tblDocumentType WHERE TypeID = 'D9022SCAN')
INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('account', @DocTypeId)
INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('matter', @DocTypeId)
INSERT INTO tblScanRelation(RelationType, DocumentTypeID)
VALUES('note', @DocTypeId)
END

declare @MatterSubStatusId int

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'Attach Client Signed Stipulation') 
begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'Attach Client Signed Stipulation','Pending Client Signature of Stiplulation Letter', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Attach Client Signed Stipulation') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Attach Client Signed Stipulation','Pending Client Signature of Stiplulation Letter', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(3,@MatterSubStatusId)
end

if not exists (select 1 from tblMatterStatusCode where MatterStatusCode = 'Payment Arrangement') 
begin
	INSERT INTO tblMatterStatusCode(MatterSubStatusCodeId, MatterStatusCode, MatterStatusCodeDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(1,'Payment Arrangement','Pending payment arrangement', getdate(), 785, getdate(), 785)
end

if not exists (select 1 from tblMatterSubStatus where MatterSubStatus = 'Payment Arrangement') begin
	INSERT INTO tblMatterSubStatus(MatterStatusId, MatterSubStatus, MatterSubStatusDescr, Created, CreatedBy, LastModified, LastModifiedBy)
	VALUES(3,'Payment Arrangement','Pending payment arrangement', getdate(), 785, getdate(), 785)
	
	SET @MatterSubStatusId = SCOPE_IDENTITY()
	
	INSERT INTO tblMatterTypeSubStatus(MatterTypeId, MatterSubStatusId)
	VALUES(3,@MatterSubStatusId)
end

