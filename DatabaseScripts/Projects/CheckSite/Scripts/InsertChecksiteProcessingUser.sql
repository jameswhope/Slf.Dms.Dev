If NOT Exists(Select UserId From tblUser Where UserId = 25)
BEGIN
SET IDENTITY_INSERT tblUser ON 


INSERT INTO tblUser(UserID,UserName,Password,FirstName, LastName,
EmailAddress, SuperUser, Locked, Temporary, System, Created, CreatedBy, LastModified, LastModifiedBy, UserTypeId, UserGroupID, CommRecID, AgencyID)
VALUES (25,	'ChecksiteEngine',	'locked12345',	'CheckSite Processing',	'Engine',
'locked@dmsisupport.com',	0,	1,	1,	1,	GetDate(),	1,	GetDate(),	1,	4,	NULL,	NULL,	-1)

SET IDENTITY_INSERT tblUser OFF
END

GO