--drop table tblClientDepositDay

if object_id('tblClientDepositDay') is null 
begin
	CREATE TABLE tblClientDepositDay
	(
		ClientDepositId int not null identity(1,1) Primary Key,
		ClientId int not null,
		Frequency varchar(10) not null,
		DepositDay int not null,
		Occurrence int null,
		DepositAmount money not null,
		DepositMethod varchar(5) not null default 'Check',
		DepositMethodDisplay varchar(15) default('Check') not null,
		BankAccountId int null,
		Created datetime not null default getdate(),
		CreatedBy int not null,
		LastModified datetime not null,
		LastModifiedBy int not null,
		DeletedDate datetime null,
		DeletedBy int null
	)
	/*Insert Into tblClientDepositDay (ClientId, Frequency, DepositDay, DepositAmount, CreatedBy, LastModified, LastModifiedBy)
	Select ClientId, 'month', isnull(DepositDay, 1), isnull(DepositAmount, 0), 27, GetDate(), 27  from tblclient*/
end