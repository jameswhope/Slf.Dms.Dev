IF col_length('tblLeadCalculator', 'MaintenanceFeeCap') is null
	Alter table tblLeadCalculator Add MaintenanceFeeCap money null  
GO			
IF col_length('tblClient', 'MaintenanceFeeCap') is null
	Alter table tblClient Add MaintenanceFeeCap money null  		
GO
IF col_length('tblLeadCalculator', 'ServiceFeePerAcct') is null
	Alter table tblLeadCalculator Add ServiceFeePerAcct money null  
GO
IF col_length('tblLeadApplicant', 'EnrollmentPage') is null
	Alter table tblLeadApplicant Add EnrollmentPage varchar(50) null default 'newenrollment2.aspx' 
GO		
if not exists(Select PropertyId from tblproperty Where [Name] = 'EnrollmentMaintenanceFeeCap')
Begin
	Insert Into tblproperty (PropertyCategoryId, [Name], Display, Nullable, [Length], Multi, [Value], [Type], [Description], Created, CreatedBy, LastModified, LastModifiedBy)
	Values (1, 'EnrollmentMaintenanceFeeCap', 'Enrollment Maintenance Fee Cap', 1, NULL, 0, '60', 'Dollar Amount', 'Maximum monthly fee to be charged',GetDate(), 785, GetDate(), 785 )
End
GO
update tblLeadapplicant set
EnrollmentPage = 'newenrollment.aspx'
where  statusid = 7
if not exists(Select PropertyId from tblproperty Where [Name] = 'EnrollmentDepositIncrease')
Begin
	Insert Into tblproperty (PropertyCategoryId, [Name], Display, Nullable, [Length], Multi, [Value], [Type], [Description], Created, CreatedBy, LastModified, LastModifiedBy)
	Values (1, 'EnrollmentDepositIncrease', 'Enrollment Deposit Increase', 1, NULL, 0, '0.10', 'Dollar Amount', 'Used for the deposit/settlement percentage grid',GetDate(), 820, GetDate(), 820 )
End
GO