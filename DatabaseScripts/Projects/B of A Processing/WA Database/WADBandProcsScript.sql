 USE [WA]
/****** Object:  Table [dbo].[tblEMSDailyTransactionJournal]    Script Date: 11/12/2010 10:21:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEMSDailyTransactionJournal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEMSDailyTransactionJournal](
	[Code] [nvarchar](6) NULL,
	[Sub] [nvarchar](16) NULL,
	[Group] [nvarchar](10) NULL,
	[TinDate] [nvarchar](50) NULL,
	[Amount] [nvarchar](15) NULL,
	[Balance] [nvarchar](15) NULL,
	[Name_Description] [nvarchar](41) NULL,
	[Address_Memo] [nvarchar](41) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblEMSMonthlyBalances]    Script Date: 11/12/2010 10:21:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEMSMonthlyBalances]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEMSMonthlyBalances](
	[SubAccount] [nvarchar](16) NULL,
	[RegisterID] [nvarchar](10) NULL,
	[SSN] [nvarchar](9) NULL,
	[Name] [nvarchar](41) NULL,
	[OpenDate] [nvarchar](10) NULL,
	[CurrentBalance] [nvarchar](15) NULL,
	[AccruedInt] [nvarchar](13) NULL,
	[AccruedWhld] [nvarchar](13) NULL,
	[Rate] [nvarchar](6) NULL,
	[YTDInterest] [nvarchar](13) NULL,
	[YTDWhld] [nvarchar](13) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblM2M_PREDAYDetail]    Script Date: 11/12/2010 10:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblM2M_PREDAYDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblM2M_PREDAYDetail](
	[M2MDetailID] [int] IDENTITY(1,1) NOT NULL,
	[Rpt_Date] [nvarchar](50) NULL,
	[Amount] [nvarchar](50) NULL,
	[Account] [nvarchar](50) NULL,
	[ABA_Routing] [nvarchar](50) NULL,
	[Bank_Ref] [nvarchar](255) NULL,
	[Cust_Ref] [nvarchar](50) NULL,
	[FreeFormText] [nvarchar](max) NULL,
	[BAI_Code] [nvarchar](50) NULL,
	[BAI_Description] [nvarchar](255) NULL,
	[Amount_absolute_unformatted] [nvarchar](50) NULL,
	[Funds_Type] [nvarchar](255) NULL,
	[Distributed_Immediate_Availability] [nvarchar](50) NULL,
	[Distributed_1_Day_Availability] [nvarchar](50) NULL,
	[Distributed_gt_1_Day_Availability] [nvarchar](50) NULL,
	[Value_Date] [nvarchar](50) NULL,
	[Value_Time] [nvarchar](50) NULL,
	[Created] [datetime] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblM2M_CURDAYDetail]    Script Date: 11/12/2010 10:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblM2M_CURDAYDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblM2M_CURDAYDetail](
	[M2MDetailID] [int] IDENTITY(1,1) NOT NULL,
	[Rpt_Date] [nvarchar](50) NULL,
	[Amount] [nvarchar](50) NULL,
	[Account] [nvarchar](50) NULL,
	[ABA_Routing] [nvarchar](50) NULL,
	[Bank_Ref] [nvarchar](255) NULL,
	[Cust_Ref] [nvarchar](50) NULL,
	[FreeFormText] [nvarchar](max) NULL,
	[BAI_Code] [nvarchar](50) NULL,
	[BAI_Description] [nvarchar](255) NULL,
	[Amount_absolute_unformatted] [nvarchar](50) NULL,
	[Funds_Type] [nvarchar](255) NULL,
	[Distributed_Immediate_Availability] [nvarchar](50) NULL,
	[Distributed_1_Day_Availability] [nvarchar](50) NULL,
	[Distributed_gt_1_Day_Availability] [nvarchar](50) NULL,
	[Value_Date] [nvarchar](50) NULL,
	[Value_Time] [nvarchar](50) NULL,
	[Created] [datetime] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNACHA_CCDReject_03-04]    Script Date: 11/12/2010 10:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNACHA_CCDReject_03-04]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNACHA_CCDReject_03-04](
	[NACHACCDRejectID] [int] IDENTITY(1,1) NOT NULL,
	[RecordType] [nvarchar](2) NULL,
	[TraceNumber] [nvarchar](7) NULL,
	[TransactionCode] [nvarchar](2) NULL,
	[RoutingTransitNumber] [nvarchar](9) NULL,
	[ReceiverAccountNumber] [nvarchar](17) NULL,
	[Amount] [nvarchar](20) NULL,
	[IndividualID] [nvarchar](10) NULL,
	[Filler] [nvarchar](18) NULL,
	[RejectRecord] [nvarchar](2) NULL,
	[IndividualName] [nvarchar](20) NULL,
	[TransactionRejectReason] [nvarchar](50) NULL,
	[Filler2] [nvarchar](6) NULL,
 CONSTRAINT [PK_NACHACCDSummary] PRIMARY KEY CLUSTERED 
(
	[NACHACCDRejectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNACHA_PPDStatistics_02]    Script Date: 11/12/2010 10:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNACHA_PPDStatistics_02]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNACHA_PPDStatistics_02](
	[NACHAPPDStatisticsID] [int] IDENTITY(1,1) NOT NULL,
	[RecordID] [nvarchar](2) NULL,
	[TotalDebitAmount] [nvarchar](12) NULL,
	[TotalCreditAmount] [nvarchar](12) NULL,
	[ItemTotal] [nvarchar](12) NULL,
	[TotalRejectedItems] [nvarchar](12) NULL,
	[RejectedDollarTotals] [nvarchar](12) NULL,
	[Filler] [nvarchar](6) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNACHA_PPDReject_03-04]    Script Date: 11/12/2010 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNACHA_PPDReject_03-04]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNACHA_PPDReject_03-04](
	[NACHAPPDRejectID] [int] IDENTITY(1,1) NOT NULL,
	[RecordType] [nvarchar](2) NULL,
	[TraceNumber] [nvarchar](7) NULL,
	[TransactionCode] [nvarchar](2) NULL,
	[RoutingTransitNumber] [nvarchar](9) NULL,
	[ReceiverAccountNumber] [nvarchar](17) NULL,
	[Amount] [nvarchar](20) NULL,
	[IndividualID] [nvarchar](10) NULL,
	[Filler] [nvarchar](18) NULL,
	[RejectRecord] [nvarchar](2) NULL,
	[IndividualName] [nvarchar](20) NULL,
	[TransactionRejectReason] [nvarchar](50) NULL,
	[Filler2] [nvarchar](6) NULL,
 CONSTRAINT [PK_NACHAPPDSummary] PRIMARY KEY CLUSTERED 
(
	[NACHAPPDRejectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblICLRECFileHeader_05]    Script Date: 11/12/2010 10:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLRECFileHeader_05]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLRECFileHeader_05](
	[FileHeaderId] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[CustomerID] [nvarchar](6) NULL,
	[FileName] [nvarchar](40) NULL,
	[FileCreationDate] [nvarchar](8) NULL,
	[FileCreationTime] [nvarchar](4) NULL,
	[ResendIndicator] [nvarchar](1) NULL,
	[FileIDModifier] [nvarchar](1) NULL,
	[FileValidationStatus] [nvarchar](18) NULL,
 CONSTRAINT [PK_tblICLRECFileHeader_05] PRIMARY KEY CLUSTERED 
(
	[FileHeaderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblICLRECFileDetail_06]    Script Date: 11/12/2010 10:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLRECFileDetail_06]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLRECFileDetail_06](
	[FileDetailId] [int] IDENTITY(1,1) NOT NULL,
	[FileHeaderId] [int] NULL,
	[FileRejectReasonCatagories] [varchar](57) NULL,
	[AddendumRecordCount] [varchar](3) NULL,
	[CashLetterID] [varchar](8) NULL,
	[BundleID] [varchar](50) NULL,
 CONSTRAINT [PK_tblICLRECFileDetail_06] PRIMARY KEY CLUSTERED 
(
	[FileDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLRECDetailAddendum_07]    Script Date: 11/12/2010 10:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLRECDetailAddendum_07]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLRECDetailAddendum_07](
	[ICLRECDetailAddendumID] [int] IDENTITY(1,1) NOT NULL,
	[FileDetailID] [int] NULL,
	[AddendumRecordNumber] [nvarchar](3) NULL,
	[FileRejectReasonNumber] [nvarchar](2) NULL,
	[FileRejectReason] [nvarchar](73) NULL,
 CONSTRAINT [PK_tblICLRECDetailAddendum_07] PRIMARY KEY CLUSTERED 
(
	[ICLRECDetailAddendumID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblICLRECFileControl_09]    Script Date: 11/12/2010 10:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLRECFileControl_09]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLRECFileControl_09](
	[ControlRecordID] [int] IDENTITY(1,1) NOT NULL,
	[FileHeaderID] [int] NULL,
	[TotalCashLetters] [varchar](6) NULL,
	[TotalRecordCount] [varchar](8) NULL,
	[TotalItemCount] [varchar](8) NULL,
	[FileTotalAmount] [varchar](16) NULL,
	[Reserved] [varchar](40) NULL,
 CONSTRAINT [PK_tblICLRECFileControl_09] PRIMARY KEY CLUSTERED 
(
	[ControlRecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLACKCashLetterHeader_10]    Script Date: 11/12/2010 10:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLACKCashLetterHeader_10]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLACKCashLetterHeader_10](
	[CashLetterHeaderId] [int] IDENTITY(1,1) NOT NULL,
	[FileHeaderID] [int] NULL,
	[CashLetterID] [varchar](8) NULL,
	[CashLetterStatus] [varchar](25) NULL,
	[NumberOfItemsInCashLetter] [varchar](8) NULL,
	[TotalAmountOfCashLetter] [varchar](14) NULL,
	[Reserved] [varchar](23) NULL,
 CONSTRAINT [PK_tblICLACKCashLetterHeader_10] PRIMARY KEY CLUSTERED 
(
	[CashLetterHeaderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLACKItemAdjustmentDetail_25]    Script Date: 11/12/2010 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLACKItemAdjustmentDetail_25]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLACKItemAdjustmentDetail_25](
	[ItemAdjustmentDetailId] [int] IDENTITY(1,1) NOT NULL,
	[CashLetterHeaderID] [int] NULL,
	[ItemSequenceNumber] [varchar](15) NULL,
	[BundleID] [varchar](50) NULL,
	[AmountOfItem] [varchar](50) NULL,
	[ItemErrorReason] [varchar](30) NULL,
	[ReportedOverallIQAScore] [varchar](3) NULL,
	[AddendumRecordCount] [varchar](3) NULL,
	[Reserved] [varchar](7) NULL,
 CONSTRAINT [PK_tblICLACKItemAdjustmentDetail_25] PRIMARY KEY CLUSTERED 
(
	[ItemAdjustmentDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLACKItemDetailAddendum_26]    Script Date: 11/12/2010 10:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLACKItemDetailAddendum_26]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLACKItemDetailAddendum_26](
	[ItemDetailAddendumId] [int] IDENTITY(1,1) NOT NULL,
	[CashLetterHeaderID] [int] NULL,
	[ItemAdjustmentDetailID] [int] NULL,
	[AddendumRecordNumber] [varchar](3) NULL,
	[AdjustmentReasonNumber] [varchar](2) NULL,
	[AdjustmentReasonDetail] [varchar](73) NULL,
 CONSTRAINT [PK_tblICLACKItemDetailAddendum_26] PRIMARY KEY CLUSTERED 
(
	[ItemDetailAddendumId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLACKCashLetterControl_90]    Script Date: 11/12/2010 10:21:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLACKCashLetterControl_90]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLACKCashLetterControl_90](
	[CashLetterControlId] [int] IDENTITY(1,1) NOT NULL,
	[CashLetterHeaderID] [int] NULL,
	[NumberOfItemsReportedAsRejected] [varchar](8) NULL,
	[AmountOfItemsReportedAsRejected] [varchar](14) NULL,
	[Reserved] [varchar](56) NULL,
 CONSTRAINT [PK_tblICLACKCashLetterControl_90] PRIMARY KEY CLUSTERED 
(
	[CashLetterControlId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLACKFileControl_99]    Script Date: 11/12/2010 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLACKFileControl_99]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLACKFileControl_99](
	[FileControlId] [int] IDENTITY(1,1) NOT NULL,
	[FileHeaderID] [int] NULL,
	[TotalCashLetters] [varchar](6) NULL,
	[TotalRecords] [varchar](8) NULL,
	[TotalItems] [varchar](8) NULL,
	[FileTotalAmount] [varchar](16) NULL,
	[NumberOfRejectedItemAdjustments] [varchar](8) NULL,
	[TotalAmountOfAdjustmentsInFile] [varchar](14) NULL,
	[Reserved] [varchar](18) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblICLACKFileHeader_01]    Script Date: 11/12/2010 10:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblICLACKFileHeader_01]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblICLACKFileHeader_01](
	[FileHeaderId] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[CustomerID] [varchar](6) NULL,
	[FileName] [varchar](40) NULL,
	[FileCreationDate] [varchar](8) NULL,
	[FileCreationTime] [varchar](4) NULL,
	[ResendIndicator] [varchar](1) NULL,
	[FileIDModifier] [varchar](1) NULL,
	[FileValidationStatus] [varchar](18) NULL,
 CONSTRAINT [PK_tblICLACKFileHeader_01] PRIMARY KEY CLUSTERED 
(
	[FileHeaderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[stp_PopulateM2MTables]    Script Date: 11/12/2010 10:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_PopulateM2MTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- Author:		Jim Hope
-- Create date: 04/29/2010
-- Description:	Populates the M2M tables
-- =============================================
CREATE PROCEDURE [dbo].[stp_PopulateM2MTables] 
AS
BEGIN
SET NOCOUNT ON;
DECLARE @dtToday varchar(50)
DECLARE @dtDay int
DECLARE @dtMonth int
DECLARE @NewDay varchar(2)
DECLARE @NewMonth varchar(2)
DECLARE @NewYear varchar(4)
DECLARE @SearchFor varchar(100)
DECLARE @Results varchar(max)
DECLARE @Populate varchar(1000)

SET @dtDay = datepart(day, getdate())
IF @dtDay < 10 
	BEGIN 
		SET @NewDay = ''0'' + cast(@dtDay AS varchar(2))
	END
ELSE
	BEGIN
		SET @NewDay = cast(@dtDay AS varchar(2))
	END

SET @dtMonth = datepart(month, getdate())
IF @dtMonth < 10
	BEGIN
		SET @NewMonth = ''0'' + cast(@dtMonth AS VARCHAR(2))
	END
ELSE
	BEGIN
		SET @NewMonth = cast(@dtMonth AS VARCHAR(2))
	END

SET @NewYear = cast(datepart(year, getdate()) AS varchar(4))

SET @SearchFor = ''dir /B \\LexsrvsqlProd1\g\services\BofA\M2M\M2MPREDAY_Reply'' + ''_'' + @NewYear + ''_'' + @NewMonth + ''_'' + @NewDay + ''(0).dat''
EXEC @Results = master.dbo.xp_cmdshell @SearchFor
IF @Results = 0
	BEGIN
		SET @Populate = ''\\LexsrvsqlProd1\g\services\BofA\LexxiomEncryption\BofAReportParsing.exe M2MPREDAY \\LexsrvsqlProd1\g\services\BofA\M2M\M2MPREDAY_Reply'' + ''_'' + @NewYear + ''_'' + @NewMonth + ''_'' + @NewDay + ''(0).dat''
		exec @Results = master.dbo.xp_cmdshell @populate
		IF @Results = 0
			BEGIN
				PRINT ''Ppopulated the PREDAY Summary table.''
			END
		ELSE
			BEGIN
				PRINT ''File not found M2MPREDAY_Reply'' + ''_'' + @NewYear + ''_'' + @NewMonth + ''_'' + @NewDay + ''(0).dat''
			END
	END
SET @SearchFor = ''dir /B \\LexsrvsqlProd1\g\services\BofA\M2M\M2MCURDAY_Reply'' + ''_'' + @NewYear + ''_'' + @NewMonth + ''_'' + @NewDay + ''(0).dat''
EXEC @Results = master.dbo.xp_cmdshell @SearchFor
IF @Results = 0
	BEGIN
		SET @Populate = ''\\LexsrvsqlProd1\g\services\BofA\LexxiomEncryption\BofAReportParsing.exe M2MCURDAY \\LexsrvsqlProd1\g\services\BofA\M2M\M2MCURDAY_Reply'' + ''_'' + @NewYear + ''_'' + @NewMonth + ''_'' + @NewDay + ''(0).dat''
		exec @Results = master.dbo.xp_cmdshell @populate
		IF @Results = 0
			BEGIN
				PRINT ''Populated the CURDAY Summary table.''
			END
			BEGIN
				PRINT ''File not found M2MCURDAY_Reply'' + ''_'' + @NewYear + ''_'' + @NewMonth + ''_'' + @NewDay + ''(0).dat''
			END
	END
END' 
END
GO
/****** Object:  Table [dbo].[tblBAFFConfirmation_C29]    Script Date: 11/12/2010 10:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBAFFConfirmation_C29]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBAFFConfirmation_C29](
	[C29ID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[C20ID] [int] NULL,
	[RecordType] [nvarchar](3) NULL,
	[TotalItemCountFirstWireACK] [nvarchar](10) NULL,
	[TotalItemCountFinalWireACK] [nvarchar](50) NULL,
	[Filler] [nvarchar](107) NULL,
 CONSTRAINT [PK_BAFFConfirmation_C29] PRIMARY KEY CLUSTERED 
(
	[C29ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblBAFFConfirmation_C20]    Script Date: 11/12/2010 10:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBAFFConfirmation_C20]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBAFFConfirmation_C20](
	[C20ID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[RecordType] [nvarchar](3) NULL,
	[CustomerReceiverID] [nvarchar](15) NULL,
	[MessagePaymentRefNo] [nvarchar](15) NULL,
	[PaymentStatusCode] [nvarchar](1) NULL,
	[RejectedReasonCode] [nvarchar](3) NULL,
	[RejectedReasonText] [nvarchar](24) NULL,
	[TransactionAmount] [nvarchar](15) NULL,
	[AcknowledgementType] [nvarchar](2) NULL,
	[WireSystemReferenceNumber] [nvarchar](16) NULL,
	[BookFEDReferenceNumber] [nvarchar](30) NULL,
	[Filler] [nvarchar](6) NULL,
 CONSTRAINT [PK_BAFFConfirmation_C20] PRIMARY KEY CLUSTERED 
(
	[C20ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNACHA_CCDStatus_01]    Script Date: 11/12/2010 10:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNACHA_CCDStatus_01]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNACHA_CCDStatus_01](
	[NACHACCDStatusID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[RecordIDCode] [nvarchar](2) NULL,
	[BankTransmissionDate] [nvarchar](6) NULL,
	[BankTransmissionTime] [nvarchar](4) NULL,
	[FileStatus] [nvarchar](13) NULL,
	[ImmediateOrigin] [nvarchar](10) NULL,
	[ImmediateOriginName] [nvarchar](23) NULL,
	[FileIDModifier] [nvarchar](1) NULL,
	[FileCreationDate] [nvarchar](6) NULL,
	[FileCreationTime] [nvarchar](4) NULL,
	[Filler] [nvarchar](11) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNACHA_PPDStatus_01]    Script Date: 11/12/2010 10:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNACHA_PPDStatus_01]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNACHA_PPDStatus_01](
	[NACHAPPDStatusID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[RecordIDCode] [nvarchar](2) NULL,
	[BankTransmissionDate] [nvarchar](6) NULL,
	[BankTransmissionTime] [nvarchar](4) NULL,
	[FileStatus] [nvarchar](13) NULL,
	[ImmediateOrigin] [nvarchar](10) NULL,
	[ImmediateOriginName] [nvarchar](23) NULL,
	[FileIDModifier] [nvarchar](1) NULL,
	[FileCreationDate] [nvarchar](6) NULL,
	[FileCreationTime] [nvarchar](4) NULL,
	[Filler] [nvarchar](11) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNACHA_CCDStatistics_02]    Script Date: 11/12/2010 10:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNACHA_CCDStatistics_02]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNACHA_CCDStatistics_02](
	[NACHACCDStatisticsID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[NACHAPPDStatusID] [int] NULL,
	[RecordID] [nvarchar](2) NULL,
	[TotalDebitAmount] [nvarchar](12) NULL,
	[TotalCreditAmount] [nvarchar](12) NULL,
	[ItemTotal] [nvarchar](12) NULL,
	[TotalRejectedItems] [nvarchar](12) NULL,
	[RejectedDollarTotals] [nvarchar](12) NULL,
	[Filler] [nvarchar](6) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblNOC1]    Script Date: 11/12/2010 10:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNOC1]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNOC1](
	[NOC1ID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[RecordType] [varchar](1) NULL,
	[PriorityCode] [varchar](2) NULL,
	[ImmediateOrigin] [varchar](10) NULL,
	[ImmediateDestination] [varchar](10) NULL,
	[FileCreationDate] [varchar](6) NULL,
	[FileCreationTime] [varchar](4) NULL,
	[FileIDModifier] [varchar](1) NULL,
	[RecordSize] [varchar](3) NULL,
	[BlockingFactor] [varchar](2) NULL,
	[FormatCode] [varchar](1) NULL,
	[CompanyName] [varchar](23) NULL,
	[BankName] [varchar](23) NULL,
	[ReferenceCode] [varchar](8) NULL,
 CONSTRAINT [PK_tblACHRET_1] PRIMARY KEY CLUSTERED 
(
	[NOC1ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNOC5]    Script Date: 11/12/2010 10:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNOC5]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNOC5](
	[NOC5ID] [int] IDENTITY(1,1) NOT NULL,
	[NOC1ID] [int] NULL,
	[RecordType] [varchar](1) NULL,
	[ServiceClassCode] [varchar](3) NULL,
	[CompanyName] [varchar](16) NULL,
	[CompanyDiscretionaryData] [varchar](20) NULL,
	[CompanyIdentification] [varchar](10) NULL,
	[StandardEntryClassCode] [varchar](3) NULL,
	[CompanyEntryDescription] [varchar](10) NULL,
	[CompanyDescriptiveDate] [varchar](6) NULL,
	[EffectiveEntryDate] [varchar](6) NULL,
	[SettlementDate] [varchar](3) NULL,
	[OriginatorStatusCode] [varchar](1) NULL,
	[OriginatingDFIIdentification] [varchar](8) NULL,
	[BatchNumber] [varchar](7) NULL,
 CONSTRAINT [PK_tblNOC5] PRIMARY KEY CLUSTERED 
(
	[NOC5ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNOC7]    Script Date: 11/12/2010 10:22:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNOC7]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNOC7](
	[NOC7ID] [int] IDENTITY(1,1) NOT NULL,
	[NOC6ID] [int] NULL,
	[RecordType] [varchar](1) NULL,
	[AddendaTypeCode] [varchar](2) NULL,
	[ReturnReasonCode] [varchar](3) NULL,
	[OriginalEntryTraceNumber] [varchar](15) NULL,
	[DateOfDeath] [varchar](6) NULL,
	[OrigionalReceivingDFI] [varchar](8) NULL,
	[AddendaInformation] [varchar](44) NULL,
	[TraceNumber] [varchar](15) NULL,
 CONSTRAINT [PK_tblNOC7] PRIMARY KEY CLUSTERED 
(
	[NOC7ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNOC8]    Script Date: 11/12/2010 10:22:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNOC8]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNOC8](
	[NOC8ID] [int] IDENTITY(1,1) NOT NULL,
	[NOC5ID] [int] NULL,
	[RecordType] [varchar](1) NULL,
	[ServiceClassCode] [varchar](3) NULL,
	[Entry_AddendaCount] [varchar](6) NULL,
	[EntryHash] [varchar](10) NULL,
	[TotalDebitAmountInBatch] [varchar](12) NULL,
	[TotalCreditAmountInBatch] [varchar](12) NULL,
	[CompanyIdentification] [varchar](10) NULL,
	[Reserved1] [varchar](19) NULL,
	[Reserved2] [varchar](6) NULL,
	[OriginatingDFI] [varchar](8) NULL,
	[BatchNumber] [varchar](7) NULL,
 CONSTRAINT [PK_tblNOC8] PRIMARY KEY CLUSTERED 
(
	[NOC8ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNOC9]    Script Date: 11/12/2010 10:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNOC9]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNOC9](
	[NOC9ID] [int] IDENTITY(1,1) NOT NULL,
	[NOC1ID] [int] NULL,
	[RecordType] [varchar](1) NULL,
	[BatchCount] [varchar](6) NULL,
	[BlockCount] [varchar](6) NULL,
	[Entry_AddendaCount] [varchar](8) NULL,
	[EntryHash] [varchar](10) NULL,
	[TotalDebitAmountInFile] [varchar](12) NULL,
	[TotalCreditAmountInFile] [varchar](12) NULL,
	[Reserved] [varchar](39) NULL,
 CONSTRAINT [PK_tblNOC9] PRIMARY KEY CLUSTERED 
(
	[NOC9ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblNOC6]    Script Date: 11/12/2010 10:22:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblNOC6]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblNOC6](
	[NOC6ID] [int] IDENTITY(1,1) NOT NULL,
	[NOC5ID] [int] NULL,
	[RecordType] [varchar](1) NULL,
	[TransactionCode] [varchar](2) NULL,
	[RoutingNumber] [varchar](8) NULL,
	[CheckDigit] [varchar](1) NULL,
	[AccountNumber] [varchar](17) NULL,
	[Amount] [varchar](10) NULL,
	[IndividualIDNumber] [varchar](15) NULL,
	[IndividualName] [varchar](22) NULL,
	[Reserved] [varchar](2) NULL,
	[AddendaRecordIndicator] [varchar](1) NULL,
	[TraceNumber] [varchar](15) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBAICodes]    Script Date: 11/12/2010 10:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBAICodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBAICodes](
	[BAICode] [int] NOT NULL,
	[BAIDescription] [nvarchar](255) NULL,
	[TransactionType] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblBIACodes] PRIMARY KEY CLUSTERED 
(
	[BAICode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblM2M_CURDAYSummary]    Script Date: 11/12/2010 10:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblM2M_CURDAYSummary]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblM2M_CURDAYSummary](
	[M2MSummrayID] [int] IDENTITY(1,1) NOT NULL,
	[DateField] [datetime] NULL,
	[ABARoutingField] [nvarchar](9) NULL,
	[AccountField] [nvarchar](50) NULL,
	[BAICode] [nvarchar](255) NULL,
	[BAIDescription] [nvarchar](255) NULL,
	[Amount] [nvarchar](50) NULL,
	[Count] [int] NULL,
	[Funds_Type] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_tblM2M_CURDAYSummary] PRIMARY KEY CLUSTERED 
(
	[M2MSummrayID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblM2M_PREDAYSummary]    Script Date: 11/12/2010 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblM2M_PREDAYSummary]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblM2M_PREDAYSummary](
	[M2MSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[DateField] [datetime] NULL,
	[ABARoutingField] [nvarchar](9) NULL,
	[AccountField] [nvarchar](50) NULL,
	[BAICode] [nvarchar](255) NULL,
	[BAIDescription] [nvarchar](255) NULL,
	[Amount] [nvarchar](50) NULL,
	[Count] [int] NULL,
	[Funds_Type] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_BAISummary] PRIMARY KEY CLUSTERED 
(
	[M2MSummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[get_IsBankHoliday]    Script Date: 11/12/2010 10:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_IsBankHoliday]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[get_IsBankHoliday]
(
	@date datetime
)
AS

BEGIN

SET NOCOUNT ON

SELECT
	CAST(COUNT(BankHolidayId) AS int) AS IsBankHoliday
FROM
	dms..tblBankHoliday
WHERE
	Year(@date) = Year(Date) AND
	Month(@date) = Month(Date) AND
	Day(@date) = Day(Date)

END
' 
END
GO
/****** Object:  Table [dbo].[tblBAFFRejectReason]    Script Date: 11/12/2010 10:21:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBAFFRejectReason]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBAFFRejectReason](
	[BAFFRejectCode] [nvarchar](50) NULL,
	[BAFFRejectDesc] [nvarchar](100) NULL
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[stp_NOC_Returns]    Script Date: 11/12/2010 10:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NOC_Returns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_NOC_Returns] 
	-- Add the parameters for the stored procedure here
	@StartDate DATETIME = ''01/01/1900'', 
	@EndDate DATETIME = ''01/01/2050'',
	@ClientID INT = 0,
	@AccountNumber VARCHAR(50) = ''''''''
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ReportDate DATETIME
	SET @ReportDate = @StartDate

	DECLARE @NOC1ID INT
	DECLARE @NOC5ID INT
	DECLARE @NOC6ID INT
	DECLARE @LawFirm VARCHAR(50)
	DECLARE @SettlementDate VARCHAR(15)
	DECLARE @SearchableStartDate VARCHAR(6)
	DECLARE @SearchableEndDate VARCHAR(6)
	DECLARE @DateHolder VARCHAR(15)
	DECLARE @SettlementAtty VARCHAR(150)
	DECLARE @Amount VARCHAR(50)

	SET @SearchableStartDate = CONVERT(NVARCHAR(8), @ReportDate, 12)
	SET @SearchableEndDate = CONVERT(NVARCHAR(8), @EndDate, 12)

	DECLARE @ReturnedItems TABLE (
	ClientID INT,
	RegisterID INT,
	AccountNo VARCHAR(50),
	ClientName VARCHAR(150),
	RoutingNumber VARCHAR(9),
	AccountNumber VARCHAR(50),
	Amount VARCHAR(50),
	LawFirm VARCHAR(50),
	SettlementDate VARCHAR(50),
	BouncedDesription VARCHAR(50),
	BouncedDate VARCHAR(50))

	DECLARE c_Range CURSOR FOR 
	SELECT 
	RIGHT(LEFT(FileCreationDate, 4), 2) + ''/'' + RIGHT(FileCreationDate, 2) + ''/20'' + LEFT(FileCreationDate, 2),
	NOC1ID,
	CompanyName
	FROM tblNOC1 
	WHERE FileCreationDate BETWEEN @SearchableStartDate AND @SearchableEndDate

	OPEN c_Range

		FETCH NEXT FROM c_Range INTO @DateHolder, @NOC1ID, @LawFirm
		WHILE @@FETCH_STATUS = 0
		BEGIN

				--Begin selecting the individual data pieces
				DECLARE cur CURSOR FOR
				SELECT
				NOC5ID,
				CompanyName,
				SettlementDate
				FROM tblNOC5
				WHERE NOC1ID = @NOC1ID

				OPEN cur 

				FETCH NEXT FROM cur INTO @NOC5ID, @LawFirm, @SettlementDate
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @Amount = RIGHT(Amount, LEN(Amount)+1 - PATINDEX(''%[^0]%'', Amount)) 
					FROM tblNOC6 
					WHERE NOC5ID = @NOC5ID

					INSERT INTO @ReturnedItems
					SELECT
					c.ClientID,
					n6.IndividualIDNumber,
					c.AccountNumber,
					n6.IndividualName,
					n6.RoutingNumber,
					n6.AccountNumber,
					LEFT(RIGHT(n6.Amount, LEN(n6.Amount)+1 - PATINDEX(''%[^0]%'', n6.Amount)), LEN(n6.Amount)+1 - PATINDEX(''%[^0]%'', n6.Amount)-2) + ''.'' + RIGHT(n6.Amount, 2),
					@LawFirm,
					CASE WHEN @SettlementDate <> ''000'' THEN RIGHT(LEFT(@SettlementDate, 4), 2) + ''/'' + RIGHT(@SettlementDate, 2) + ''/20'' + LEFT(@SettlementDate, 2) ELSE '''' END,
					br.BouncedDescription,
					CASE WHEN r.Bounce IS NULL THEN r2.Bounce ELSE r.Bounce END
					FROM tblNOC6 n6
					LEFT JOIN [DMS].[dbo].[tblNACHARegister] nr ON nr.NachaRegisterID = n6.IndividualIDNumber
					LEFT JOIN [DMS].[dbo].[tblNACHARegister2] nr2 ON nr2.NachaRegisterID = n6.IndividualIDNumber
					LEFT JOIN [DMS].[dbo].[tblClient] c ON c.ClientID = nr.ClientID
					LEFT JOIN tblNOC7 n7 ON n7.NOC6ID = n6.NOC6ID
					LEFT JOIN [DMS].[dbo].[tblBouncedReasons] br ON br.BouncedCode = n7.ReturnReasonCode
					LEFT JOIN [DMS].[dbo].[tblRegister] r ON r.RegisterID = nr.RegisterID
					LEFT JOIN [DMS].[dbo].[tblRegister] r2 ON r2.registerID = nr2.RegisterID
					WHERE n6.NOC5ID = @NOC5ID
					AND n6.Amount <> ''0000000000''

				FETCH NEXT FROM cur INTO @NOC5ID, @LawFirm, @SettlementDate
				END

				CLOSE cur
				DEALLOCATE cur

		FETCH NEXT FROM c_Range INTO @DateHolder, @NOC1ID, @LawFirm
		END

		CLOSE c_Range
		DEALLOCATE c_Range

	SELECT * FROM @ReturnedItems ORDER BY SettlementDate, AccountNumber
END' 
END
GO
