
if not exists (select 1 from syscolumns where id = object_id('tblNachaCabinet') and [name] = 'TrustID') begin
	alter table tblNachaCabinet add TrustID int
end
go

update tblNachaCabinet
set TrustID = 20 -- Colonial
where TrustID is null
go