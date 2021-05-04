/****** Object:  Trigger [dbo].[tr_d_AUDIT_tblAttorney]    Script Date: 07/07/2009 11:44:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tr_d_AUDIT_tblAttorney]
ON [dbo].[tblAttorney]
FOR DELETE
NOT FOR REPLICATION
AS

BEGIN
	DECLARE 
		@IDENTITY_SAVE				varchar(50),
		@AUDIT_LOG_TRANSACTION_ID		Int,
		@PRIM_KEY				nvarchar(4000),
		--@TABLE_NAME				nvarchar(4000),
 		@ROWS_COUNT				int,
		@AuditID					int
 
	SET NOCOUNT ON

	--Set @TABLE_NAME = '[dbo].[tblAttorney]'
	Select @ROWS_COUNT=count(*) from deleted
	Set @IDENTITY_SAVE = CAST(IsNull(@@IDENTITY,1) AS varchar(50))
	SET @AuditID = (SELECT Audit_Type_ID FROM [DMS_WAREHOUSE].dbo.AUDIT_TYPE WHERE Audit_Type = 'DELETE')

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_TRANSACTIONS
	(
		TABLE_NAME,
		TABLE_SCHEMA,
		AUDIT_ACTION_ID,
		HOST_NAME,
		APP_NAME,
		MODIFIED_BY,
		MODIFIED_DATE,
		AFFECTED_ROWS,
		[DATABASE]
	)
	values(
		'tblAttorney',
		'dbo',
		3,	--	ACTION ID For DELETE
		CASE 
		  WHEN LEN(HOST_NAME()) < 1 THEN ' '
		  ELSE HOST_NAME()
		END,
		CASE 
		  WHEN LEN(APP_NAME()) < 1 THEN ' '
		  ELSE APP_NAME()
		END,
		SUSER_SNAME(),
		GETDATE(),
		@ROWS_COUNT,
		'DMS'
	)

	
	Set @AUDIT_LOG_TRANSACTION_ID = SCOPE_IDENTITY()
	


	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'AttorneyID',
		CONVERT(nvarchar(4000), OLD.[AttorneyID], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[AttorneyID] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'FirstName',
		CONVERT(nvarchar(4000), OLD.[FirstName], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[FirstName] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'LastName',
		CONVERT(nvarchar(4000), OLD.[LastName], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[LastName] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'MiddleName',
		CONVERT(nvarchar(4000), OLD.[MiddleName], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[MiddleName] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Suffix',
		CONVERT(nvarchar(4000), OLD.[Suffix], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Suffix] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Address1',
		CONVERT(nvarchar(4000), OLD.[Address1], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Address1] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Address2',
		CONVERT(nvarchar(4000), OLD.[Address2], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Address2] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'City',
		CONVERT(nvarchar(4000), OLD.[City], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[City] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'State',
		CONVERT(nvarchar(4000), OLD.[State], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[State] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Zip',
		CONVERT(nvarchar(4000), OLD.[Zip], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Zip] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Phone1',
		CONVERT(nvarchar(4000), OLD.[Phone1], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Phone1] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Phone2',
		CONVERT(nvarchar(4000), OLD.[Phone2], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Phone2] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Fax',
		CONVERT(nvarchar(4000), OLD.[Fax], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Fax] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'UserID',
		CONVERT(nvarchar(4000), OLD.[UserID], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[UserID] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Created',
		CONVERT(nvarchar(4000), OLD.[Created], 121),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[Created] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'CreatedBy',
		CONVERT(nvarchar(4000), OLD.[CreatedBy], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[CreatedBy] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'LastModified',
		CONVERT(nvarchar(4000), OLD.[LastModified], 121),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[LastModified] Is Not Null

	INSERT
	INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), OLD.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'LastModifiedBy',
		CONVERT(nvarchar(4000), OLD.[LastModifiedBy], 0),
		'A'
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0))
	FROM deleted OLD
	WHERE
		OLD.[LastModifiedBy] Is Not Null

	-- Lookup
	
	
	-- Restore @@IDENTITY Value
	DECLARE @maxprec AS varchar(2)
	SET @maxprec=CAST(@@MAX_PRECISION as varchar(2))
	EXEC('SELECT IDENTITY(decimal('+@maxprec+',0),'+@IDENTITY_SAVE+',1) id INTO #tmp')
END

GO
EXEC sp_settriggerorder @triggername=N'[dbo].[tr_d_AUDIT_tblAttorney]', @order=N'Last', @stmttype=N'DELETE' 