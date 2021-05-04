IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = '[dbo].[stp_CheckRegisterForWells]')
	BEGIN
		DROP  Procedure  [dbo].[stp_CheckRegisterForWells]
	END

GO

CREATE Procedure [dbo].[stp_CheckRegisterForWells]
USE [DMS]
GO
/****** Object:  StoredProcedure [dbo].[stp_CheckRegisterForWells]    Script Date: 02/07/2014 09:19:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 09/11/2013
-- Description:	Check Register for Wells Fargo
-- Flags DR = Detail Record, FHR = File Header Records, TR = Trailer Record
-- =============================================
CREATE PROCEDURE [dbo].[stp_CheckRegisterForWells] 
    @Type varchar(3),
  	@Start datetime = '01/01/1900', 
	@End datetime = '01/01/1900'
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @AccountNumber VARCHAR(15)
DECLARE @RecordCount INT
DECLARE @TotalAmount NUMERIC(12,2)
DECLARE @FTotalAmount INT
SELECT @AccountNumber = f.DisbAccountNo FROM tblFTP f WHERE f.BankID = 3
	--Testing stuff
		--DECLARE @Start DATETIME
		--DECLARE @End DATETIME
		--DECLARE @Type VARCHAR(3)
		--SET @Start = '12/14/2013 12:01 AM' --cast(getdate() AS VARCHAR(12)) + ' 12:01 AM'
		--SET @End = cast(getdate() AS VARCHAR(12)) + ' 11:59 PM'
		--SET @Type = 'DR'
	--End of testing stuff
	
IF @Start = '01/01/1900'
	BEGIN
		SET @Start = cast(getdate() AS VARCHAR(12)) + ' 12:01 AM'
	END
ELSE
	BEGIN
		SET @Start = cast(@Start AS VARCHAR(12)) + ' 12:01 AM'
	END 
IF @End = '01/01/1900'
	BEGIN
		SET @End = cast(getdate() AS VARCHAR(12)) + ' 11:59 PM'
	END
ELSE
	BEGIN
		SET @End = cast(@End AS VARCHAR(12)) + ' 11:59 PM'
	END

--Detail
IF @Type = 'DR'
	BEGIN
		SELECT 
		--Check number
		cast(dbo.udf_GetPaddedString(10, 'L', '0', r.checknumber) AS CHAR(10)) 
		--Issue Date
		+ cast(dbo.udf_GetPaddedString(2, 'L', 0, datepart(month, r.Created)) as CHAR(2)) 
		+ cast(dbo.udf_GetPaddedString(2, 'L', 0, datepart(day, r.Created)) as CHAR(2)) 
		+ cast(dbo.udf_GetPaddedString(2, 'L', 0, RIGHT(cast(datepart(year, r.Created) AS VARCHAR(12)), 2)) AS CHAR(2))
		--Account Number
		+ cast(dbo.udf_GetPaddedString(15, 'L', 0, @accountnumber) AS CHAR(15))
		--Transaction Code
		+ '320'
		--Amount
		+ cast(dbo.udf_GetPaddedString(10, 'L', '0', cast((SELECT replace(r.Amount * -1, '.', '')) AS CHAR(10))) AS CHAR(10))
		--Addl data Payee
		+ CASE WHEN c.[Name] IS NULL THEN cast(dbo.udf_GetPaddedString(120, 'R', ' ', p.FirstName + ' ' + p.lastname) AS CHAR(120)) ELSE cast(dbo.udf_GetPaddedString(120, 'R', ' ', c.name) AS CHAR(120)) END
		--Unused should be spaces
		+ cast(dbo.udf_GetPaddedString(60, 'L', ' ', '                                                              ') AS CHAR(60)) 
		FROM tblRegister r
		JOIN tblPerson p ON p.ClientID = r.ClientId AND p.Relationship = 'prime'
		LEFT JOIN tblAccount a ON a.AccountID = r.AccountID
		LEFT JOIN tblCreditorInstance ci ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID
		LEFT JOIN tblCreditor c ON c.CreditorID = ci.CreditorID 
		WHERE 1 = 1
		AND r.EntryTypeId IN (18, 21, 28, 48) 
		AND r.Created BETWEEN @Start AND @End
		AND r.Amount < 0
		AND r.Void IS NULL 
		AND r.CheckNumber IS NOT NULL 
		AND r.[Clear] IS NULL 
		--AND r.Description IS NOT NULL 
		AND cast(dbo.udf_GetPaddedString(10, 'L', '0', rtrim(r.checknumber)) AS CHAR(10)) <> '0000000000'
	END
IF @Type = 'FHR'
	BEGIN
		--*03
		SELECT cast(dbo.udf_GetPaddedString(3, 'L', 0, '*03') AS CHAR(3))
		--Bank ID
		+ cast(dbo.udf_GetPaddedString(5, 'L', 0, '00182') AS CHAR(5))
		--Account Number
		+ cast(dbo.udf_GetPaddedString(15, 'L', 0, '4976699728') AS CHAR(15))
		--File Status
		+ cast(dbo.udf_GetPaddedString(1, 'L', ' ', '0') AS CHAR(1))
		--Unused should be spaces
		+ cast(dbo.udf_GetPaddedString(60, 'L', ' ', '                                                              ') AS CHAR(60))
	END
IF @Type = 'TR'
	BEGIN
		-- Get the totals
		SELECT @RecordCount = count(*) 
		, @TotalAmount = sum(r.Amount * -1)
		FROM tblRegister r
		WHERE 1 = 1
		AND r.EntryTypeId IN (18, 21, 28, 48) 
		AND r.Created BETWEEN @Start AND @End
		AND r.Amount < 0
		SET @FTotalAmount = replace(@TotalAmount, '.', '')
		--&
		SELECT '&' --cast(dbo.udf_GetPaddedString(3, 'L', 0, '&') AS CHAR(1))
		--14 Spaces
		+ cast(dbo.udf_GetPaddedString(14, 'L', ' ', '              ') AS CHAR(14))
		--Detail Record count
		+ cast(dbo.udf_GetPaddedString(7, 'L', 0, @RecordCount) AS CHAR(7))
		--3 Spaces
		+ cast(dbo.udf_GetPaddedString(3, 'L', ' ', '   ') AS CHAR(3))
		--Total Amount
		+ cast(dbo.udf_GetPaddedString(13, 'L', '0', @FTotalAmount) AS CHAR(13))
		--Unused should be spaces
		+ space(60) --cast(dbo.udf_GetPaddedString(60, 'L', ' ', '                                                              ') AS CHAR(60))
	END
END

