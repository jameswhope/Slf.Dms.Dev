declare @tableid varchar(50)
select @tableid = null
 
Select top 1 @tableid =AuditTableId from tblAuditTable Where [Name] = 'tblClientBankAccount'

If @tableId is null
begin
	insert into tblAuditTable([Name], PKColumn)
	values ('tblClientBankAccount', 'BankAccountId')
	
	select @tableid = scope_identity()
end	

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountId' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'BankAccountId', 0)

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'RoutingNumber' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'RoutingNumber', 0)
	
If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'AccountNumber' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'AccountNumber', 0)
	
select @tableid = null
 
Select top 1 @tableid =AuditTableId from tblAuditTable Where [Name] = 'tblClientDepositDay'

If @tableId is null
begin
	insert into tblAuditTable([Name], PKColumn)
	values ('tblClientDepositDay', 'ClientDepositId')
	
	select @tableid = scope_identity()
end		

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountId' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'BankAccountId', 0)

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'DepositDay' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'DepositDay', 0)
	
If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'DepositAmount' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'DepositAmount', 0)

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'DepositMethod' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'DepositMethod', 0)

Go
	

 
