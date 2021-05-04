
if object_id('tblAccountType') is null begin
	CREATE TABLE tblAccountType
	(
	  AccountTypeID int not null
	, Abbreviation varchar(10) not null
	, AccountType varchar(30) not null
	, Created datetime default(getdate())
	)

	insert tblAccountType (AccountTypeID,Abbreviation,AccountType) values (1,'GCA','General Clearing Account')
	insert tblAccountType (AccountTypeID,Abbreviation,AccountType) values (2,'Trust','Client Trust')
	insert tblAccountType (AccountTypeID,Abbreviation,AccountType) values (3,'OA','Operating Account')
	
	update tblCommRec set AccountTypeID = 1 where Display like '%General Clearing Account%' and AccountTypeID is null
	update tblCommRec set AccountTypeID = 2 where Display like '%Client Trust%' and AccountTypeID is null
	update tblCommRec set AccountTypeID = 3 where Display like '%Operating Account%' and AccountTypeID is null
end
