IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tr_LeadCreditorInstance')
	BEGIN
		DROP  Trigger tr_LeadCreditorInstance
	END
GO

CREATE Trigger tr_LeadCreditorInstance ON tblLeadCreditorInstance
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @CreditorID int
Declare @NewCreditorId int
Declare @LeadCreditorInstance int

select @CreditorID = CreditorId, @LeadCreditorInstance = LeadCreditorInstance
from inserted

Select @NewCreditorId = dbo.GetRecursiveCreditorId(@CreditorId)

if @NewCreditorId is not null and @NewCreditorId <> @CreditorId 
	Update tblLeadCreditorInstance Set
	CreditorId = @NewCreditorId
	Where LeadCreditorInstance = @LeadCreditorInstance 


END

GO


