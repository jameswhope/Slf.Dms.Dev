declare @id int
select @id = functionid from tblfunction where fullname = 'Settlement Processing'

insert tblfunction (parentfunctionid,name,fullname,issystem,isoperation)
values (@id,'Scheduled Payments To Approve','Settlement Processing-Scheduled Payments To Approve',0,0)