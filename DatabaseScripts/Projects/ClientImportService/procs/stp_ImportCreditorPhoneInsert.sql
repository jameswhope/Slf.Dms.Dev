IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportCreditorPhoneInsert')
	BEGIN
		DROP  Procedure  stp_ImportCreditorPhoneInsert
	END

GO

CREATE Procedure stp_ImportCreditorPhoneInsert
@PhoneTypeId int,
@AreaCode varchar(50),
@Number varchar(50),
@Extension varchar(50) = null,
@UserId int,
@CreditorId int
AS
BEGIN

declare @phoneId int

Select @phoneid = 0

Select Top 1 @phoneid = p.phoneid From tblPhone p
where isnull(p.AreaCode,'') = isnull(@AreaCode,'')
and isnull(p.Number, '') = isnull(@Number, '')
and isnull(p.Extension, '') = isnull(@Extension, '')
and p.PhoneTypeId = @PhoneTypeId

IF @phoneId = 0
Begin
	Insert Into tblPhone(
	PhoneTypeID, AreaCode, Number, Extension,
	Created, CreatedBy, LastModified, LastModifiedBy)
	Values (
	@PhoneTypeId, @AreaCode, @Number, @Extension,
	GetDate(), @UserId, GetDate(), @UserId) 

	Select @phoneId = SCOPE_IDENTITY()
End

If Not Exists(Select Top 1 CreditorPhoneId from tblCreditorPhone Where CreditorId = @CreditorId and PhoneId = @phoneId )
Begin
	Insert into tblCreditorPhone(CreditorID, PhoneID, Created, CreatedBy, LastModified, LastModifiedBy)
	Values(@CreditorId, @phoneId, GetDate(), @UserId, GetDate(), @UserId)
End

Select @phoneid

END
