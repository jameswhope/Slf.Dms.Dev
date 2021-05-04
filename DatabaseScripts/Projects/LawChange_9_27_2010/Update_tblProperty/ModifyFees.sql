INSERT INTO tblProperty (PropertyCategoryID, [Name], Display, Nullable, Multi, Value, [Type], Description, Created, CreatedBy, LastModified, LastModifiedBy)
 VALUES (1, 'CDASereviceFee', 'CDA Service Fee', 0, 0, '0.00', 'Dollar Amount', 'This is the default fee charged as the CDA service fees', getdate(), 493, getdate(), 493)
 
 UPDATE tblProperty SET VALUE = '0.50' WHERE [Name] = 'EnrollmentSettlementPercentage' --was 0.33
 UPDATE tblProperty SET VALUE = '0.00' WHERE [Name] = 'EnrollmentInflation' --was 0.31
 UPDATE tblProperty SET VALUE = '60.00' WHERE [Name] = 'EnrollmentMaintenanceFeeCap' --was 80.00
 UPDATE tblProperty SET VALUE = '60.00' WHERE [Name] = 'EnrollmentMaintenanceFee' --was 25.00