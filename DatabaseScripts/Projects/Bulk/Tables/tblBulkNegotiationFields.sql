
if object_id('tblBulkNegotiationFields') is null begin
	create table tblBulkNegotiationFields
	(
		BulkFieldID int identity(1,1) not null
	,	Display varchar(30) not null
	,	TableColumn varchar(100) not null
	,	OrigColumnName varchar(100)
	,	ColumnRequired bit default(0) not null
	,	IsReadOnly bit default(1) not null 
	,	Hidden bit default(0) not null
	,	primary key (BulkFieldID)
	)	
select * from tblBulkNegotiationFields
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,Hidden) values ('AccountID','AccountID','a.AccountID',1,1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired) values ('Client #','SDAAccount','c.AccountNumber',1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired) values ('First','ApplicantFirstName','p.FirstName',1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired) values ('Last','ApplicantLastName','p.LastName',1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired) values ('SSN','SSN','p.SSN',1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired) values ('Account #','CurrentCreditorAccountNumber','ci.AccountNumber',1)

	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Current Balance','CurrentAmount','a.CurrentAmount',0,0)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Co-App First','CoAppFirstName','co.FirstName',0,1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Co-App Last','CoAppLastName','co.LastName',0,1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Co-App SSN','CoAppSSN','co.SSN',0,1)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Notes','Notes', 'x.Notes',0,0)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Offer Made','LastOfferMade','x.LastOfferMade',0,0)
	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Offer Received','LastOfferReceived','x.LastOfferReceived',0,0)
--	insert tblBulkNegotiationFields (Display,TableColumn,OrigColumnName,ColumnRequired,IsReadOnly) values ('Settlement %','SettlementPerc','set.SettlementPercent',0,0)

end	
