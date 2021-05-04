 USE [master]
GO
/****** Object:  Database [WOOLERY]    Script Date: 03/15/2010 14:33:03 ******/
CREATE DATABASE [WOOLERY] ON  PRIMARY 
( NAME = N'WOOLERY', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\WOOLERY.mdf' , SIZE = 6144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WOOLERY_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\WOOLERY_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'WOOLERY', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WOOLERY].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [WOOLERY] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WOOLERY] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WOOLERY] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WOOLERY] SET ANSI_WOOLERYRNINGS OFF 
GO
ALTER DATABASE [WOOLERY] SET ARITHABORT OFF 
GO
ALTER DATABASE [WOOLERY] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WOOLERY] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [WOOLERY] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WOOLERY] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WOOLERY] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WOOLERY] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WOOLERY] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WOOLERY] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WOOLERY] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WOOLERY] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WOOLERY] SET  ENABLE_BROKER 
GO
ALTER DATABASE [WOOLERY] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WOOLERY] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WOOLERY] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WOOLERY] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WOOLERY] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WOOLERY] SET  READ_WRITE 
GO
ALTER DATABASE [WOOLERY] SET RECOVERY FULL 
GO
ALTER DATABASE [WOOLERY] SET  MULTI_USER 
GO
ALTER DATABASE [WOOLERY] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WOOLERY] SET DB_CHAINING OFF 

 USE [WOOLERY]
