﻿ SET IDENTITY_INSERT tblUser ON
INSERT INTO tblUser
(
UserID,
UserName,
[Password],
FirstName,
LastName,
EmailAddress,
SuperUser,
Locked,
Temporary,
[System],
Created,
CreatedBy,
LastModified,
LastModifiedBy,
UserTypeID,
AgencyID,
Manager,
CompanyID)
VALUES
(28,
'NightlyProcessing',
'Locked12345',
'Nightly Processing',
'Procedures',
'locked@dmsisupport.com',
0,
1,
1,
1,
getdate(),
493,
getdate(),
493,
4,
-1,
0,
-1
)