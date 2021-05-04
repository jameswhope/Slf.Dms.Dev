IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportPersonPhoneInsert')
	BEGIN
		DROP  Procedure  stp_ImportPersonPhoneInsert
	END

GO

CREATE Procedure stp_ImportPersonPhoneInsert
@PhoneTypeId int,
@AreaCode varchar(50),
@Number varchar(50),
@Extension varchar(50) = null,
@UserId int,
@PersonId int
AS
BEGIN
declare @phoneId int

Insert Into tblPhone(
PhoneTypeID, AreaCode, Number, Extension,
Created, CreatedBy, LastModified, LastModifiedBy)
Values (
@PhoneTypeId, @AreaCode, @Number, @Extension,
GetDate(), @UserId, GetDate(), @UserId) 

Select @phoneId = SCOPE_IDENTITY()

Insert into tblPersonPhone(PersonID, PhoneID, Created, CreatedBy, LastModified, LastModifiedBy)
Values(@PersonId, @phoneId, GetDate(), @UserId, GetDate(), @UserId)

Select @phoneid

END

GO



