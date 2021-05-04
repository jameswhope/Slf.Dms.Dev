 
if not exists (select 1 from syscolumns where id = object_id('tblClient') and name = 'BankReserve') begin
	alter table tblClient add BankReserve money 
end 

if not exists (select 1 from syscolumns where id = object_id('tblClient') and name = 'AvailableSDA') begin
	alter table tblClient add AvailableSDA money 
end 