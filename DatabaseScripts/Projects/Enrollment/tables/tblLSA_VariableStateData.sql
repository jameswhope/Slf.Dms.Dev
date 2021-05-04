IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLSA_VariableStateData')
	BEGIN
		CREATE TABLE [dbo].[tblLSA_VariableStateData](
	[ClientState] [nvarchar](255) NULL,
	[SettlementAttorneyFirmName] [nvarchar](255) NULL,
	[RetainerFeeAmount] [nvarchar](255) NULL,
	[AssociatedAttorneyInClientsState] [nvarchar](255) NULL,
	[CustomerServicePhoneNumber] [nvarchar](255) NULL,
	[SettlementAttorneyAddress] [nvarchar](255) NULL,
	[SettlementAttorneyLicensedState] [nvarchar](255) NULL,
	[StateID] [int] NULL,
	[CompanyID] [int] NULL
) ON [PRIMARY]
	END
GO

