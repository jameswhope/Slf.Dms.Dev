IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trClientDepositDay')
	BEGIN
		DROP  Trigger trClientDepositDay
	END
GO

CREATE Trigger trClientDepositDay ON tblClientDepositDay
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @ClientDepositId int
DECLARE @OldBankAccountID int
DECLARE @NewBankAccountID int
DECLARE @OldDepositDay int
DECLARE @NewDepositDay int
DECLARE @OldDepositMethod varchar(50)
DECLARE @NewDepositMethod varchar(50)
DECLARE @OldDepositAmount money
DECLARE @NewDepositAmount money
DECLARE @Chgby int
DECLARE @tableId int
DECLARE @ColId int

select @ClientDepositId = ClientDepositId,
	   @NewBankAccountId = BankAccountId, 
	   @NewDepositDay = DepositDay,
	   @NewDepositMethod = DepositMethod,
	   @NewDepositAmount = DepositAmount,
	   @chgBy = LastModifiedBy 
from inserted

select @ClientDepositId = ClientDepositId,
	   @OldBankAccountId = BankAccountId, 
	   @OldDepositDay = DepositDay,
	   @OldDepositMethod = DepositMethod,
	   @OldDepositAmount = DepositAmount
from deleted

select top 1 @tableid =AuditTableId from tblAuditTable Where [Name] = 'tblClientDepositDay'

if not(@OldBankAccountId = @NewBankAccountId) or (@OldBankAccountId is null and @NewBankAccountId is not null) or (@OldBankAccountId is not null and @NewBankAccountId is null)
begin
	select top 1 @ColId = AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountId' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@ColId, @ClientDepositId, @NewBankAccountId, GetDate(), @chgBy, 0)
end

if not(@OldDepositDay = @NewDepositDay) or (@OldDepositDay is null and @NewDepositDay is not null) or (@OldDepositDay is not null and @NewDepositDay is null)
begin
	select top 1 @ColId = AuditColumnId from tblAuditColumn Where [Name] = 'DepositDay' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@ColId, @ClientDepositId, @NewDepositDay, GetDate(), @chgBy, 0)
end

if not(@OldDepositAmount = @NewDepositAmount) or (@OldDepositAmount is null and @NewDepositAmount is not null) or (@OldDepositAmount is not null and @NewDepositAmount is null)
begin
	select top 1 @ColId = AuditColumnId from tblAuditColumn Where [Name] = 'DepositAmount' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@ColId, @ClientDepositId, @NewDepositAmount, GetDate(), @chgBy, 0)
end

if not(@OldDepositMethod = @NewDepositMethod) or (@OldDepositMethod is null and @NewDepositMethod is not null) or (@OldDepositMethod is not null and @NewDepositMethod is null)
begin
	select top 1 @ColId = AuditColumnId from tblAuditColumn Where [Name] = 'DepositMethod' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@ColId, @ClientDepositId, @NewDepositMethod, GetDate(), @chgBy, 0)
end

END

GO

