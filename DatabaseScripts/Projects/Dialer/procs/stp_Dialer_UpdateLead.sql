IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateLead')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateLead
	END

GO

CREATE Procedure stp_Dialer_UpdateLead
@LeadApplicantId int,
@RetryAfter Datetime = null,
@RecycleDate Datetime = null
AS
Update tblLeadApplicant Set
dialerretryafter = isnull(@RetryAfter, dialerretryafter),
dialerlastrecycled = isnull(@RecycleDate, dialerlastrecycled)
Where LeadApplicantId = @LeadApplicantId

GO


