
/*
	Bulk lists are snapshots of the bulk team member's current assignments.
*/

if object_id('tblBulkNegotiationLists') is null begin
	create table tblBulkNegotiationLists
	(
		BulkListID int identity(1,1) not null
	,	ListName varchar(50) not null
	,	CreditorEmail varchar(50)
	,	Created datetime default(getdate()) not null
	,	CreatedBy int not null
	,	LastModified datetime
	,	LastModifiedBy int
	,	LastSend datetime
	,	OwnedBy int not null
	,	primary key (BulkListID)
	)
end