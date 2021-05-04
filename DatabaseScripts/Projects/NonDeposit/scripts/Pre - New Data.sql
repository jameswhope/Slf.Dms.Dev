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