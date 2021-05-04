if not exists (select 1 from syscolumns where id = object_id('tblKPI') and name = 'Fee30') begin
	alter table tblKPI add Fee30 decimal(18,2)
end 
if not exists (select 1 from syscolumns where id = object_id('tblKPI') and name = 'Fee60') begin
	alter table tblKPI add Fee60 decimal(18,2)
end 
if not exists (select 1 from syscolumns where id = object_id('tblKPI') and name = 'Fee90') begin
	alter table tblKPI add Fee90 decimal(18,2)
end 
if not exists (select 1 from syscolumns where id = object_id('tblKPI') and name = 'AvgFee') begin
	alter table tblKPI add AvgFee decimal(18,2)
end 

if not exists (select 1 from syscolumns where id = object_id('tblKPIDetail') and name = 'Fee30') begin
	alter table tblKPIDetail add Fee30 decimal(18,2)
end 
if not exists (select 1 from syscolumns where id = object_id('tblKPIDetail') and name = 'Fee60') begin
	alter table tblKPIDetail add Fee60 decimal(18,2)
end 
if not exists (select 1 from syscolumns where id = object_id('tblKPIDetail') and name = 'Fee90') begin
	alter table tblKPIDetail add Fee90 decimal(18,2)
end 
if not exists (select 1 from syscolumns where id = object_id('tblKPIDetail') and name = 'AvgFee') begin
	alter table tblKPIDetail add AvgFee decimal(18,2)
end 