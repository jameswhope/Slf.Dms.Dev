
if object_id('tblLeadGoals') is null begin
	create table tblLeadGoals
	(
		Date datetime not null,
		Goal int not null,
		Created datetime default(getdate()) not null,
		CreatedBy int not null,
		LastModified datetime,
		LastModifiedBy int,
		primary key (Date)
	)
end 