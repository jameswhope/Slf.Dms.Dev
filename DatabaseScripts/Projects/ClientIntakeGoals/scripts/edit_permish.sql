
if not exists (select 1 from tblfunction where fullname = '') begin
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (241,'Edit Goals','Client Intake-Edit Goals',0,0)
end 