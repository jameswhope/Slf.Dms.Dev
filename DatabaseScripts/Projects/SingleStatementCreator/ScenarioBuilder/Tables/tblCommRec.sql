
if not exists (select 1 from syscolumns where id = object_id('tblCommRec') and name = 'AccountTypeID') begin
	alter table tblCommRec add AccountTypeID int	
end