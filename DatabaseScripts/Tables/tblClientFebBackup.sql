/****** Object:  Table [dbo].[tblClientFebBackup]    Script Date: 11/19/2007 11:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientFebBackup](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[PrimaryPersonID] [int] NULL,
	[EnrollmentID] [int] NOT NULL,
	[TrustID] [int] NULL,
	[AccountNumber] [varchar](50) NULL,
	[DepositMethod] [varchar](50) NULL,
	[DepositDay] [int] NULL,
	[DepositAmount] [money] NULL,
	[BankName] [varchar](255) NULL,
	[BankRoutingNumber] [varchar](50) NULL,
	[BankAccountNumber] [varchar](50) NULL,
	[BankType] [varchar](1) NULL,
	[BankCity] [varchar](50) NULL,
	[BankStateID] [int] NULL,
	[BankFraction] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[Password] [int] NULL,
	[SetupFee] [money] NULL,
	[SetupFeePercentage] [money] NULL,
	[SettlementFeePercentage] [money] NULL,
	[MonthlyFee] [money] NULL,
	[MonthlyFeeDay] [int] NULL,
	[MonthlyFeeStartDate] [datetime] NULL,
	[AdditionalAccountFee] [money] NULL,
	[ReturnedCheckFee] [money] NULL,
	[OvernightDeliveryFee] [money] NULL,
	[AgencyID] [int] NULL,
	[CompanyID] [int] NULL,
	[AssignedUnderwriter] [int] NULL,
	[AssignedCSRep] [int] NULL,
	[AssignedMediator] [int] NULL,
	[ReceivedLSA] [bit] NULL,
	[ReceivedDeposit] [bit] NULL,
	[VWDESaved] [datetime] NULL,
	[VWDESavedBy] [int] NULL,
	[VWDEResolved] [datetime] NULL,
	[VWDEResolvedBy] [int] NULL,
	[VWUWSaved] [datetime] NULL,
	[VWUWSavedBy] [int] NULL,
	[VWUWResolved] [datetime] NULL,
	[VWUWResolvedBy] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[ImportID] [int] NULL,
	[SentWelcomeCoverLetter] [datetime] NULL,
	[SentByWelcomeCoverLetter] [int] NULL,
	[SentWelcomeCallLetter] [datetime] NULL,
	[SentByWelcomeCallLetter] [int] NULL,
	[SentCreditorLetters] [datetime] NULL,
	[SentByCreditorLetters] [int] NULL,
	[SentWelcomePackage] [datetime] NULL,
	[SentByWelcomePackage] [int] NULL,
	[NoChecks] [bit] NOT NULL,
	[CurrentClientStatusID] [int] NULL,
	[DepositStartDate] [datetime] NULL,
	[OldClientID] [int] NULL,
	[AutoAssignMediator] [bit] NOT NULL,
	[PFOBalance] [money] NOT NULL,
	[SDABalance] [money] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
