DELETE FROM tblTaskType WHERE [Name] = 'Client Stipulation Approval'
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Client Stipulation Approval','Get Client Approval for Settlement Stipulation',getdate(),750,getdate(),750,null)



delete from tblMatterSubStatus where MatterSubStatusDescr='Pending Client approval of stipulation'
insert into tblMatterSubStatus(MatterStatusId,MatterSubStatus,MatterSubStatusDescr,Created,CreatedBy,lastModified,lastModifiedBy,[Order])
values (3,'Pending Client Stipulation','Pending Client approval of stipulation',getdate(),750,getdate(),750,null)
