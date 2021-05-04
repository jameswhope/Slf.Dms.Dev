IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AuditBankAccountDelete')
	BEGIN
		DROP  Procedure  stp_AuditBankAccountDelete
	END

GO

CREATE Procedure stp_AuditBankAccountDelete
@BankAccountId int,
@UserId int
AS
Begin
declare @colid int

Select @colid = ac.AuditColumnId from tblAuditColumn ac
where ac.[name] = 'bankaccountid'
and ac.audittableid in 
(Select at.audittableid from tblaudittable at where at.name = 'tblclientbankaccount')

if @colid is not null
begin
	insert into tblAudit(AuditColumnId, PK,[Value], DC, UC, Deleted)
	values (@colid, @BankAccountId, null, getdate(), @UserId, 1)
end

End
GO

