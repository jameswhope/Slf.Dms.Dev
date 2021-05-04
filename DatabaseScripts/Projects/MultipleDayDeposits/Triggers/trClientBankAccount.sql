IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trClientBankAccount')
	BEGIN
		DROP  Trigger trClientBankAccount
	END
GO

CREATE Trigger trClientBankAccount ON tblClientBankAccount
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @BankAccountID int
DECLARE @OldRoutingNumber varchar(50)
DECLARE @NewRoutingNumber varchar(50)
DECLARE @OldAccountNumber varchar(50)
DECLARE @NewAccountNumber varchar(50)
DECLARE @Chgby int
DECLARE @tableId int
DECLARE @RoutingColId int
DECLARE @AccountColId int

select @BankAccountId = BankAccountId, @NewRoutingNumber = RoutingNumber, @NewAccountNumber = AccountNumber, @chgBy = LastModifiedBy from inserted

select @OldRoutingNumber = RoutingNumber, @OldAccountNumber = AccountNumber from deleted

select top 1 @tableid =AuditTableId from tblAuditTable Where [Name] = 'tblClientBankAccount'

if not(@OldRoutingNumber = @NewRoutingNumber) or (@OldRoutingNumber is null and @NewRoutingNumber is not null) or (@OldRoutingNumber is not null and @NewRoutingNumber is null)
begin
	select top 1 @RoutingColId = AuditColumnId from tblAuditColumn Where [Name] = 'RoutingNumber' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@RoutingColId, @BankAccountId, @NewRoutingNumber, GetDate(), @chgBy, 0)
end

if not(@OldAccountNumber = @NewAccountNumber) or (@OldAccountNumber is null and @NewAccountNumber is not null) or (@OldAccountNumber is not null and @NewAccountNumber is null)
begin
	select top 1 @AccountColId = AuditColumnId from tblAuditColumn Where [Name] = 'AccountNumber' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@AccountColId, @BankAccountId, @NewAccountNumber, GetDate(), @chgBy, 0)
end

END

GO

