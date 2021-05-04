
if object_id('tblLeadCalculator') is null begin
	CREATE TABLE [dbo].[tblLeadCalculator](
		[LeadCalculatorID] [int] IDENTITY(1,1) NOT NULL,
		[LeadApplicantID] [int] NULL,
		[TotalDebt] [money] NULL,
		[NoAccts] [int] NULL,
		[SettlementFeePct] [float] NULL,
		[EstSettlementAmt] [money] NULL,
		[InitialDeposit] [float] NULL,
		[SettlementPct] [int] NULL,
		[EstRetainerFee] [money] NULL,
		[MaintenanceFee] [float] NULL,
		[MaintenanceFeeCap] [money] NULL,
		[SubMaintenanceFee] [money] NULL,
		[SettlementFee] [float] NULL,
		[EstSettlementFee] [money] NULL,
		[TotalSettlementFees] [numeric](18, 2) NULL,
		[CurrentMonthly] [money] NULL,
		[NominalDeposit] [money] NULL,
		[DepositLow] [money] NULL,
		[DepositHigh] [money] NULL,
		[DepositCommittment] [money] NULL,
		[TermYears] [float] NULL,
		[DateOfFirstDeposit] [datetime] NULL,
		[ReOccurringDepositDay] [int] NULL,
		[EstGrowth] [money] NULL,
		[PBMIntRate] [money] NULL,
		[PBMMinAmt] [money] NULL,
		[PBMMinPct] [money] NULL,
	 CONSTRAINT [PK_tblLeadCalculator] PRIMARY KEY CLUSTERED 
	(
		[LeadCalculatorID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]
end

if not exists (select 1 from syscolumns where id = object_id('tblLeadCalculator') and name = 'MaintenanceFeeCap') begin
	alter table tblLeadCalculator add [MaintenanceFeeCap] [money] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCalculator') and name = 'NoAccts') begin
	alter table tblLeadCalculator add [NoAccts] [int] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCalculator') and name = 'EstGrowth') begin
	alter table tblLeadCalculator add [EstGrowth] [money] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCalculator') and name = 'PBMIntRate') begin
	alter table tblLeadCalculator add [PBMIntRate] [money] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCalculator') and name = 'PBMMinAmt') begin
	alter table tblLeadCalculator add [PBMMinAmt] [money] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCalculator') and name = 'PBMMinPct') begin
	alter table tblLeadCalculator add [PBMMinPct] [money] NULL
end 
