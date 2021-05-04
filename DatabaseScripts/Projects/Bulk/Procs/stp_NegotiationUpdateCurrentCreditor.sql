if exists (select * from sysobjects where name = 'stp_NegotiationUpdateCurrentCreditor')
	drop procedure stp_NegotiationUpdateCurrentCreditor
go

create procedure stp_NegotiationUpdateCurrentCreditor
(
	@AccountID int
,	@CreditorID int
,	@CreatedBy int
)
as
BEGIN
/*
	history:
	jhernandez		05/08/08		Created. Changes creditors using the current creditor's account
									information.
	jhernandez		05/09/08		Add client notes.
*/

declare 
	@CurCreditorInstanceID int, 
	@NewCreditorInstanceID int, 
	@NewCreditorName varchar(50),
	@CurCreditorName varchar(50),
	@ClientID int


select @ClientID = a.ClientID, @CurCreditorInstanceID = a.CurrentCreditorInstanceID, @CurCreditorName = c.Name
from tblAccount a
join tblCreditorInstance ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID
join tblCreditor c on c.CreditorID = ci.CreditorID
where a.AccountID = @AccountID


select @NewCreditorName = [Name]
from tblCreditor
where CreditorID = @CreditorID


insert tblCreditorInstance (
	AccountID,
	CreditorID,
	ForCreditorID,
	Acquired,
	Amount,
	OriginalAmount,
	AccountNumber,
	ReferenceNumber,
	Created,
	CreatedBy,
	LastModified,
	LastModifiedBy
)
select
	@AccountID,
	@CreditorID,
	ForCreditorID,
	Acquired,
	Amount,
	OriginalAmount,
	AccountNumber,
	ReferenceNumber,
	getdate(),
	@CreatedBy,
	getdate(),
	@CreatedBy
from
	tblCreditorInstance
where
	CreditorInstanceID = @CurCreditorInstanceID


select @NewCreditorInstanceID = scope_identity()


if (@NewCreditorInstanceID > 0) begin
	update tblAccount
	set CurrentCreditorInstanceID = @NewCreditorInstanceID, LastModified = getdate(), LastModifiedBy = @CreatedBy
	where AccountID = @AccountID

	insert tblNote (
		ClientID,
		[Value],
		Created,
		CreatedBy,
		LastModified,
		LastModifiedBy
	)
	values (
		@ClientID,
		'Creditor Updated:  Changed current creditor from ' + @CurCreditorName + ' to ' + @NewCreditorName,
		getdate(),
		@CreatedBy,
		getdate(),
		@CreatedBy
	) 
end


--return
select @NewCreditorInstanceID


END