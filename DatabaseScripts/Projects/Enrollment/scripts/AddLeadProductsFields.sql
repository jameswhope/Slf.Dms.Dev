  IF col_length('tblLeadProducts', 'StartTime') is null
	Alter table tblLeadProducts Add StartTime varchar(20) null 
  GO	
  IF col_length('tblLeadProducts', 'EndTime') is null
	Alter table tblLeadProducts Add EndTime varchar(20) null 
  GO
  IF col_length('tblLeadProducts', 'DefaultSourceId') is null
	Alter table tblLeadProducts Add DefaultSourceId int null 
  GO
  IF col_length('tblLeadProducts', 'IsDNIS') is null
	Alter table tblLeadProducts Add IsDNIS bit Not Null default 0
  GO
