
if not exists (select 1 from syscolumns where id = object_id('tblClient') and name = 'AssignedUnderwriterDate') begin
	alter table tblClient add AssignedUnderwriterDate datetime
end  