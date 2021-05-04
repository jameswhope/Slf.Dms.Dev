
if not exists (select 1 from syscolumns where id = object_id('tblTrust') and name = 'Display') begin
	alter table tblTrust add Display bit
end 
go

if not exists (select 1 from syscolumns where id = object_id('tblTrust') and name = 'DisplayName') begin
	alter table tblTrust add DisplayName varchar(50)
end 
go

update tblTrust set Display = 0, DisplayName = [Name]
update tblTrust set Display = 1 where TrustID = 20