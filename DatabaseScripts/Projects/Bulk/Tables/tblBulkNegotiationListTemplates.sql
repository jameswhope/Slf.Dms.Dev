
/*
	Stores the working template for the bulk list. Fields can change throughout the negotiation
	process.
*/

if object_id('tblBulkNegotiationListTemplates') is null 
	begin
		create table tblBulkNegotiationListTemplates
		(
			BulkListTemplateID int identity(1,1) not null
		,	BulkListID int not null
		,	BulkFieldID int not null
		,   [Sequence] int  
		--,	foreign key (BulkListID) references tblBulkNegotiationLists(BulkListID) on delete cascade
		--,	foreign key (BulkFieldID) references tblBulkNegotiationFields(BulkFieldID) on delete no action
		)
	end