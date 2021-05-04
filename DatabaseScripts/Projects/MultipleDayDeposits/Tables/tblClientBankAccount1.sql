/*drop table tblClientBankAccount
go*/

if object_id('tblClientBankAccount') is null 
begin
	CREATE TABLE tblClientBankAccount
	(
		BankAccountId   int  IDENTITY(1,1) NOT NULL,
		ClientId   int  NOT NULL,
		RoutingNumber	varchar(9) NOT NULL,
		AccountNumber varchar(50) ,
		BankType   varchar(1) NULL,
		Created datetime not null default GetDate(),
		CreatedBy int not null,
		LastModified datetime not null,
		LastModifiedBy int not null,
		PrimaryAccount bit not null default 0
	)
end
go