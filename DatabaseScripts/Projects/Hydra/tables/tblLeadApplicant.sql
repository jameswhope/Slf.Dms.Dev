
if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'PublisherId') begin
	alter table tblLeadApplicant add PublisherId varchar(50)
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'Subdomain') begin
	alter table tblLeadApplicant add Subdomain varchar(30)
end  