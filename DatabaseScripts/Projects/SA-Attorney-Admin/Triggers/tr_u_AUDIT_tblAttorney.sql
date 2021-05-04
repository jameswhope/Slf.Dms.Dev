/****** Object:  Trigger [dbo].[tr_u_AUDIT_tblAttorney]    Script Date: 07/07/2009 11:41:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tr_u_AUDIT_tblAttorney]
ON [dbo].[tblAttorney]
FOR UPDATE
NOT FOR REPLICATION
As

BEGIN
	DECLARE 
		@IDENTITY_SAVE			varchar(50),
		@AUDIT_LOG_TRANSACTION_ID	Int,
		@PRIM_KEY			nvarchar(4000),
		@Inserted	    		bit,
		--@TABLE_NAME				nvarchar(4000),
 		@ROWS_COUNT				int,
		@AuditID				int
 
	SET NOCOUNT ON

	--Set @TABLE_NAME = '[dbo].[tblAttorney]'
	Select @ROWS_COUNT=count(*) from inserted
	SET @IDENTITY_SAVE = CAST(IsNull(@@IDENTITY,1) AS varchar(50))
	SET @AuditID = (SELECT Audit_Type_ID FROM [DMS_WAREHOUSE].dbo.AUDIT_TYPE WHERE Audit_Type = 'UPDATE')

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
		1,	--	ACTION ID For UPDATE
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
	
	
	SET @Inserted = 0
	
	If UPDATE([AttorneyID])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'AttorneyID',
			CONVERT(nvarchar(4000), OLD.[AttorneyID], 0),
			CONVERT(nvarchar(4000), NEW.[AttorneyID], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Full Outer Join inserted NEW On
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			WHERE (
			
			
				(
					NEW.[AttorneyID] <>
					OLD.[AttorneyID]
				) Or
			
				(
					NEW.[AttorneyID] Is Null And
					OLD.[AttorneyID] Is Not Null
				) Or
				(
					NEW.[AttorneyID] Is Not Null And
					OLD.[AttorneyID] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([FirstName])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'FirstName',
			CONVERT(nvarchar(4000), OLD.[FirstName], 0),
			CONVERT(nvarchar(4000), NEW.[FirstName], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[FirstName] <>
					OLD.[FirstName]
				) Or
			
				(
					NEW.[FirstName] Is Null And
					OLD.[FirstName] Is Not Null
				) Or
				(
					NEW.[FirstName] Is Not Null And
					OLD.[FirstName] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([LastName])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'LastName',
			CONVERT(nvarchar(4000), OLD.[LastName], 0),
			CONVERT(nvarchar(4000), NEW.[LastName], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[LastName] <>
					OLD.[LastName]
				) Or
			
				(
					NEW.[LastName] Is Null And
					OLD.[LastName] Is Not Null
				) Or
				(
					NEW.[LastName] Is Not Null And
					OLD.[LastName] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([MiddleName])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'MiddleName',
			CONVERT(nvarchar(4000), OLD.[MiddleName], 0),
			CONVERT(nvarchar(4000), NEW.[MiddleName], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[MiddleName] <>
					OLD.[MiddleName]
				) Or
			
				(
					NEW.[MiddleName] Is Null And
					OLD.[MiddleName] Is Not Null
				) Or
				(
					NEW.[MiddleName] Is Not Null And
					OLD.[MiddleName] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Suffix])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Suffix',
			CONVERT(nvarchar(4000), OLD.[Suffix], 0),
			CONVERT(nvarchar(4000), NEW.[Suffix], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Suffix] <>
					OLD.[Suffix]
				) Or
			
				(
					NEW.[Suffix] Is Null And
					OLD.[Suffix] Is Not Null
				) Or
				(
					NEW.[Suffix] Is Not Null And
					OLD.[Suffix] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Address1])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Address1',
			CONVERT(nvarchar(4000), OLD.[Address1], 0),
			CONVERT(nvarchar(4000), NEW.[Address1], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Address1] <>
					OLD.[Address1]
				) Or
			
				(
					NEW.[Address1] Is Null And
					OLD.[Address1] Is Not Null
				) Or
				(
					NEW.[Address1] Is Not Null And
					OLD.[Address1] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Address2])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Address2',
			CONVERT(nvarchar(4000), OLD.[Address2], 0),
			CONVERT(nvarchar(4000), NEW.[Address2], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Address2] <>
					OLD.[Address2]
				) Or
			
				(
					NEW.[Address2] Is Null And
					OLD.[Address2] Is Not Null
				) Or
				(
					NEW.[Address2] Is Not Null And
					OLD.[Address2] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([City])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'City',
			CONVERT(nvarchar(4000), OLD.[City], 0),
			CONVERT(nvarchar(4000), NEW.[City], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[City] <>
					OLD.[City]
				) Or
			
				(
					NEW.[City] Is Null And
					OLD.[City] Is Not Null
				) Or
				(
					NEW.[City] Is Not Null And
					OLD.[City] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([State])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'State',
			CONVERT(nvarchar(4000), OLD.[State], 0),
			CONVERT(nvarchar(4000), NEW.[State], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[State] <>
					OLD.[State]
				) Or
			
				(
					NEW.[State] Is Null And
					OLD.[State] Is Not Null
				) Or
				(
					NEW.[State] Is Not Null And
					OLD.[State] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Zip])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Zip',
			CONVERT(nvarchar(4000), OLD.[Zip], 0),
			CONVERT(nvarchar(4000), NEW.[Zip], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Zip] <>
					OLD.[Zip]
				) Or
			
				(
					NEW.[Zip] Is Null And
					OLD.[Zip] Is Not Null
				) Or
				(
					NEW.[Zip] Is Not Null And
					OLD.[Zip] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Phone1])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Phone1',
			CONVERT(nvarchar(4000), OLD.[Phone1], 0),
			CONVERT(nvarchar(4000), NEW.[Phone1], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Phone1] <>
					OLD.[Phone1]
				) Or
			
				(
					NEW.[Phone1] Is Null And
					OLD.[Phone1] Is Not Null
				) Or
				(
					NEW.[Phone1] Is Not Null And
					OLD.[Phone1] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Phone2])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Phone2',
			CONVERT(nvarchar(4000), OLD.[Phone2], 0),
			CONVERT(nvarchar(4000), NEW.[Phone2], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Phone2] <>
					OLD.[Phone2]
				) Or
			
				(
					NEW.[Phone2] Is Null And
					OLD.[Phone2] Is Not Null
				) Or
				(
					NEW.[Phone2] Is Not Null And
					OLD.[Phone2] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Fax])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Fax',
			CONVERT(nvarchar(4000), OLD.[Fax], 0),
			CONVERT(nvarchar(4000), NEW.[Fax], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Fax] <>
					OLD.[Fax]
				) Or
			
				(
					NEW.[Fax] Is Null And
					OLD.[Fax] Is Not Null
				) Or
				(
					NEW.[Fax] Is Not Null And
					OLD.[Fax] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([UserID])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'UserID',
			CONVERT(nvarchar(4000), OLD.[UserID], 0),
			CONVERT(nvarchar(4000), NEW.[UserID], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[UserID] <>
					OLD.[UserID]
				) Or
			
				(
					NEW.[UserID] Is Null And
					OLD.[UserID] Is Not Null
				) Or
				(
					NEW.[UserID] Is Not Null And
					OLD.[UserID] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([Created])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'Created',
			CONVERT(nvarchar(4000), OLD.[Created], 121),
			CONVERT(nvarchar(4000), NEW.[Created], 121),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[Created] <>
					OLD.[Created]
				) Or
			
				(
					NEW.[Created] Is Null And
					OLD.[Created] Is Not Null
				) Or
				(
					NEW.[Created] Is Not Null And
					OLD.[Created] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([CreatedBy])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'CreatedBy',
			CONVERT(nvarchar(4000), OLD.[CreatedBy], 0),
			CONVERT(nvarchar(4000), NEW.[CreatedBy], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[CreatedBy] <>
					OLD.[CreatedBy]
				) Or
			
				(
					NEW.[CreatedBy] Is Null And
					OLD.[CreatedBy] Is Not Null
				) Or
				(
					NEW.[CreatedBy] Is Not Null And
					OLD.[CreatedBy] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([LastModified])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'LastModified',
			CONVERT(nvarchar(4000), OLD.[LastModified], 121),
			CONVERT(nvarchar(4000), NEW.[LastModified], 121),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[LastModified] <>
					OLD.[LastModified]
				) Or
			
				(
					NEW.[LastModified] Is Null And
					OLD.[LastModified] Is Not Null
				) Or
				(
					NEW.[LastModified] Is Not Null And
					OLD.[LastModified] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	If UPDATE([LastModifiedBy])
	BEGIN
    
		INSERT
		INTO [DMS_WAREHOUSE].dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			AUDIT_TYPE_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
			@AuditID,
		    convert(nvarchar(1500), IsNull('[AttorneyID]='+CONVERT(nvarchar(4000), IsNull(OLD.[AttorneyID], NEW.[AttorneyID]), 0), '[AttorneyID] Is Null')),
		    'LastModifiedBy',
			CONVERT(nvarchar(4000), OLD.[LastModifiedBy], 0),
			CONVERT(nvarchar(4000), NEW.[LastModifiedBy], 0),
			'A'
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.[AttorneyID], 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.[AttorneyID], 0)=CONVERT(nvarchar(4000), OLD.[AttorneyID], 0) or (NEW.[AttorneyID] Is Null and OLD.[AttorneyID] Is Null))
			where (
			
			
				(
					NEW.[LastModifiedBy] <>
					OLD.[LastModifiedBy]
				) Or
			
				(
					NEW.[LastModifiedBy] Is Null And
					OLD.[LastModifiedBy] Is Not Null
				) Or
				(
					NEW.[LastModifiedBy] Is Not Null And
					OLD.[LastModifiedBy] Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END
	
	-- Watch
	
	-- Lookup
	
	IF @Inserted = 0
	BEGIN
		DELETE FROM [DMS_WAREHOUSE].dbo.AUDIT_LOG_TRANSACTIONS WHERE AUDIT_LOG_TRANSACTION_ID = @AUDIT_LOG_TRANSACTION_ID
	END
	-- Restore @@IDENTITY Value  
    DECLARE @maxprec AS varchar(2)
    SET @maxprec=CAST(@@MAX_PRECISION as varchar(2))
    EXEC('SELECT IDENTITY(decimal('+@maxprec+',0),'+@IDENTITY_SAVE+',1) id INTO #tmp')
End


GO
EXEC sp_settriggerorder @triggername=N'[dbo].[tr_u_AUDIT_tblAttorney]', @order=N'Last', @stmttype=N'UPDATE' 