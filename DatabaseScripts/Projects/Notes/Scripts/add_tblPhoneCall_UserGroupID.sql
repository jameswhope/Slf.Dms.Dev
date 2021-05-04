
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblPhoneCall' AND COLUMN_NAME = 'UserGroupID')
BEGIN
   alter table tblPhoneCall add UserGroupID int null
END
 