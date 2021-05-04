IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportPersonInsert')
	BEGIN
		DROP  Procedure  stp_ImportPersonInsert
	END

GO

CREATE Procedure stp_ImportPersonInsert
@ClientId int,
@SSN varchar(50) = null, 
@FirstName varchar(50),
@LastName varchar(50),
@Gender varchar(1) = null,
@DateOfBirth datetime = null,
@LanguageId int,
@EmailAddress varchar(50) = null,
@Street varchar(255) = null,
@Street2 varchar(255) = null,
@City varchar(50) = null,
@StateId int = null,
@ZipCode varchar(50) = null,
@Relationship varchar(50),
@CanAuthorize bit,
@UserId int,
@ThirdParty bit
AS
BEGIN

Insert into tblperson(
ClientID, SSN, FirstName, LastName,
Gender, DateOfBirth, LanguageID, EmailAddress,
Street, Street2, City, StateID, ZipCode, Relationship, CanAuthorize, 
Created, CreatedBy, LastModified, LastModifiedBy, ThirdParty)
Values(@ClientId, @SSN, @FirstName, @LastName,
@Gender, @DateOfBirth, @LanguageId, @EmailAddress,
@Street, @Street2, @City, @StateId, @ZipCode, @Relationship, @CanAuthorize,
GetDate(), @UserId, GetDate(), @UserId, @ThirdParty)


Select SCOPE_IDENTITY()

END


GO