GO
/****** Object:  Table [dbo].[tblRegisterPayment]    Script Date: 10/04/2010 09:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblRegisterPayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblRegisterPayment](
	[RegisterPaymentId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[FeeRegisterId] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Voided] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPayment_Voided]  DEFAULT ((0)),
	[Bounced] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPayment_Bounced]  DEFAULT ((0)),
	[PFOBalance] [money] NOT NULL CONSTRAINT [DF_tblRegisterPayment_PFOBalance]  DEFAULT ((0)),
	[SDABalance] [money] NOT NULL CONSTRAINT [DF_tblRegisterPayment_SDABalance]  DEFAULT ((0)),
	[Clear] [datetime] NULL,
	[ClearBy] [int] NULL,
	[VoidDate] [datetime] NULL,
	[BounceDate] [datetime] NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ReferenceRegisterPaymentID] [int] NULL,
 CONSTRAINT [PK_tblRegisterPayment] PRIMARY KEY CLUSTERED 
(
	[RegisterPaymentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblAccount]    Script Date: 10/04/2010 09:19:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAccount](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[CurrentCreditorInstanceID] [int] NULL,
	[AccountStatusID] [int] NULL,
	[OriginalAmount] [money] NOT NULL,
	[CurrentAmount] [money] NOT NULL,
	[SetupFeePercentage] [money] NOT NULL,
	[SettlementFeeCredit] [money] NULL,
	[OriginalDueDate] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[Settled] [datetime] NULL,
	[SettledBy] [int] NULL,
	[Removed] [datetime] NULL,
	[RemovedBy] [int] NULL,
	[SettledMediationID] [int] NULL,
	[UnverifiedAmount] [money] NULL,
	[UnverifiedRetainerFee] [money] NULL,
	[Verified] [datetime] NULL,
	[VerifiedAmount] [money] NULL,
	[VerifiedBy] [int] NULL,
	[VerifiedRetainerFee] [money] NULL,
	[OriginalCreditorInstanceID] [int] NULL,
	[PreviousStatus] [int] NULL,
 CONSTRAINT [PK_tblAccount] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblState]    Script Date: 10/04/2010 09:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblState]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblState](
	[StateID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Abbreviation] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[CompanyID] [int] NULL,
	[Region] [varchar](50) NULL,
	[OldCompanyID] [int] NULL,
 CONSTRAINT [PK_tblState] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRegisterPaymentDeposit]    Script Date: 10/04/2010 09:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblRegisterPaymentDeposit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblRegisterPaymentDeposit](
	[RegisterPaymentDepositID] [int] IDENTITY(1,1) NOT NULL,
	[RegisterPaymentID] [int] NOT NULL,
	[DepositRegisterID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Voided] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPaymentDeposit_Voided]  DEFAULT ((0)),
	[Bounced] [bit] NOT NULL CONSTRAINT [DF_tblRegisterPaymentDeposit_Bounced]  DEFAULT ((0)),
	[ModifiedBy] [int] NULL,
	[VoidDate] [datetime] NULL,
	[BounceDate] [datetime] NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ReferenceRegisterPaymentDepositID] [int] NULL,
 CONSTRAINT [PK_tblRegisterPaymentDeposit] PRIMARY KEY CLUSTERED 
(
	[RegisterPaymentDepositID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblLanguage]    Script Date: 10/04/2010 09:20:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLanguage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLanguage](
	[LanguageID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Default] [bit] NOT NULL CONSTRAINT [DF_tblLanguage_Default]  DEFAULT ((0)),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblLanguage] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPhoneType]    Script Date: 10/04/2010 09:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblPhoneType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblPhoneType](
	[PhoneTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblPhoneType] PRIMARY KEY CLUSTERED 
(
	[PhoneTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblClient]    Script Date: 10/04/2010 09:20:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClient]') AND type in (N'U'))
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
	[BankType] [char](2) NULL CONSTRAINT [DF_tblClient_BankType]  DEFAULT ('C'),
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
	[SubsequentMaintFee] [money] NULL,
	[SubMaintFeeStart] [datetime] NULL,
	[ServiceImportId] [int] NULL,
	[MultiDeposit] [bit] NOT NULL DEFAULT ((0)),
	[MaintenanceFeeCap] [money] NULL,
	[RemittName] [nvarchar](250) NULL,
	[BofAConversionDate] [datetime] NULL,
	[AssignedUnderwriterDate] [datetime] NULL,
	[Accept] [bit] NULL,
	[AcceptRejectDate] [datetime] NULL,
	[AcceptRejectBy] [int] NULL,
	[RejectReason] [varchar](500) NULL,
	[ReferenceClientID] [int] NULL,
 CONSTRAINT [PK_tblClient] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAdHocACH]    Script Date: 10/04/2010 09:19:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAdHocACH]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAdHocACH](
	[AdHocAchID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [int] NOT NULL,
	[RegisterID] [int] NULL,
	[DepositDate] [datetime] NOT NULL,
	[DepositAmount] [money] NOT NULL,
	[BankName] [varchar](50) NOT NULL,
	[BankRoutingNumber] [varchar](50) NOT NULL,
	[BankAccountNumber] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[BankType] [varchar](1) NULL,
	[InitialDraftYN] [bit] NULL,
	[BankAccountId] [int] NULL,
 CONSTRAINT [PK_tblAdHocACH] PRIMARY KEY CLUSTERED 
(
	[AdHocAchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPersonPhone]    Script Date: 10/04/2010 09:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblPersonPhone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblPersonPhone](
	[PersonPhoneID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[PhoneID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblPersonPhone] PRIMARY KEY CLUSTERED 
(
	[PersonPhoneID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNachaRegister2]    Script Date: 10/04/2010 09:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNachaRegister2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNachaRegister2](
	[NachaRegisterId] [int] IDENTITY(1,1) NOT NULL,
	[NachaFileId] [int] NOT NULL DEFAULT ((-1)),
	[Name] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[RoutingNumber] [varchar](50) NULL,
	[Type] [char](1) NULL,
	[Amount] [money] NOT NULL,
	[IsPersonal] [bit] NULL,
	[CommRecId] [int] NULL,
	[CompanyID] [int] NOT NULL,
	[ShadowStoreId] [varchar](20) NULL,
	[ClientID] [int] NULL,
	[TrustId] [int] NULL,
	[RegisterID] [int] NULL,
	[RegisterPaymentID] [int] NULL,
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
	[Status] [int] NULL,
	[State] [int] NULL,
	[ReceivedDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL,
	[ExceptionCode] [varchar](255) NULL,
	[Notes] [varchar](max) NULL,
	[ExceptionResolved] [bit] NULL,
	[Flow] [varchar](6) NOT NULL,
	[ReferenceNachaRegisterID] [int] NULL,
 CONSTRAINT [PK_tblNachaRegister2] PRIMARY KEY CLUSTERED 
(
	[NachaRegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPhone]    Script Date: 10/04/2010 09:21:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblPhone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblPhone](
	[PhoneID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PhoneTypeID] [int] NOT NULL,
	[AreaCode] [varchar](50) NOT NULL,
	[Number] [varchar](50) NOT NULL,
	[Extension] [varchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_btlPhone] PRIMARY KEY CLUSTERED 
(
	[PhoneID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAuditTable]    Script Date: 10/04/2010 09:20:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAuditTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAuditTable](
	[AuditTableID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[PKColumn] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblAuditTable] PRIMARY KEY CLUSTERED 
(
	[AuditTableID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNachaRegister]    Script Date: 10/04/2010 09:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNachaRegister]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNachaRegister](
	[NachaRegisterId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NachaFileId] [int] NULL,
	[Name] [varchar](50) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[RoutingNumber] [varchar](9) NOT NULL,
	[Type] [varchar](1) NOT NULL CONSTRAINT [DF_tblNachaRegister_Type]  DEFAULT ('C'),
	[Amount] [money] NOT NULL,
	[IdTidbit] [varchar](50) NULL,
	[IsPersonal] [bit] NOT NULL CONSTRAINT [DF_tblNachaRegister_IsPersonal]  DEFAULT ((1)),
	[CommRecId] [int] NOT NULL,
	[IsDeclined] [bit] NOT NULL CONSTRAINT [DF_tblNachaRegister_IsDeclined]  DEFAULT ((0)),
	[DeclinedReason] [varchar](255) NULL,
	[DeclinedDate] [datetime] NULL,
	[CompanyID] [int] NULL,
	[Created] [datetime] NULL DEFAULT (getdate()),
	[ClientID] [int] NULL,
	[RegisterID] [int] NULL,
 CONSTRAINT [PK_tblNachaRegister] PRIMARY KEY CLUSTERED 
(
	[NachaRegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAuditColumn]    Script Date: 10/04/2010 09:20:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAuditColumn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAuditColumn](
	[AuditColumnID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AuditTableID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsBigValue] [bit] NOT NULL CONSTRAINT [DF_tblAuditColumn_IsBigValue]  DEFAULT ((0)),
 CONSTRAINT [PK_tblAuditColumn] PRIMARY KEY CLUSTERED 
(
	[AuditColumnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCompany]    Script Date: 10/04/2010 09:20:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCompany]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCompany](
	[CompanyID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Default] [bit] NOT NULL CONSTRAINT [DF_tblCompany_Default]  DEFAULT ((0)),
	[ShortCoName] [varchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[Contact1] [nvarchar](75) NULL,
	[Contact2] [nvarchar](75) NULL,
	[BillingMessage] [nvarchar](255) NULL,
	[WebSite] [nvarchar](255) NULL,
	[SigPath] [nvarchar](100) NULL,
	[UserID] [nvarchar](50) NULL,
	[ControlledAccountName] [varchar](40) NULL,
	[LandingPage] [varchar](50) NOT NULL DEFAULT (''),
 CONSTRAINT [PK_tblCompany] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAudit]    Script Date: 10/04/2010 09:20:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAudit](
	[AuditID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AuditColumnID] [int] NOT NULL,
	[PK] [int] NOT NULL,
	[Value] [sql_variant] NULL,
	[DC] [datetime] NOT NULL CONSTRAINT [DF_tblAudit_Created]  DEFAULT (getdate()),
	[UC] [int] NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_tblAudit_Deleted]  DEFAULT ((0)),
 CONSTRAINT [PK_tblAudit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblRegister]    Script Date: 10/04/2010 09:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblRegister]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblRegister](
	[RegisterId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[AccountID] [int] NULL,
	[TransactionDate] [datetime] NOT NULL,
	[CheckNumber] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Amount] [money] NOT NULL,
	[Balance] [money] NOT NULL CONSTRAINT [DF_tblRegister_Balance]  DEFAULT ((0)),
	[EntryTypeId] [int] NOT NULL,
	[IsFullyPaid] [bit] NOT NULL CONSTRAINT [DF_tblRegister_IsFullyPaid]  DEFAULT ((0)),
	[Bounce] [datetime] NULL,
	[BounceBy] [int] NULL,
	[Void] [datetime] NULL,
	[VoidBy] [int] NULL,
	[Hold] [datetime] NULL,
	[HoldBy] [int] NULL,
	[Clear] [datetime] NULL,
	[ClearBy] [int] NULL,
	[ImportID] [int] NULL,
	[MediatorID] [int] NULL,
	[OldTable] [varchar](50) NULL,
	[OldID] [int] NULL,
	[ACHMonth] [int] NULL,
	[ACHYear] [int] NULL,
	[FeeMonth] [int] NULL,
	[FeeYear] [int] NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblRegister_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[AdjustedRegisterID] [int] NULL,
	[OriginalAmount] [money] NULL,
	[PFOBalance] [money] NOT NULL CONSTRAINT [DF_tblRegister_PFOBalance]  DEFAULT ((0)),
	[SDABalance] [money] NOT NULL CONSTRAINT [DF_tblRegister_SDABalance]  DEFAULT ((0)),
	[RegisterSetID] [int] NULL,
	[InitialDraftYN] [bit] NULL,
	[CompanyID] [int] NULL,
	[BouncedReason] [int] NULL,
	[ClientDepositID] [int] NULL,
	[NotC21] [bit] NULL,
	[ReferenceRegisterID] [int] NULL,
 CONSTRAINT [PK_tblRegister] PRIMARY KEY CLUSTERED 
(
	[RegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCommRec]    Script Date: 10/04/2010 09:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCommRec]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCommRec](
	[CommRecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CommRecTypeID] [int] NOT NULL,
	[Abbreviation] [varchar](10) NOT NULL,
	[Display] [varchar](50) NOT NULL,
	[IsCommercial] [bit] NOT NULL CONSTRAINT [DF_tblCommRec_IsCommercial]  DEFAULT ((0)),
	[IsLocked] [bit] NOT NULL CONSTRAINT [DF_tblCommRec_IsLocked]  DEFAULT ((0)),
	[IsTrust] [bit] NOT NULL CONSTRAINT [DF_tblCommRec_IsTrust]  DEFAULT ((0)),
	[Method] [varchar](50) NOT NULL,
	[BankName] [varchar](50) NULL,
	[RoutingNumber] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[Type] [varchar](1) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[CompanyID] [int] NULL,
	[AgencyID] [int] NULL,
	[ParentCommRecID] [int] NULL,
	[IsGCA] [bit] NOT NULL DEFAULT ((0)),
	[AccountTypeID] [int] NULL,
 CONSTRAINT [PK_tblCommRec] PRIMARY KEY CLUSTERED 
(
	[CommRecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTransferLog]    Script Date: 10/04/2010 09:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblTransferLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblTransferLog](
	[TransferLogID] [int] IDENTITY(1,1) NOT NULL,
	[DBTransferFrom] [nvarchar](50) NULL,
	[DBTransferTo] [nvarchar](50) NULL,
	[tblFrom] [nvarchar](50) NULL,
	[tblTo] [nvarchar](50) NULL,
	[TransferDate] [datetime] NULL,
	[ClientID] [int] NULL,
	[Amount] [money] NULL,
	[EntryTypeID] [int] NULL,
	[CompanyID] [int] NULL,
	[Notes] [nvarchar](150) NULL,
 CONSTRAINT [PK_tblTransferLog] PRIMARY KEY CLUSTERED 
(
	[TransferLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblClientDepositDay]    Script Date: 10/04/2010 09:20:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClientDepositDay]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblClientDepositDay](
	[ClientDepositId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[Frequency] [varchar](10) NOT NULL,
	[DepositDay] [int] NOT NULL,
	[Occurrence] [int] NULL,
	[DepositAmount] [money] NOT NULL,
	[DepositMethod] [varchar](5) NOT NULL DEFAULT ('Check'),
	[BankAccountId] [int] NULL,
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [int] NULL,
	[ReferenceClientDepositID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClientDepositId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNachaFile]    Script Date: 10/04/2010 09:21:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNachaFile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNachaFile](
	[NachaFileId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Date] [datetime] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[DateSent] [datetime] NULL,
 CONSTRAINT [PK_tblNachaFile] PRIMARY KEY CLUSTERED 
(
	[NachaFileId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblPerson]    Script Date: 10/04/2010 09:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblPerson]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblPerson](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[SSN] [varchar](50) NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Gender] [varchar](1) NULL,
	[DateOfBirth] [datetime] NULL,
	[LanguageID] [int] NOT NULL,
	[EmailAddress] [varchar](50) NULL,
	[Street] [varchar](255) NULL,
	[Street2] [varchar](255) NULL,
	[City] [varchar](50) NULL,
	[StateID] [int] NULL,
	[ZipCode] [varchar](50) NULL,
	[Relationship] [varchar](50) NOT NULL,
	[CanAuthorize] [bit] NOT NULL CONSTRAINT [DF_tblPerson_CanAuthorize]  DEFAULT ((0)),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[WebCity] [varchar](50) NULL,
	[WebStateID] [int] NULL,
	[WebZipCode] [varchar](50) NULL,
	[WebAreaCode] [varchar](50) NULL,
	[WebTimeZoneID] [int] NULL,
	[ThirdParty] [bit] NOT NULL CONSTRAINT [DF_tblPerson_ThirdParty]  DEFAULT ((0)),
	[IsDeceased] [bit] NULL,
 CONSTRAINT [PK_tblPerson] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblClientBankAccount]    Script Date: 10/04/2010 09:20:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClientBankAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblClientBankAccount](
	[BankAccountId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[RoutingNumber] [varchar](9) NOT NULL,
	[AccountNumber] [varchar](75) NULL,
	[BankType] [varchar](1) NULL CONSTRAINT [DF_tblClientBankAccount_BankType]  DEFAULT ('C'),
	[Created] [datetime] NOT NULL CONSTRAINT [DF__tblClient__Creat__6761A89B]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[PrimaryAccount] [bit] NOT NULL CONSTRAINT [DF__tblClient__Prima__6855CCD4]  DEFAULT ((0)),
	[Disabled] [datetime] NULL,
	[DisabledBy] [int] NULL,
	[ReferenceBankAccountID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDepositRuleAch]    Script Date: 10/04/2010 09:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblDepositRuleAch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblDepositRuleAch](
	[RuleACHId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[DepositDay] [int] NOT NULL,
	[DepositAmount] [money] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[ClientDepositId] [int] NOT NULL,
	[BankAccountId] [int] NOT NULL,
	[OldRuleId] [int] NULL,
	[Locked] [bit] NOT NULL DEFAULT ((0)),
	[ReferenceRuleACHID] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblImportedClient]    Script Date: 10/04/2010 09:20:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblImportedClient]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblImportedClient](
	[ImportId] [int] IDENTITY(1,1) NOT NULL,
	[ImportJobId] [int] NOT NULL,
	[SourceId] [int] NOT NULL,
	[ExternalClientId] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[ImportId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLeadCategories]    Script Date: 10/04/2010 09:20:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLeadCategories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLeadCategories](
	[CategoryID] [int] IDENTITY(100,1) NOT NULL,
	[Category] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblVerificationCall]    Script Date: 10/04/2010 09:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblVerificationCall]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblVerificationCall](
	[VerificationCallId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL DEFAULT (getdate()),
	[EndDate] [datetime] NULL,
	[Completed] [bit] NOT NULL DEFAULT ((0)),
	[ExecutedBy] [int] NOT NULL,
	[RecordedCallPath] [varchar](1000) NULL,
	[DocumentPath] [varchar](1000) NULL,
	[CallIdKey] [varchar](50) NOT NULL,
	[RecCallIdKey] [varchar](50) NULL,
	[LanguageId] [int] NOT NULL DEFAULT ((1)),
	[LastStep] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[VerificationCallId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBankHoliday]    Script Date: 10/04/2010 09:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBankHoliday]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBankHoliday](
	[BankHolidayId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Date] [datetime] NOT NULL,
	[Name] [varchar](32) NULL,
 CONSTRAINT [PK_tblBankHoliday] PRIMARY KEY CLUSTERED 
(
	[BankHolidayId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNachaCabinet]    Script Date: 10/04/2010 09:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNachaCabinet]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNachaCabinet](
	[NachaCabinetID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NachaRegisterID] [int] NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[TypeID] [int] NOT NULL,
	[TrustID] [int] NULL,
 CONSTRAINT [PK_tblNachaRegisterCabinet] PRIMARY KEY CLUSTERED 
(
	[NachaCabinetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRuleACH]    Script Date: 10/04/2010 09:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblRuleACH]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblRuleACH](
	[RuleACHId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[DepositDay] [int] NOT NULL,
	[DepositAmount] [money] NOT NULL,
	[BankName] [varchar](50) NOT NULL,
	[BankRoutingNumber] [varchar](50) NOT NULL,
	[BankAccountNumber] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[BankType] [varchar](1) NULL,
 CONSTRAINT [PK_tblRuleACH] PRIMARY KEY CLUSTERED 
(
	[RuleACHId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblEntryType]    Script Date: 10/04/2010 09:20:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEntryType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEntryType](
	[EntryTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[DisplayName] [varchar](50) NULL,
	[Order] [int] NULL,
	[Fee] [bit] NOT NULL CONSTRAINT [DF_tblEntryType_Fee]  DEFAULT ((0)),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[System] [bit] NOT NULL CONSTRAINT [DF_tblEntryType_System]  DEFAULT ((0)),
	[IsMatterEntry] [bit] NULL,
	[IsFlateRate] [bit] NULL,
	[Rate] [money] NULL,
 CONSTRAINT [PK_tblEntryType] PRIMARY KEY CLUSTERED 
(
	[EntryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLeadVendors]    Script Date: 10/04/2010 09:21:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLeadVendors]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLeadVendors](
	[VendorID] [int] IDENTITY(200,1) NOT NULL,
	[VendorCode] [varchar](50) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[DefaultCost] [money] NOT NULL DEFAULT ((0)),
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[SuppressionEmail] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLeadProducts]    Script Date: 10/04/2010 09:20:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLeadProducts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLeadProducts](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [varchar](20) NOT NULL,
	[ProductDesc] [varchar](200) NOT NULL,
	[VendorID] [int] NOT NULL,
	[Cost] [money] NOT NULL DEFAULT ((0)),
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[Active] [bit] NOT NULL DEFAULT ((1)),
	[StartTime] [varchar](20) NULL,
	[EndTime] [varchar](20) NULL,
	[DefaultSourceId] [int] NULL,
	[IsDNIS] [bit] NOT NULL DEFAULT ((0)),
	[NewCost] [money] NULL,
	[EffectiveDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLeadAffiliates]    Script Date: 10/04/2010 09:20:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLeadAffiliates]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLeadAffiliates](
	[AffiliateID] [int] IDENTITY(1,1) NOT NULL,
	[AffiliateCode] [varchar](20) NOT NULL,
	[AffiliateDesc] [varchar](200) NOT NULL,
	[ProductID] [int] NOT NULL,
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AffiliateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLeadApplicant]    Script Date: 10/04/2010 09:20:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLeadApplicant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLeadApplicant](
	[LeadApplicantID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[FullName] [nvarchar](200) NULL,
	[Address1] [nvarchar](150) NULL,
	[City] [nvarchar](50) NULL,
	[StateID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_StateID]  DEFAULT ((0)),
	[ZipCode] [nvarchar](50) NULL,
	[HomePhone] [nvarchar](20) NULL,
	[BusinessPhone] [nvarchar](50) NULL,
	[CellPhone] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[Email] [nvarchar](50) NULL,
	[SSN] [nvarchar](12) NULL,
	[DOB] [datetime] NULL CONSTRAINT [DF_tblLeadApplicant_DOB]  DEFAULT ('1/1/1900'),
	[ConcernsID] [int] NOT NULL CONSTRAINT [DF_tblLeadApplicant_ConcernsID]  DEFAULT ((0)),
	[LeadSourceID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_LeadSourceID]  DEFAULT ((0)),
	[CompanyID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_CompanyID]  DEFAULT ((0)),
	[LanguageID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_LanguageID]  DEFAULT ((0)),
	[DeliveryID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_DeliveryID]  DEFAULT ((0)),
	[RepID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_RepID]  DEFAULT ((0)),
	[StatusID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_StatusID]  DEFAULT ((0)),
	[ReasonID] [int] NULL,
	[BankRoutingNumber] [nvarchar](9) NULL,
	[BankAccountNumber] [nvarchar](50) NULL,
	[BankAccountType] [nvarchar](50) NULL,
	[NameOnAccount] [nvarchar](300) NULL,
	[NotesID] [int] NULL,
	[LeadTransferInDate] [datetime] NULL CONSTRAINT [DF_tblLeadApplicant_LeadTransferInDate]  DEFAULT (getdate()),
	[LeadTransferOutDate] [datetime] NULL,
	[Created] [datetime] NULL CONSTRAINT [DF_tblLeadApplicant_Created]  DEFAULT (getdate()),
	[CreatedByID] [int] NULL,
	[LastModified] [datetime] NULL CONSTRAINT [DF_tblLeadApplicant_LastModified]  DEFAULT (getdate()),
	[LastModifiedByID] [int] NULL,
	[DebtAmount] [decimal](18, 2) NULL,
	[BehindID] [int] NULL CONSTRAINT [DF_tblLeadApplicant_BehindID]  DEFAULT ((0)),
	[LeadPhone] [nvarchar](20) NULL,
	[LeadZip] [nvarchar](50) NULL,
	[LeadName] [varchar](50) NULL,
	[LeadAssignedToDate] [datetime] NULL,
	[PaperLeadCode] [varchar](50) NULL,
	[FirstAppointmentDate] [datetime] NULL,
	[TimeZoneId] [int] NULL CONSTRAINT [DF_tblLeadApplicant_TimeZoneID]  DEFAULT ((0)),
	[EnrollmentPage] [varchar](50) NULL CONSTRAINT [DF__tblLeadAp__Enrol__6C114F1F]  DEFAULT ('newenrollment2.aspx'),
	[Processor] [int] NULL,
	[procAssigned] [datetime] NULL,
	[RgrId] [bigint] NULL,
	[Rcid] [varchar](100) NULL,
	[PublisherId] [varchar](50) NULL,
	[Subdomain] [varchar](30) NULL,
	[ProductID] [int] NULL,
	[Referrer] [varchar](300) NULL,
	[RemoteAddr] [varchar](20) NULL,
	[Cost] [money] NULL,
	[CallIdKey] [varchar](50) NULL,
	[AffiliateID] [int] NULL,
	[ReasonOther] [varchar](300) NULL,
	[Refund] [bit] NOT NULL DEFAULT ((0)),
	[RefundDate] [datetime] NULL,
 CONSTRAINT [PK_tblLeadApplicant] PRIMARY KEY CLUSTERED 
(
	[LeadApplicantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLeadVerification]    Script Date: 10/04/2010 09:21:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLeadVerification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLeadVerification](
	[LeadVerificationID] [int] IDENTITY(1,1) NOT NULL,
	[LeadApplicantID] [int] NOT NULL,
	[PVN] [varchar](10) NULL,
	[VDate] [char](8) NOT NULL,
	[AccessNumber] [varchar](10) NULL,
	[Result] [varchar](5) NULL,
	[Submitted] [datetime] NOT NULL DEFAULT (getdate()),
	[SubmittedBy] [int] NOT NULL,
	[Completed] [datetime] NULL,
	[ConfNum] [varchar](30) NULL,
	[ConfEntered] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LeadVerificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK__tblLeadAf__Produ__60283922]    Script Date: 10/04/2010 09:20:42 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tblLeadAf__Produ__60283922]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLeadAffiliates]'))
ALTER TABLE [dbo].[tblLeadAffiliates]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[tblLeadProducts] ([ProductID])
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__tblLeadAp__Affil__1F46DA62]    Script Date: 10/04/2010 09:20:55 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tblLeadAp__Affil__1F46DA62]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLeadApplicant]'))
ALTER TABLE [dbo].[tblLeadApplicant]  WITH CHECK ADD  CONSTRAINT [FK__tblLeadAp__Affil__1F46DA62] FOREIGN KEY([AffiliateID])
REFERENCES [dbo].[tblLeadAffiliates] ([AffiliateID])
GO
ALTER TABLE [dbo].[tblLeadApplicant] CHECK CONSTRAINT [FK__tblLeadAp__Affil__1F46DA62]
GO
/****** Object:  ForeignKey [FK__tblLeadAp__Produ__7B738E40]    Script Date: 10/04/2010 09:20:55 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tblLeadAp__Produ__7B738E40]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLeadApplicant]'))
ALTER TABLE [dbo].[tblLeadApplicant]  WITH CHECK ADD  CONSTRAINT [FK__tblLeadAp__Produ__7B738E40] FOREIGN KEY([ProductID])
REFERENCES [dbo].[tblLeadProducts] ([ProductID])
GO
ALTER TABLE [dbo].[tblLeadApplicant] CHECK CONSTRAINT [FK__tblLeadAp__Produ__7B738E40]
GO
/****** Object:  ForeignKey [FK__tblLeadPr__Vendo__5C57A83E]    Script Date: 10/04/2010 09:20:59 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tblLeadPr__Vendo__5C57A83E]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLeadProducts]'))
ALTER TABLE [dbo].[tblLeadProducts]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[tblLeadVendors] ([VendorID])
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__tblLeadVe__Categ__55AAAAAF]    Script Date: 10/04/2010 09:21:01 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tblLeadVe__Categ__55AAAAAF]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLeadVendors]'))
ALTER TABLE [dbo].[tblLeadVendors]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[tblLeadCategories] ([CategoryID])
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__tblLeadVe__LeadA__08AD8DCD]    Script Date: 10/04/2010 09:21:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tblLeadVe__LeadA__08AD8DCD]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLeadVerification]'))
ALTER TABLE [dbo].[tblLeadVerification]  WITH CHECK ADD  CONSTRAINT [FK__tblLeadVe__LeadA__08AD8DCD] FOREIGN KEY([LeadApplicantID])
REFERENCES [dbo].[tblLeadApplicant] ([LeadApplicantID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblLeadVerification] CHECK CONSTRAINT [FK__tblLeadVe__LeadA__08AD8DCD]
GO
