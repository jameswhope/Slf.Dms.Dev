if not exists (select * from syscolumns where id=object_id('tbltrust') and name='Flag')
	begin
		alter table tbltrust add Flag char(3)
	end
else
	begin 
		alter table tbltrust alter column Flag char(3)
	end

if exists (select flag from tbltrust where trustid = 22)
	begin
		update tbltrust set flag = 'CKS' where trustid = 22
	end
else
	begin
		insert into tbltrust ([Name], [Default], City, StateID, RoutingNumber, AccountNumber, Created, CreatedBy, LastModified, LastModifiedby, Flag, Display, DisplayName)
		VALUES ('Lexxiom', 0, 'Fontanna', 5, '000000000', '123456789', getdate(), 24, getdate(), 24, 'CKS', 0, 'Lexxiom')
	end