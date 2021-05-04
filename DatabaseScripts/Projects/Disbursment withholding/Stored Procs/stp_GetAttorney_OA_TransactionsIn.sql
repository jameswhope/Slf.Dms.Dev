IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAttorney_OA_TransactionsIn')
	BEGIN
		DROP  Procedure  Stored_Procedure_Name
	END

GO

-- =============================================
-- Author:		Jim Hope
-- Create date: 09/15/2011
-- Description:	Get funds going into Atty OA
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetAttorney_OA_TransactionsIn] 
	@sDate datetime = '09/20/2011',
	@eDate datetime = NULL
AS
	BEGIN
		SET NOCOUNT ON;
		--Begin Test**********
--		DECLARE @sDate DATETIME
--		DECLARE @eDate DATETIME
--		SET @sDate = '09/26/2011'
		--End Test************
		--Setup the dates for processing
		IF @sDate IS NULL
			BEGIN
				SET @sDate = CAST(CAST(GETDATE() AS VARCHAR(12)) + ' 12:00:01 AM' AS DATETIME)
			END
		ELSE
			BEGIN
				SET @sDate = CAST(CAST(@sDate AS VARCHAR(12)) + ' 12:00:01 AM' AS DATETIME)
			END
		IF @eDate IS NULL
			BEGIN
				SET @eDate = CAST(CAST(GETDATE() AS VARCHAR(12)) + ' 11:59:59 PM' AS DATETIME)
			END
		ELSE
			BEGIN
				SET @eDate = CAST(CAST(@eDate AS VARCHAR(12)) + ' 11:59:59 PM' AS DATETIME)
			END

		DECLARE @Accounts TABLE
		(
		[Name] varchar(150),
		OAAmount money,
		OAAccountNumber varchar(50)
		)

		INSERT INTO @Accounts

		SELECT [Name], Amount, AccountNumber  from tblNachaRegister2 nr2  
		where nr2.IsPersonal = 0 AND
		nr2.NachaFileId = -1 AND
		nr2.Flow = 'Debit' AND
		nr2.AccountNumber IN 
		(
			SELECT cr.AccountNumber 
			FROM tblcommrec cr 
			where cr.AccountNumber IS NOT NULL AND 
			cr.Display LIKE '%Operating%'
		) AND
		nr2.Created between cast(cast(@sDate AS varchar(12)) + '12:01AM' as DATETIME)
		AND cast(cast(@eDate AS varchar(12)) + '11:59AM' as datetime)

		INSERT INTO @Accounts

		SELECT [Name], Amount, AccountNumber  
		FROM tblNachaRegister nr  
		WHERE nr.IsPersonal = 0 AND
		nr.NachaFileId IS NULL AND
		nr.amount > 0 AND
		nr.AccountNumber IN 
		(
			SELECT cr.AccountNumber 
			FROM tblcommrec cr 
			WHERE cr.AccountNumber IS NOT NULL AND 
			cr.Display LIKE '%Operating%'
		) AND
		nr.Created between cast(cast(@sDate AS varchar(12)) + '12:01AM' as DATETIME)
		AND cast(cast(@eDate AS varchar(12)) + '11:59AM' as datetime)

		SELECT [Name], sum(OAAmount) as OAAmount, OAAccountNumber
		FROM @Accounts 
		GROUP BY OAAccountNumber, [Name]
	END

GO

/*
GRANT EXEC ON stp_GetAttorney_OA_TransactionsIn TO PUBLIC

GO
*/

