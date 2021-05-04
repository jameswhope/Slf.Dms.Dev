IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'Trigger_Name')
	BEGIN
		DROP  Trigger Trigger_Name
	END
GO
-- =============================================
-- Author:		Christopher Nott
-- Create date: 04/08/2009
-- Description:	tblLeadRoadMap update on insert, update
-- Modified by Jhope 04/14/2009
-- =============================================
CREATE TRIGGER UpdateTblLeadRoadMap 
   ON  tblLeadApplicant
   AFTER INSERT, UPDATE
AS 

SET NOCOUNT ON;
DECLARE @LeadApplicantID INT
DECLARE @NewStatusID INT
DECLARE @Chgby INT
DECLARE @OldStatusID INT

SELECT @LeadApplicantid = LeadApplicantID, @NewStatusID = StatusID, @chgBy = LastModifiedByID FROM inserted
SELECT @OldStatusID = StatusID FROM deleted

IF(NOT @oldstatusid=@newstatusid OR (@oldstatusid IS NULL AND NOT @newstatusid IS NULL))

BEGIN
INSERT INTO tblLeadRoadMap (LeadApplicantID, LeadStatusID, created, createdby, lastmodified, lastmodifiedby)
VALUES (@leadapplicantid, @newstatusid, GETDATE(), @ChgBy, GETDATE(), @Chgby)
END

GO

