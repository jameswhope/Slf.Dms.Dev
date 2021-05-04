If NOT Exists(Select UserId From tblUser Where UserId = 26)
BEGIN
SET IDENTITY_INSERT tblUser ON 


INSERT INTO tblUser(UserID,UserName,Password,FirstName, LastName,
EmailAddress, SuperUser, Locked, Temporary, System, Created, CreatedBy, LastModified, LastModifiedBy, UserTypeId, UserGroupID, CommRecID, AgencyID, Manager)
VALUES (26,	'ImportClientService',	'locked12345',	'Import Client Service', 'Engine',
'locked@dmsisupport.com',	0,	1,	1,	1,	GetDate(),	1,	GetDate(),	1,	4,	NULL,	NULL,	-1, 0)

SET IDENTITY_INSERT tblUser OFF
END

GO