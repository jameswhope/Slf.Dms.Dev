
if object_id('tblBulkNegotiationPublishHistory') is null begin
	create table tblBulkNegotiationPublishHistory
	(
		PublishHistoryID int identity(1,1)
	,	BulkListID int not null
	,	PublishDate datetime default(getdate()) not null
	,	PublishedBy int not null
	,	NoAccounts int
	)
end