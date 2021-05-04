/****** Object:  Trigger [dbo].[tr_i_AUDIT_tblAttorney]    Script Date: 07/07/2009 11:43:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tr_i_AUDIT_tblAttorney]
ON [dbo].[tblAttorney]
FOR INSERT
NOT FOR REPLICATION
As

BEGIN
	DECLARE 
		@IDENTITY_SAVE				varchar(50),
		@AUDIT_LOG_TRANSACTION_ID		Int,
		@PRIM_KEY				nvarchar(4000),
		--@TABLE_NAME				nvarchar(4000),
		@ROWS_COUNT				int,
		@AuditID				int
 
	SET NOCOUNT ON

	--Set @TABLE_NAME = '[dbo].[tblAttorney]'
	Select @ROWS_COUNT=count(*) from inserted
	Set @IDENTITY_SAVE = CAST(IsNull(@@IDENTITY,1) AS varchar(50))
	SET @AuditID = (SELECT Audit_Type_ID FROM [DMS_WAREHOUSE].dbo.AUDIT_TYPE WHERE Audit_Type = 'INSERT')

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
		2,	--	ACTION ID For INSERT
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
	

	
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'AttorneyID',
		CONVERT(nvarchar(4000), NEW.[AttorneyID], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[AttorneyID] Is Not Null
       
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'FirstName',
		CONVERT(nvarchar(4000), NEW.[FirstName], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[FirstName] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'LastName',
		CONVERT(nvarchar(4000), NEW.[LastName], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[LastName] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'MiddleName',
		CONVERT(nvarchar(4000), NEW.[MiddleName], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[MiddleName] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Suffix',
		CONVERT(nvarchar(4000), NEW.[Suffix], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Suffix] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Address1',
		CONVERT(nvarchar(4000), NEW.[Address1], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Address1] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Address2',
		CONVERT(nvarchar(4000), NEW.[Address2], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Address2] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'City',
		CONVERT(nvarchar(4000), NEW.[City], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[City] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'State',
		CONVERT(nvarchar(4000), NEW.[State], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[State] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Zip',
		CONVERT(nvarchar(4000), NEW.[Zip], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Zip] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Phone1',
		CONVERT(nvarchar(4000), NEW.[Phone1], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Phone1] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Phone2',
		CONVERT(nvarchar(4000), NEW.[Phone2], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Phone2] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Fax',
		CONVERT(nvarchar(4000), NEW.[Fax], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Fax] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'UserID',
		CONVERT(nvarchar(4000), NEW.[UserID], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[UserID] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'Created',
		CONVERT(nvarchar(4000), NEW.[Created], 121),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[Created] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'CreatedBy',
		CONVERT(nvarchar(4000), NEW.[CreatedBy], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[CreatedBy] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'LastModified',
		CONVERT(nvarchar(4000), NEW.[LastModified], 121),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[LastModified] Is Not Null
    
	INSERT INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		AUDIT_TYPE_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		@AuditID,
		convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), NEW.[AttorneyID], 0), '[AttorneyID] Is Null')),
		'LastModifiedBy',
		CONVERT(nvarchar(4000), NEW.[LastModifiedBy], 0),
		'A'
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0))
	FROM inserted NEW
	WHERE NEW.[LastModifiedBy] Is Not Null
    
	
	-- Lookup 
	

	-- Restore @@IDENTITY Value 
    DECLARE @maxprec AS varchar(2)
    SET @maxprec=CAST(@@MAX_PRECISION as varchar(2))
    EXEC('SELECT IDENTITY(decimal('+@maxprec+',0),'+@IDENTITY_SAVE+',1) id INTO #tmp')
	
End


GO
EXEC sp_settriggerorder @triggername=N'[dbo].[tr_i_AUDIT_tblAttorney]', @order=N'Last', @stmttype=N'INSERT' 