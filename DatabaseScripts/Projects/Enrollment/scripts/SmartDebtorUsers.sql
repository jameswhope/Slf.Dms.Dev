--Update tblUser to add groupid 25 (Consultants) to the Smart Debtor Users

UPDATE tbluser SET usergroupid = 25 WHERE username IN
(
'ebotello',
'eturner',
'thoffman',
'jcook',
'cjohnson',
'chealy',
'cmercer',
'WDeLaCruz',
'jgrant',
'ipastrano'
)

--Update tblUser to add groupid 24 (Law Firm Rep) to the Smart Debtor Users
UPDATE tbluser SET usergroupid = 24 WHERE username IN
(
'kcook',
'jsantistevan',
'dfuller',
'hbates',
'parguello',
'mmota',
'cpryor',
'ssapien',
'slopez'
)

--Insert Enrollment Consultant into tblUserGroup
IF NOT EXISTS (SELECT * FROM tblUserGroup WHERE Name = 'Enrollment Consultant'
BEGIN
INSERT INTO tblUserGroup 
(
Name, 
Created, 
CreatedBy, 
LastModified, 
LastModifiedBy, 
DefaultPage
)
VALUES
(
'Enrollment Consultant',
getdate(),
493,
getdate(),
493,
'~/Clients/Enrollment/Default.aspx'
)
END

--Insert Enrollment Law Firm Rep into tblUserGroup
IF NOT EXISTS (SELECT * FROM tblUserGroup WHERE Name = 'Enrollment Law Firm Rep'
BEGIN
INSERT INTO tblUserGroup 
(
Name, 
Created, 
CreatedBy, 
LastModified, 
LastModifiedBy, 
DefaultPage
)
VALUES
(
'Enrollment Law Firm Rep',
getdate(),
493,
getdate(),
493,
'~/Clients/Enrollment/Default.aspx'
)
END

--Insert cross referance to Consultant in tblUserXref
IF NOT EXISTS (SELECT * FROM tblUserXref WHERE UserTypeID = 1 AND UserGroupID = 24
BEGIN
INSERT INTO tblUserXref
(
UserTypeID,
UserGroupID
)
VALUES
(
1,
24
)
END

--Insert cross referance to Law Firm Rep in tblUserXref
IF NOT EXISTS (SELECT * FROM tblUserXref WHERE UserTypeID = 1 AND UserGroupID = 25
BEGIN
INSERT INTO tblUserXref
(
UserTypeID,
UserGroupID
)
VALUES
(
1,
25
)
END