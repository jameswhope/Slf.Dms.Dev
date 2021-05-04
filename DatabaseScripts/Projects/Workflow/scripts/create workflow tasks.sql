delete from tblTaskType where [Name] = 'Attach SIF'
DBCC CHECKIDENT ('tblTaskType', RESEED,78)
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Attach SIF','Attach Settle in Full document to settlement.',getdate(),750,getdate(),750,null) 

delete from tblTaskType where [Name] = 'Accounting Approval'
DBCC CHECKIDENT ('tblTaskType', RESEED,79)
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Accounting Approval','Get Accounting Approval for settlement',getdate(),750,getdate(),750,null) 

delete from tblTaskType where [Name] = 'Send Finalized Settlement Kit'
DBCC CHECKIDENT ('tblTaskType', RESEED,80)
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Send Finalized Settlement Kit','Send client a copy of all settlement documents.',getdate(),750,getdate(),750,null) 

delete from tblTaskType where [Name] = 'Attach SIF/CS'
DBCC CHECKIDENT ('tblTaskType', RESEED,81)
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Attach SIF/CS','Attach Settle in Full/Client Stipulation document to settlement.',getdate(),750,getdate(),750,null) 

delete from tblTaskType where [Name] = 'Send Client Stipulation to Client'
DBCC CHECKIDENT ('tblTaskType', RESEED,82)
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Send Client Stipulation to Client','Send Client Stipulation to client for signature.',getdate(),750,getdate(),750,null) 

delete from tblTaskType where [Name] = 'Attach Client Stipulation'
DBCC CHECKIDENT ('tblTaskType', RESEED,83)
insert into tblTaskType (TaskTypeCategoryID,[Name],DefaultDescription,Created,CreatedBy,LastModified,LastModifiedBy,TaskInstruction)
values (10,'Attach Client Stipulation','Attached signed Client Stipulation to settlement',getdate(),750,getdate(),750,null) 

