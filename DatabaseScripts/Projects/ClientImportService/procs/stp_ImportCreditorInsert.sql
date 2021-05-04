IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportCreditorInsert')
	BEGIN
		DROP  Procedure  stp_ImportCreditorInsert
	END

GO

CREATE Procedure stp_ImportCreditorInsert
@Name varchar(50),
@Street varchar(255) = null,
@Street2 varchar(255) = null,
@City varchar(50) = null,
@StateId int = null,
@ZipCode varchar(50) = null,
@CreatedBy int,
@Created datetime = null,
@LastModifiedBy int,
@LastModified datetime = null,
@AddressTypeId int = 105,
@GroupId int = null,
@Validated bit = 0
AS
BEGIN

Insert Into tblCreditor(
[Name], Street, Street2, City, StateID, ZipCode,
Created, CreatedBy, LastModified, LastModifiedBy, CreditorAddressTypeId, CreditorGroupId, Validated)
Values(
@Name, @Street, @Street2, @City, @StateId, @ZipCode,
isnull(@Created,GetDate()), @CreatedBy, isnull(@LastModified,GetDate()), @LastModifiedBy, @AddressTypeId, @GroupId, @Validated)

Select SCOPE_IDENTITY()
END

GO



