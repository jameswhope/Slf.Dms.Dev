IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportAccountInsert')
	BEGIN
		DROP  Procedure  stp_ImportAccountInsert
	END

GO

CREATE Procedure stp_ImportAccountInsert
@ClientId int,
@AccountStatusId int,
@Amount money,
@DueDate datetime, 
@SetupFeePercentage money,
@CreditorId int,
@CreditorAccountNumber varchar(50),
@Acquired datetime,
@UserId int
AS
BEGIN

declare @accountId int
declare @instanceId int

--temp fix until next release is deployed
select @AccountStatusID = 51
--end of temp fix

Insert Into tblAccount(
ClientID, AccountStatusID, OriginalAmount, CurrentAmount, 
SetupFeePercentage, OriginalDueDate, 
Created, CreatedBy, LastModified, LastModifiedBy)
Values(
@ClientID, @AccountStatusID, @Amount, @Amount, 
@SetupFeePercentage, @DueDate, 
GetDate(), @UserId, GetDate(), @UserId)

Select @accountId = SCOPE_IDENTITY()

Insert Into tblCreditorInstance(
AccountID, CreditorID, ForCreditorID, 
Acquired, Amount, OriginalAmount, AccountNumber,
Created, CreatedBy, LastModified, LastModifiedBy)
Values(@accountId, @CreditorId, Null, 
@Acquired, @Amount, @Amount, @CreditorAccountNumber,
GetDate(), @UserId, GetDate(), @UserId)

Select @instanceId = SCOPE_IDENTITY()

update tblAccount set
currentcreditorinstanceid = @instanceId,
originalcreditorinstanceid = @instanceId
where AccountId = @accountid

select @accountId

END

GO



