IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tr_tblHarassmentclient')
	BEGIN
		DROP  Trigger tr_tblHarassmentclient
	END
GO

CREATE Trigger tr_tblHarassmentclient ON tblHarassmentclient
AFTER INSERT, UPDATE
NOT FOR REPLICATION
AS 
BEGIN
DECLARE @OriginalCreditorID int
DECLARE @CurrentCreditorID int
Declare @NewOriginalCreditorId int
Declare @NewCurrentCreditorId int
Declare @ClientSubmissionId int

select @OriginalCreditorID = OriginalCreditorID, @CurrentCreditorID = CurrentCreditorID, @ClientSubmissionId = ClientSubmissionId
from inserted

Select @NewOriginalCreditorID = dbo.GetRecursiveCreditorId(@OriginalCreditorID)

if @NewOriginalCreditorID is not null and @NewOriginalCreditorID <> @OriginalCreditorID 
	Update tblHarassmentclient Set
	OriginalCreditorID = @NewOriginalCreditorID
	Where ClientSubmissionId = @ClientSubmissionId

Select @NewCurrentCreditorID = dbo.GetRecursiveCreditorId(@CurrentCreditorID)

if @NewCurrentCreditorID is not null and @NewCurrentCreditorID <> @CurrentCreditorID 
	Update tblHarassmentclient Set
	CurrentCreditorID = @NewCurrentCreditorID
	Where ClientSubmissionId = @ClientSubmissionId


END

GO
