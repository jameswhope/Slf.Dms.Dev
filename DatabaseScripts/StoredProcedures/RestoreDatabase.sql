SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Restore a copy of Live to 8_29
-- Create date: 05/05/2008
-- Description:	Nightly restore of DB to run tests against
-- =============================================
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAndRestoreLive')
	DROP PROCEDURE [dbo].[stp_GetAndRestoreLive]
GO

CREATE PROCEDURE stp_GetAndRestoreLive
	--Backup from date default is null and is today.
	--If used format is yyyymmdd0025 
	@BUFromDate VARCHAR(8) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @BUDate VARCHAR(12)
	DECLARE @BUYear VARCHAR(4)
	DECLARE @BUMonth VARCHAR(2)
	DECLARE @BUDay VARCHAR(2)

	--Populate each variable with a value to assign the backup date if @BUFromDate is null
	IF @BUFromDate IS NULL
		BEGIN
			SET @BUYear = '' + DATEPART(YEAR, GETDATE()) + ''
 
			SET @BUMonth = '' + DATEPART(MONTH, GETDATE()) + ''
				IF LEN(@BUMonth) = 1
					BEGIN
						SET @BUMonth = '0' + @BUMonth
					END

			SET @BUDay = '' + DATEPART(DAY, GETDATE()) + ''
				IF LEN(@BUDay) = 1
					BEGIN
						SET @BUDay = '0' + @BUDay
					END

			SET @BUDate = @BUYear + @BUMonth + @BUDay + '0025'
	END

		--If @BUFrom is not null then assign the backup set name here
		IF @BUFromDate IS NOT NULL
			BEGIN
				SET @BUDate = @BUFromDate
			END

	--Setup the filename of the backup set
	DECLARE	@filename1 VARCHAR(255) 
	SET	@filename1 = N'\\NAS01\LEXSRVSQLPROD_BACKUPS\DMS\DMS_db_' + @BUDate + '.BAK'
	
	--Does the database exist already, if so, detach it or drop it.
	IF EXISTS (SELECT name FROM master.sys.databases sd WHERE name = 'NightlyTest')
		BEGIN
			EXEC master.dbo.sp_detach_db @dbname = 'NightlyTest'
		END

	--Restore the live database to DMS_RESTORED in the Data folder of SQL
	EXEC master.dbo.xp_restore_database @database = N'DMS_RESTORED', 
	@filename = @filename1, 
	@filenumber = 1, 
	@with = N'RECOVERY', 
	@with = N'NOUNLOAD', 
	@with = N'STATS = 10', 
	@with = N'MOVE ''slf_dms_Data'' TO ''C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\DMS_RESTORED_Data.mdf''', 
	@with = N'MOVE ''slf_dms_Log'' TO ''C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\DMS_RESTORED_Log.ldf'''
	
	--Now attach the restored database to the server
	EXEC master.dbo.sp_attach_db @dbname = N'NightlyTest',
	@filename1 = N'''C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\DMS_RESTORED_Data.mdf''',
	@filename2 = N'''C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\DMS_RESTORED_Log.ldf'''
	
	--Remove replication objects from the subscription database
--	DECLARE @subscriptionDB AS sysname
--	SET @subscriptionDB = N'NightlyTest'
--	EXEC sp_removereplication @subscriptionDB
	
END
GO
