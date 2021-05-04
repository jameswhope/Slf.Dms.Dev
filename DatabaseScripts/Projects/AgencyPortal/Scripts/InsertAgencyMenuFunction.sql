
/*
	Steps:
	1. Run script
	2. Login as admin, go to Group Permissions and set this function to View
	3. Login as avert to build permission tables
*/
if not exists (select 1 from tblfunction where fullname = 'Home-Agency Menu') begin
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (3,'Agency Menu','Home-Agency Menu',1,0)
end