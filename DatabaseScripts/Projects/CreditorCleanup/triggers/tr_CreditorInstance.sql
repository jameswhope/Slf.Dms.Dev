IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tr_CreditorInstance')
	BEGIN
		DROP  Trigger tr_CreditorInstance
	END
GO

CREATE Trigger tr_CreditorInstance ON tblCreditorInstance
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @CreditorID int
DECLARE @ForCreditorID int
Declare @NewCreditorId int
Declare @NewForCreditorId int
Declare @CreditorInstanceId int

select @CreditorID = CreditorId, @ForCreditorID = ForCreditorId, @CreditorInstanceId = CreditorInstanceId
from inserted

Select @NewCreditorId = dbo.GetRecursiveCreditorId(@CreditorId)

if @NewCreditorId is not null and @NewCreditorId <> @CreditorId 
	Update tblCreditorInstance Set
	CreditorId = @NewCreditorId
	Where CreditorInstanceId = @CreditorInstanceId

Select @NewForCreditorId = dbo.GetRecursiveCreditorId(@ForCreditorId)

if @NewForCreditorId is not null and @NewForCreditorId <> @ForCreditorId 
	Update tblCreditorInstance Set
	ForCreditorId = @NewForCreditorId
	Where CreditorInstanceId = @CreditorInstanceId


END

GO

