
if not exists (select 1 from syscolumns where id = object_id('tblUser') and name = 'CompanyID') begin
	alter table tblUser add CompanyID int default(-1) not null
end 
go 