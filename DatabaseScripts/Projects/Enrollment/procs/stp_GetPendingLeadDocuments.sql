IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPendingLeadDocuments')
	BEGIN
		DROP  Procedure  stp_GetPendingLeadDocuments
	END
GO

create procedure [dbo].[stp_GetPendingLeadDocuments]
(
	@ExpirationDays int = 30,
	@LeadApplicantID int = null
)
as
begin
	-- Returns EchoSign docs waiting for signature. Used by EchoSignHelper console app to retrieve signed documents.

	select DocumentID
	from tblleaddocuments
	where completed is null
	and submitted > dateadd(d,-@ExpirationDays,getdate())
	and currentstatus = 'Waiting on signatures'
	and authtoken is null -- EchoSign docs dont have an AuthToken
	and documenttypeid in (6,222) -- LSA
	and (@LeadApplicantID is null or @LeadApplicantID = leadapplicantid)
	and signingbatchid is null

end 