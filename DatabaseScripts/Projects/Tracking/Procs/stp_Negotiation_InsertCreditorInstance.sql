IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Negotiation_InsertCreditorInstance')
	BEGIN
		DROP  Procedure  stp_Negotiation_InsertCreditorInstance
	END

GO

CREATE Procedure stp_Negotiation_InsertCreditorInstance
(
@AccountID int,
@CreditorID int,
@ForCreditorID int,
@Acquired datetime,
@Amount money,
@OriginalAmount money,
@AccountNumber varchar(50),
@ReferenceNumber varchar(50),
@UserID int
)
as
BEGIN
/*
stp_Negotiation_InsertCreditorInstance 11111,11111,11111,'2009-06-05 13:29:37.600',
123.45,123.45,12345678,12345678,750
*/

	declare @instanceID int

	INSERT INTO tblCreditorInstance 
	(AccountID,CreditorID,ForCreditorID,Acquired,Amount,OriginalAmount,
	AccountNumber,ReferenceNumber,
	Created,CreatedBy,LastModified,LastModifiedBy) 
	VALUES 
	(@AccountID,@CreditorID,@ForCreditorID,@Acquired,@Amount,@OriginalAmount,
	@AccountNumber,@ReferenceNumber,
	getdate(),@UserID,getdate(),@UserID)

	SELECT @instanceID = SCOPE_IDENTITY() 

	update tblAccount 
	set CurrentCreditorInstanceID = @instanceID, CurrentAmount = @Amount, Verified = getdate(), VerifiedBy = @UserID, VerifiedAmount = @OriginalAmount
	where (accountid = @AccountID)
	
	
END


GRANT EXEC ON stp_Negotiation_InsertCreditorInstance TO PUBLIC


