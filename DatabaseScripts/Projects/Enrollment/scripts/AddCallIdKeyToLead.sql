  IF col_length('tblLeadApplicant', 'CallIdKey') is null
	Alter table tblLeadApplicant Add CallIdKey varchar(50) null 
  GO	