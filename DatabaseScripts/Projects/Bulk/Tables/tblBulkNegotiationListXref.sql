
/*
	Each account that is being worked on by a bulk team member will belong to only one bulk
	list. 
*/

if object_id('tblBulkNegotiationListXref') is null begin
	create table tblBulkNegotiationListXref
	(
		BulkListID int not null
	,	AccountID int not null
	,	LastOfferMade varchar(10)
	,	LastOfferReceived varchar(10)
	,	Notes varchar(1000)
	,	foreign key (BulkListID) references tblBulkNegotiationLists(BulkListID) on delete cascade
	)
end

if not exists (select 1 from syscolumns where id = object_id('tblBulkNegotiationListXref') and name = 'LastOfferMade') begin
	alter table tblBulkNegotiationListXref add LastOfferMade varchar(10)
end

if not exists (select 1 from syscolumns where id = object_id('tblBulkNegotiationListXref') and name = 'LastOfferReceived') begin
	alter table tblBulkNegotiationListXref add LastOfferReceived varchar(10)	
end

if not exists (select 1 from syscolumns where id = object_id('tblBulkNegotiationListXref') and name = 'Notes') begin
	alter table tblBulkNegotiationListXref add Notes varchar(1000)	
end