
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblNote' AND COLUMN_NAME = 'UserGroupID')
BEGIN
   alter table tblNote add UserGroupID int null
END
