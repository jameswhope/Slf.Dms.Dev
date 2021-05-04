
-- Unsubcriptions collected from Hydra email campaigns
create table tblHydraSuppressions
(
	Email varchar(100) not null,
	DateUnsubscribed datetime default(getdate()) not null,
	SuppressionListID int,
	UnsubscribeReason varchar(1000),
	VendorID int,
	foreign key (SuppressionListID) references tblSuppressionList(SuppressionListID) on delete no action
) 