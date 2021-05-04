
if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'RgrId') begin
	alter table tblLeadApplicant add RgrId bigint null
end  
go

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'Rcid') begin
	alter table tblLeadApplicant add Rcid varchar(50) null
end  
go