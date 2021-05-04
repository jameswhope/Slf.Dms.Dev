
if not exists (select 1 from syscolumns where id = object_id('tblNachaFile') and name = 'DateSent') begin
	alter table tblNachaFile add DateSent datetime null
end  