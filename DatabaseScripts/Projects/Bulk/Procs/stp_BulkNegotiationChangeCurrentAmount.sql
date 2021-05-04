 if exists (select * from sysobjects where name = 'stp_BulkNegotiationChangeCurrentAmount')
	drop procedure stp_BulkNegotiationChangeCurrentAmount
go

create procedure stp_BulkNegotiationChangeCurrentAmount
(
	@AccountId int,
	@Amount money,
	@UserId int
)
as
begin
/*
	History:
	opereira		05/15/08		Changes the Amount for Account and Creditor instance
*/

Declare @OrigAmount money
Declare @ClientId int
Declare @CreditorInstanceId int

Select @OrigAmount = CurrentAmount, 
	   @ClientId = ClientId, 
	   @CreditorInstanceId = CurrentCreditorInstanceId 
From tblAccount 
Where AccountId = @AccountId

Update tblAccount Set
CurrentAmount = @Amount
Where AccountId = @AccountId

Update tblCreditorInstance Set
Amount = @Amount
From tblCreditorInstance
Where  CreditorInstanceId = @CreditorInstanceId

insert tblNote (
		ClientID,
		[Value],
		Created,
		CreatedBy,
		LastModified,
		LastModifiedBy
	)
	values (
		@ClientId,
		'Account: ' +  
		convert(varchar, @AccountId) +  
		' and Creditor Instance: ' + 
		convert(varchar, @CreditorInstanceId)  +  
		' current amount changed from ' + 
		convert(varchar, @OrigAmount) + 
		' to ' + 
		convert(varchar, @Amount),
		getdate(),
		@UserId,
		getdate(),
		@UserId
	) 
	
end

go