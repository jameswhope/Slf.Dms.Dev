
create table tblPotentialDeposits
(
	CompanyID int not null,
	AgencyID int,
	DepositCount int,
	Amount money,
	ForDate datetime,
	ProjectedOn datetime default(getdate())
) 