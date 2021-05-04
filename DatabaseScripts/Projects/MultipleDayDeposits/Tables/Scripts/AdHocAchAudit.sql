 declare @tableid varchar(50)
select @tableid = null
 
Select top 1 @tableid =AuditTableId from tblAuditTable Where [Name] = 'tblAdHocAch'

If @tableId is null
begin
	insert into tblAuditTable([Name], PKColumn)
	values ('tblAdHocAch', 'AdHocAchId')
	
	select @tableid = scope_identity()
end	

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountId' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'BankAccountId', 0)

If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'BankRoutingNumber' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'BankRoutingNumber', 0)
	
If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountNumber' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'BankAccountNumber', 0)
	
If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'DepositDate' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'DepositDate', 0)
	
	If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'DepositAmount' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'DepositAmount', 0)
	
	If not exists(Select top 1  AuditColumnId from tblAuditColumn Where [Name] = 'AdHocAchId' and audittableid = @tableid )
	insert into tblAuditColumn(AuditTableId, [Name], IsBigValue)
	values(@tableid, 'AdHocAchId', 0)
	
Go
	