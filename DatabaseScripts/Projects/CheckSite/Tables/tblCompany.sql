
if not exists (select 1 from syscolumns where id = object_id('tblCompany') and name = 'ControlledAccountName') begin
	alter table tblCompany add ControlledAccountName varchar(40)
end  
go

update tblCompany set ControlledAccountName = 'Iniguez General Clearing Account' where CompanyID = 3 
update tblCompany set ControlledAccountName = 'Mossler General Clearing Account' where CompanyID = 4 