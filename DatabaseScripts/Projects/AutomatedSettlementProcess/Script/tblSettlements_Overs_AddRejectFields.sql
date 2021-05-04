
if not exists (select 1 from syscolumns where id = object_id('tblSettlements_Overs') and name = 'Rejected') begin
	alter table tblSettlements_Overs add Rejected datetime
end 

if not exists (select 1 from syscolumns where id = object_id('tblSettlements_Overs') and name = 'RejectedBy') begin
	alter table tblSettlements_Overs add RejectedBy int
end 