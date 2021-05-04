
if not exists (select 1 from syscolumns where id = object_id('tblRoutingNumber') and name = 'ModifiedDate') begin
	alter table tblRoutingNumber add ModifiedDate datetime
end 