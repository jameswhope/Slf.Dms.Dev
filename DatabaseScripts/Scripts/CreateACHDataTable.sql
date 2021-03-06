USE [ACHData]
GO
/****** Object:  StoredProcedure [dbo].[stp_CreateNACHATable]    Script Date: 05/30/2008 12:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 05/28/2008
-- Description:	Creates a NACHA table
-- =============================================

CREATE PROCEDURE [dbo].[stp_CreateNACHATable] 
	@TableName NVARCHAR(100),
	@SettlementAtty NVARCHAR(50) 
AS
BEGIN
	SET NOCOUNT ON;
	SET @TableName = @TableName + '_' + @SettlementAtty

	IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
	BEGIN
	DECLARE @SQL VARCHAR(2000)
	SET @SQL = 'IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = ''' + @TableName + ''')
	BEGIN
		CREATE TABLE [ACHData].[dbo].[' + @TableName + '] (
         [EntryDetailRecordID] [INT] IDENTITY(1,1) NOT NULL, 
         [NachaFileID] [INT] NOT NULL, 
         [BatchHeaderOrder] [INT] NOT NULL, 
         [RecordTypeCode] [NVARCHAR](1) NOT NULL, 
         [TransactionCode] [NVARCHAR](2) NOT NULL, 
         [ReceivingDFIIdentification] [NVARCHAR](8) NOT NULL, 
         [CheckDigit] [NVARCHAR](1) NOT NULL, 
         [DFIAccountNumber] [NVARCHAR](17) NOT NULL, 
         [Amount] [NVARCHAR](10) NOT NULL, 
         [IndividualIdentificationNumber] [NVARCHAR](15) NOT NULL, 
         [IndividualName] [NVARCHAR](22) NOT NULL, 
         [PaymentTypeCode] [NVARCHAR](2) NOT NULL, 
         [AddendaRecordIndicator] [NVARCHAR](1) NOT NULL, 
         [TraceNumber] [NVARCHAR](15) NOT NULL 
         ) ON [PRIMARY]
	END'
	EXEC(@SQL)
	END
END
