
if not exists (select 1 from syscolumns where id = object_id('tblCommRec') and name = 'IsGCA') begin
	alter table tblCommRec add IsGCA bit default(0) not null
end  
go

update tblCommRec set IsGCA = 1 where CommRecID in (11,20)