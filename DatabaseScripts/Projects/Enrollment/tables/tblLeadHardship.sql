
if object_id('tblLeadHardship') is null begin
	CREATE TABLE [dbo].[tblLeadHardship](
		[LeadHardshipID] [int] IDENTITY(1,1) NOT NULL,
		[LeadApplicantID] [int] NOT NULL,
		[Hardship] [varchar](30) NOT NULL,
		[HardshipOther] [varchar](100) NULL,
		[OwnRent] [varchar](30) NOT NULL,
		[HomePrinciple] [money] NOT NULL,
		[HomeValue] [money] NOT NULL,
		[401K] [money] NOT NULL,
		[SavingsChecking] [money] NOT NULL,
		[OtherAssets] [money] NOT NULL,
		[OtherDebts] [varchar](100) NOT NULL,
		[MonthlyIncome] [money] NOT NULL,
		[Groceries] [money] NOT NULL,
		[CarIns] [money] NOT NULL,
		[HealthIns] [money] NOT NULL,
		[Utilities] [money] NOT NULL,
		[PhoneBill] [money] NOT NULL,
		[HomeIns] [money] NOT NULL,
		[CarPayments] [money] NOT NULL,
		[AutoFuel] [money] NOT NULL,
		[DiningOut] [money] NOT NULL,
		[Entertainment] [money] NOT NULL,
		[HouseRent] [money] NOT NULL,
		[Other] [money] NOT NULL,
		[Created] [datetime] NOT NULL,
		[Income_work] [decimal](18, 2) NULL,
		[Income_socialsecurity] [decimal](18, 2) NULL,
		[Income_disability] [decimal](18, 2) NULL,
		[Income_retirement] [decimal](18, 2) NULL,
		[Income_selfemployed] [decimal](18, 2) NULL,
		[Income_unemployed] [decimal](18, 2) NULL
	) ON [PRIMARY]

	GO

	SET ANSI_PADDING OFF
	GO

	ALTER TABLE [dbo].[tblLeadHardship]  WITH CHECK ADD FOREIGN KEY([LeadApplicantID])
	REFERENCES [dbo].[tblLeadApplicant] ([LeadApplicantID])
	ON DELETE CASCADE
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ('') FOR [Hardship]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ('') FOR [OwnRent]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [HomePrinciple]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [HomeValue]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [401K]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [SavingsChecking]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [OtherAssets]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ('') FOR [OtherDebts]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [MonthlyIncome]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [Groceries]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [CarIns]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [HealthIns]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [Utilities]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [PhoneBill]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [HomeIns]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [CarPayments]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [AutoFuel]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [DiningOut]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [Entertainment]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [HouseRent]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT ((0)) FOR [Other]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  DEFAULT (getdate()) FOR [Created]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  CONSTRAINT [DF_tblLeadHardship_Income_work]  DEFAULT ((0)) FOR [Income_work]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  CONSTRAINT [DF_tblLeadHardship_Income_socialsecurity]  DEFAULT ((0)) FOR [Income_socialsecurity]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  CONSTRAINT [DF_tblLeadHardship_Income_disability]  DEFAULT ((0)) FOR [Income_disability]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  CONSTRAINT [DF_tblLeadHardship_Income_retirement]  DEFAULT ((0)) FOR [Income_retirement]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  CONSTRAINT [DF_tblLeadHardship_Income_selfemployed]  DEFAULT ((0)) FOR [Income_selfemployed]
	GO

	ALTER TABLE [dbo].[tblLeadHardship] ADD  CONSTRAINT [DF_tblLeadHardship_Income_unemployed]  DEFAULT ((0)) FOR [Income_unemployed]
	GO
end 