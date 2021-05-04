 
if not exists (select 1 from syscolumns where id = object_id('tblNachaRegister') and name = 'ClientID') begin
	alter table tblNachaRegister add ClientID int null
end 

if not exists (select 1 from syscolumns where id = object_id('tblNachaRegister') and name = 'RegisterID') begin
	alter table tblNachaRegister add RegisterID int
end 