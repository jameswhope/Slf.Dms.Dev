
alter procedure stp_InsertLeadCalculator
(
	@LeadApplicantID int,
	@TotalDebt money
)
as
begin
/*
	History
	9/23/10		jh		Product codes that have a service fee set use that as a flat fee, otherwise pull from properties
*/

insert tblLeadCalculator (
	LeadApplicantID,
	TotalDebt,
	SettlementFeePct,
	InitialDeposit,
	SubMaintenanceFee,
	DepositCommittment,
	DateOfFirstDeposit,
	ReoccurringDepositDay,
	MaintenanceFeeCap,
	ServiceFeePerAcct,
	NoAccts,
	EstGrowth,
	PBMIntRate,
	PBMMinAmt,
	PBMMinPct)
select 
	l.leadapplicantid, 
	@TotalDebt, 
	cast(cast(sfp.value as money) * 100 as int),
	0,
	0,
	0,
	'1/1/1900',
	1,
	isnull(p.ServiceFee,cast(cap.value as money)), 
	isnull(p.ServiceFee,cast(per.value as money)), 
	1, 
	cast(inf.value as money) * 100, 
	cast(apr.value as money) * 100, 
	cast(minamt.value as money), 
	cast(minpct.value as money) * 100
from tblProperty sfp, tblProperty cap, tblProperty per, tblProperty inf, tblProperty apr, tblProperty minamt, tblProperty minpct, tblleadapplicant l
join tblleadproducts p on p.productid = l.productid
where sfp.name = 'EnrollmentSettlementPercentage'
and cap.name = 'EnrollmentMaintenanceFeeCap'
and per.name = 'EnrollmentMaintenanceFee'
and apr.name = 'EnrollmentPBMAPR'
and inf.name = 'EnrollmentInflation'
and minamt.name = 'EnrollmentPBMMinimum'
and minpct.name = 'EnrollmentPBMPercentage'		
and l.leadapplicantid = @LeadApplicantID


end
go