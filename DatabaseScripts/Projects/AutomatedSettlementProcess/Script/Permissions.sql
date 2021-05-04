
if not exists (select 1 from tblfunction where name = 'Settlement Processing') begin
	insert tblfunction (name,fullname,issystem,isoperation)
	values ('Settlement Processing','Settlement Processing',0,0)

	declare @id int
	select @id = scope_identity()
	
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (@id,'Open Settlements','Settlement Processing-Open Settlements',0,0)	
	
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (@id,'Payments Override','Settlement Processing-Payments Override',0,0)
	
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (@id,'Payments To Approve','Settlement Processing-Payments To Approve',0,0)
	
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (@id,'Checks To Print','Settlement Processing-Checks To Print',0,0)
	
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (@id,'Check Tracking','Settlement Processing-Checks Tracking',0,0)
	
	insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
	values (@id,'Checks By Phone','Settlement Processing-Checks By Phone',0,0)
end 

