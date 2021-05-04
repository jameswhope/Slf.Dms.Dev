If NOT Exists(Select UserGroupId From tblUserGroup Where Name Like '%Retention%')
BEGIN
Insert Into tblusergroup(Name, Created, CreatedBy, LastModified, LastModifiedBy)
Values('Retention Team', GetDate(), 27, GetDate(), 27)
insert into tblUserTypeXref(usertypeid, usergroupId) values(1,27)
END

GO 