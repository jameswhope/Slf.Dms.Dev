 if not exists (select 1 from syscolumns where id = object_id('tblNachaRegister2') and name = 'Notes') begin
	alter table tblNachaRegister2 add Notes varchar(255) null
end
if not exists (select 1 from syscolumns where id = object_id('tblNachaRegister') and name = 'Notes') begin
	alter table tblNachaRegister add Notes varchar(255) null
end