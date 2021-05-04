IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_DeleteDepositDay')
	BEGIN
		DROP  Procedure  stp_enrollment_DeleteDepositDay
	END

GO

CREATE Procedure stp_enrollment_DeleteDepositDay
@LeadDepositId int
AS
Delete from tblLeadDeposits Where LeadDepositId = @LeadDepositId
GO

