
IF OBJECT_ID('tblClient') IS NULL 
BEGIN
CREATE TABLE [dbo].[tblClient](
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
	[Password] [varchar](50) NULL,
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
	[NoChecks] [bit] NOT NULL CONSTRAINT [DF_tblClient_NoChecks]  DEFAULT ((0)),
	[CurrentClientStatusID] [int] NULL,
	[DepositStartDate] [datetime] NULL,
	[OldClientID] [int] NULL,
	[AutoAssignMediator] [bit] NOT NULL CONSTRAINT [DF_tblClient_AutoAssignMediator]  DEFAULT ((1)),
	[PFOBalance] [money] NOT NULL CONSTRAINT [DF_tblClient_PFOBalance]  DEFAULT ((0)),
	[SDABalance] [money] NOT NULL CONSTRAINT [DF_tblClient_SDABalance]  DEFAULT ((0)),
	[StorageServer] [varchar](50) NULL CONSTRAINT [DF_tblClient_StorageServer]  DEFAULT ('nas02'),
	[StorageRoot] [varchar](50) NULL CONSTRAINT [DF_tblClient_StorageRoot]  DEFAULT ('ClientStorage'),
	[InitialAgencyPercent] [money] NULL,
	[InitialDraftDate] [datetime] NULL,
	[InitialDraftAmount] [money] NULL,
	[AgentName] [nvarchar](150) NULL,
	[CommScenID] [int],
	 CONSTRAINT [PK_tblClient] PRIMARY KEY CLUSTERED 
	(
		[ClientID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]
END

/*
	1/22/08		jhernandez		Clients will be tied directly to a commission scenario.
*/
if not exists (select 1 from syscolumns where id = object_id('tblClient') and name = 'CommScenID') 
begin
	alter table tblClient add [CommScenID] [int] NULL 
	set @coladded = 1
end

update tblClient
set CommScenID = isnull(s.CommScenID, 10)
from tblClient c
left join tblCommScen s on s.AgencyID = c.AgencyID
