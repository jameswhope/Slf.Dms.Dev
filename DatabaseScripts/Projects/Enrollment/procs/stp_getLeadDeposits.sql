IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getLeadDeposits')
	BEGIN
		DROP  Procedure  stp_getLeadDeposits
	END

GO

CREATE Procedure stp_getLeadDeposits
@LeadApplicantId int
AS
	Select * from tblLeadDeposits
	Where LeadApplicantId = @LeadApplicantId

GO

