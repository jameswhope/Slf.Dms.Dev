/****** Object:  Table [dbo].[tblEnrollment]    Script Date: 11/19/2007 11:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEnrollment](
	[EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NULL,
	[Name] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[Behind] [bit] NULL,
	[BehindID] [int] NULL,
	[ConcernID] [int] NULL,
	[TotalUnsecuredDebt] [money] NULL,
	[TotalMonthlyPayment] [money] NULL,
	[EstimatedEndAmount] [money] NULL,
	[EstimatedEndTime] [int] NULL,
	[DepositCommitment] [money] NULL,
	[BalanceAtEnrollment] [money] NULL,
	[BalanceAtSettlement] [money] NULL,
	[Qualified] [bit] NULL,
	[QualifiedReason] [varchar](255) NULL,
	[Committed] [bit] NULL,
	[CommittedReason] [varchar](255) NULL,
	[DeliveryMethod] [varchar](50) NULL,
	[AgencyID] [int] NULL,
	[CompanyID] [int] NULL,
	[FollowUpDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblEnrollment] PRIMARY KEY CLUSTERED 
(
	[EnrollmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
