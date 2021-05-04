 if not exists (select 1 from syscolumns where id = object_id('tblRegister') and name = 'NotC21') begin
	alter table tblRegister add NotC21 bit null
 end 
 
 go