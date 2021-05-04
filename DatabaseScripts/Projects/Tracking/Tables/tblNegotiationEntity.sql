
if not exists (select 1 from syscolumns where id = object_id('tblNegotiationEntity ') and name = 'LastRefresh') begin
	alter table tblNegotiationEntity add LastRefresh datetime default('1/1/1900') not null
end
if not exists (select 1 from syscolumns where id = object_id('tblNegotiationEntity ') and name = 'IsSupervisor') begin
	alter table tblNegotiationEntity add IsSupervisor bit null
end
