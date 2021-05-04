
if not exists (select 1 from syscolumns where id = object_id('tblCommRec') and name = 'ParentCommRecID') begin
	alter table tblCommRec add ParentCommRecID int null
end