
if not exists (select 1 from syscolumns where id = object_id('tblCommBatchTransfer') and name = 'CompanyID') begin
	ALTER TABLE dbo.tblCommBatchTransfer ADD CompanyID int NULL
end 
go

if not exists (select 1 from syscolumns where id = object_id('tblCommBatchTransfer') and name = 'TrustID') begin
	ALTER TABLE dbo.tblCommBatchTransfer ADD TrustID int NULL
end 
go