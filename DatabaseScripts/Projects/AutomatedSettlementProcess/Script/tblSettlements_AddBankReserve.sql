
if not exists (select 1 from syscolumns where id = object_id('tblSettlements') and name = 'SDABalance') begin
	alter table tblSettlements add SDABalance money 
end 

if not exists (select 1 from syscolumns where id = object_id('tblSettlements') and name = 'BankReserve') begin
	alter table tblSettlements add BankReserve money 
end 

if not exists (select 1 from syscolumns where id = object_id('tblSettlements') and name = 'AvailSDA') begin
	alter table tblSettlements add AvailSDA money 
end 

if not exists (select 1 from syscolumns where id = object_id('tblSettlements') and name = 'PFOBalance') begin
	alter table tblSettlements add PFOBalance money 
end 
if not exists (select 1 from syscolumns where id = object_id('tblSettlements') and name = 'SAFPrinted') begin
	alter table tblSettlements add SAFPrinted datetime 
end 





