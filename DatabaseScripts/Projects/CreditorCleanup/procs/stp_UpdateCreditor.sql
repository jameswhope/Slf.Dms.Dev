IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateCreditor')
	BEGIN
		DROP  Procedure  stp_UpdateCreditor
	END

GO

CREATE Procedure stp_UpdateCreditor
@CreditorId int,
@Name varchar(50) = null,
@Street varchar(50) = null,
@Street2 varchar(50) = null,
@City varchar(50) = null,
@StateId int = null,
@ZipCode varchar(50) = null,
@Validated bit = null,
@UserId int,
@CreditorGroupId int = null,
@CreditorAddressTypeId int = null 
AS
Begin
/*
	-- Save Log
	Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
	Select @CreditorGroupId, CreditorGroupId, 'tblCreditor', 'CreditorGroupId', CreditorId, @UserId
	From tblCreditor
	Where CreditorId = @CreditorId and @CreditorGroupId <> CreditorGroupId
*/
	
	Update tblCreditor Set
	[Name] = isnull(@Name, [Name]),
	Street = isnull(@Street, Street),
	Street2 = isnull(@Street2, Street2),
	City = isnull(@City, City),
	StateId = isnull(@StateId, StateId),
	ZipCode = isnull(@ZipCode, ZipCode),
	Validated = @Validated,
	CreditorGroupId = isnull(@CreditorGroupId, CreditorGroupId),
	CreditorAddressTypeId = isnull(@CreditorAddressTypeId, CreditorAddressTypeId),
	LastModified = GetDate(),
	LastModifiedBy = @UserId 
	Where CreditorId = @CreditorId
	
End

GO

