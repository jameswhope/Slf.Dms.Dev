
-- Log when default commission scenario 10 is used because the scenario lookup in stp_PayCommission
-- could not obtain a scenario id.

if object_id('tblDefaultScenarioLog') is null begin
	create table tblDefaultScenarioLog
	(
		ClientID int,
		ClientEnrolled datetime,
		AgencyID int,
		RegisterPaymentID int,
		LogCreated datetime default(getdate())
	)
end