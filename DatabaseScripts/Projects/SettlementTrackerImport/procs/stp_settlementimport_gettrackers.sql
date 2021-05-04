IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_gettrackers')
	BEGIN
		DROP  Procedure  stp_settlementimport_gettrackers
	END

GO

CREATE Procedure stp_settlementimport_gettrackers
	(
		@year int ,
		@month int
	)

AS
BEGIN
	SELECT 
		sti.TrackerImportID
		, isnull(sti.Team,'')[Team]
		, sti.Negotiator
		, convert(varchar,sti.AgencyID)[AgencyID]
		, a.Name AS AgencyName
		, sti.LawFirm
		, sti.Date
		, acs.[Code] [Status]
		, sti.Due
		, convert(varchar,sti.ClientAcctNumber)[ClientAcctNumber]
		, sti.Name
		, sti.CreditorAccountNum
		, sti.OriginalCreditor
		, sti.CurrentCreditor
		, s.creditorAccountBalance [BALANCE]
		, s.SettlementAmount [SETTLEmentAmt]
		, s.SettlementPercent*0.01 [SettlementPercent]
		, s.SDABalance [FundsAvail]
		, sti.Note
		, sti.sent
		, sti.paid
		, sti.days
		, s.SettlementSavings [ClientSavings]
		, s.SettlementFee [SettlementFees]
		, sti.SettlementSavingsPct
		, CancelDate 
		, expired
		, s.IsPaymentArrangement
	FROM tblSettlementTrackerImports AS sti with(nolock)
	INNER JOIN tblAgency AS a with(nolock) ON sti.AgencyID = a.AgencyID 
	inner join tblSettlements s with(nolock) ON s.SettlementID = sti.SettlementID
	inner join tblaccount ac with(nolock) on ac.AccountId = s.CreditorAccountId
	inner join tblaccountstatus acs with(nolock) on acs.accountstatusid = ac.accountstatusid
	WHERE (YEAR(sti.Date) = @year) AND (MONTH(sti.Date) = @month) or ((YEAR(sti.paid) = @year) AND (MONTH(sti.paid) = @month))
	option (fast 25)
END

GO


GRANT EXEC ON stp_settlementimport_gettrackers TO PUBLIC

GO


