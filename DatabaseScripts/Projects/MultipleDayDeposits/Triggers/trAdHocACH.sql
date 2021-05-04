IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trAdHocAch')
	BEGIN
		DROP  Trigger trAdHocAch
	END
GO

CREATE Trigger [dbo].[trAdHocAch] ON [dbo].[tblAdHocACH]
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @AdHocAchId int
DECLARE @NewBankAccountID int
DECLARE @OldBankAccountID int
DECLARE @OldRoutingNumber varchar(50)
DECLARE @NewRoutingNumber varchar(50)
DECLARE @OldAccountNumber varchar(50)
DECLARE @NewAccountNumber varchar(50)
DECLARE @OldDepositDate datetime
DECLARE @NewDepositDate datetime
DECLARE @OldDepositAmount money
DECLARE @NewDepositAmount money
DECLARE @Chgby int
DECLARE @tableId int
DECLARE @RoutingColId int
DECLARE @AccountColId int
DECLARE @DepositAmountColId int
DECLARE @DepositDateColId int
DECLARE @BankAccountColId int

select 
	   @AdHocAchId = AdHocAchId,
	   @NewBankAccountId = BankAccountId, 
	   @NewRoutingNumber = BankRoutingNumber, 
       @NewAccountNumber = BankAccountNumber, 
	   @NewDepositDate = DepositDate,
	   @NewDepositAmount = DepositAmount, 
       @chgBy = LastModifiedBy 
from inserted

select  @OldBankAccountId = BankAccountId,
		@OldRoutingNumber = BankRoutingNumber, 
		@OldAccountNumber = BankAccountNumber,
		@OldDepositDate = DepositDate,
		@OldDepositAmount = DepositAmount
from deleted

select top 1 @tableid =AuditTableId from tblAuditTable Where [Name] = 'tblAdHocACH'

if not(@OldRoutingNumber = @NewRoutingNumber) or (@OldRoutingNumber is null and @NewRoutingNumber is not null) or (@OldRoutingNumber is not null and @NewRoutingNumber is null)
begin
	select top 1 @RoutingColId = AuditColumnId from tblAuditColumn Where [Name] = 'BankRoutingNumber' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@RoutingColId, @AdHocAchId, @NewRoutingNumber, GetDate(), @chgBy, 0)
end

if not(@OldAccountNumber = @NewAccountNumber) or (@OldAccountNumber is null and @NewAccountNumber is not null) or (@OldAccountNumber is not null and @NewAccountNumber is null)
begin
	select top 1 @AccountColId = AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountNumber' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@AccountColId, @AdHocAchId, @NewAccountNumber, GetDate(), @chgBy, 0)
end


if not(@OldDepositAmount = @NewDepositAmount) or (@OldDepositAmount is null and @NewDepositAmount is not null) or (@OldDepositAmount is not null and @NewDepositAmount is null)
begin
	select top 1 @DepositAmountColId = AuditColumnId from tblAuditColumn Where [Name] = 'DepositAmount' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@DepositAmountColId, @AdHocAchId, @NewDepositAmount, GetDate(), @chgBy, 0)
end

if not(@OldDepositDate = @NewDepositDate) or (@OldDepositDate is null and @NewDepositDate is not null) or (@OldDepositDate is not null and @NewDepositDate is null)
begin
	select top 1 @DepositDateColId = AuditColumnId from tblAuditColumn Where [Name] = 'DepositDate' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@DepositDateColId, @AdHocAchId, @NewDepositDate, GetDate(), @chgBy, 0)
end

if not(@OldBankAccountId = @NewBankAccountId) or (@OldBankAccountId is null and @NewBankAccountId is not null) or (@OldBankAccountId is not null and @NewBankAccountId is null)
begin
	select top 1 @BankAccountColId = AuditColumnId from tblAuditColumn Where [Name] = 'BankAccountId' and audittableid = @tableid 

	insert into tblaudit(AuditColumnId, PK, Value, DC, UC, Deleted)
	values(@BankAccountColId, @AdHocAchId, @NewBankAccountId, GetDate(), @chgBy, 0)
end


END

GO
