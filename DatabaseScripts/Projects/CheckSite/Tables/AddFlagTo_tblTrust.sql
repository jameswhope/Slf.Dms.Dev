IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblTrust' AND COLUMN_NAME = 'Flag')
BEGIN
	ALTER TABLE tblTrust ADD Flag CHAR(2)
END
go

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