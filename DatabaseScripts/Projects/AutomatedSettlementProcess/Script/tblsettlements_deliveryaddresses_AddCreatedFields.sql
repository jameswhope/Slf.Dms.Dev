
if not exists (select 1 from syscolumns where id = object_id('tblsettlements_deliveryaddresses') and name = 'Created') begin
	alter table tblsettlements_deliveryaddresses add Created datetime
end 

if not exists (select 1 from syscolumns where id = object_id('tblsettlements_deliveryaddresses') and name = 'CreatedBy') begin
	alter table tblsettlements_deliveryaddresses add CreatedBy int
end  
if not exists (select 1 from syscolumns where id = object_id('tblsettlements_deliveryaddresses') and name = 'ContactNumber') begin
	alter table tblsettlements_deliveryaddresses add ContactNumber varchar(30)
end  
if not exists (select 1 from syscolumns where id = object_id('tblsettlements_deliveryaddresses') and name = 'ContactName') begin
	alter table tblsettlements_deliveryaddresses add ContactName varchar(200)
end  