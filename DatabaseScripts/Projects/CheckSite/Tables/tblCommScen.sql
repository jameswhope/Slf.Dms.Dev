 
if not exists (select 1 from syscolumns where id = object_id('tblCommScen') and name = 'RetentionFrom') begin
	alter table tblCommScen add RetentionFrom int default(0) not null
end

if not exists (select 1 from syscolumns where id = object_id('tblCommScen') and name = 'RetentionTo') begin
	alter table tblCommScen add RetentionTo int default(9999) not null
end