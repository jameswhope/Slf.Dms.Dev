IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tr_CreditorPhone')
	BEGIN
		DROP  Trigger tr_CreditorPhone
	END
GO

CREATE Trigger tr_CreditorPhone ON tblCreditorPhone
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @CreditorID int
Declare @NewCreditorId int
Declare @CreditorPhoneid int

select @CreditorID = CreditorId, @CreditorPhoneid = CreditorPhoneid
from inserted

Select @NewCreditorId = dbo.GetRecursiveCreditorId(@CreditorId)

if @NewCreditorId is not null and @NewCreditorId <> @CreditorId 
	Update tblCreditorPhone Set
	CreditorId = @NewCreditorId
	Where CreditorPhoneid = @CreditorPhoneid


END

GO