
CREATE TABLE [dbo].[tblPotentialCommPay]
(
	[CompanyID] [int] NULL,
	[CommRecID] [int] NULL,
	[EntryTypeID] [int] NULL,
	[Amount] [money] NULL,
	[ForDate] [datetime] NULL,
	[ProjectedOn] [datetime] default(getdate())
)  