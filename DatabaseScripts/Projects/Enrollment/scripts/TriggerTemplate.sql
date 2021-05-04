IF EXISTS (SELECT * FROM sysobjects WHERE name='tr_AuditTrig' AND xtype ='TR')
	BEGIN
		DROP TRIGGER tr_AuditTrig
	END
GO
--You will need to add the table name you wish to audit
CREATE TRIGGER tr_AuditTrig ON <Add_TableNameHere> FOR INSERT, UPDATE, DELETE
AS

DECLARE @bit INT ,      
@field INT ,       
@maxfield INT ,       
@char INT ,       
@fieldname VARCHAR(128) ,      
@TableName VARCHAR(128) ,       
@PKCols VARCHAR(1000) ,       
@sql VARCHAR(2000),        
@UpdateDate VARCHAR(21) ,       
@UserName VARCHAR(128) ,       
@Type CHAR(1) ,       
@PKSelect VARCHAR(1000),
@PK VARCHAR(50)       

--You will need to change @TableName to match the table above
SELECT @TableName = '<Add_TableNameHere>'
-- date and user
SELECT         @UserName = SYSTEM_USER ,       
@UpdateDate = CONVERT(VARCHAR(8), GETDATE(), 112)                
+ ' ' + CONVERT(VARCHAR(12), GETDATE(), 114)
-- Action
IF EXISTS (SELECT * FROM inserted)       
	IF EXISTS (SELECT * FROM deleted)               
		SELECT @Type = 'U'       
	ELSE               
	SELECT @Type = 'I'
ELSE       
	SELECT @Type = 'D'
-- get list of columns
SELECT * INTO #ins FROM inserted
SELECT * INTO #del FROM deleted
-- Get primary key columns for full outer join
SELECT @PKCols = COALESCE(@PKCols + ' and', ' on')
                + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME
       FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk , 
                    INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
       WHERE   pk.TABLE_NAME = @TableName
       AND     CONSTRAINT_TYPE = 'PRIMARY KEY'
       AND     c.TABLE_NAME = pk.TABLE_NAME
       AND     c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
-- Get primary key select for insert
SELECT @PKSelect = convert(varchar(100), COLUMN_NAME)
        FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
               INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
       WHERE   pk.TABLE_NAME = @TableName
       AND     CONSTRAINT_TYPE = 'PRIMARY KEY'
       AND     c.TABLE_NAME = pk.TABLE_NAME
       AND     c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
IF @PKCols IS NULL
	BEGIN
       RAISERROR('no PK on table %s', 16, -1, @TableName)
       RETURN
END
SELECT         @field = 0,
        @maxfield = MAX(ORDINAL_POSITION)
        FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = @TableName
WHILE @field < @maxfield
BEGIN
       SELECT @field = MIN(ORDINAL_POSITION)
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_NAME = @TableName
                AND ORDINAL_POSITION > @field
       SELECT @bit = (@field - 1 )% 8 + 1
       SELECT @bit = POWER(2,@bit - 1)
       SELECT @char = ((@field - 1) / 8) + 1
       IF SUBSTRING(COLUMNS_UPDATED(),@char, 1) & @bit > 0
                                       OR @Type IN ('I','D')
       BEGIN
               SELECT @fieldname = COLUMN_NAME
                        FROM INFORMATION_SCHEMA.COLUMNS
                        WHERE TABLE_NAME = @TableName
                        AND ORDINAL_POSITION = @field
               SELECT @sql = '
insert tblLeadAudit (
				UserName,                
				TableName, 
                FieldName,
				ModificationType,
                OldValue,
                NewValue,
                ModificationDate,
				TableIDValue)
				select ''' + @UserName + ''','''        
				+ @TableName + ''','''
				+ @FieldName + ''','''
				+ @Type + ''','
				+ 'convert(varchar(1000),d.' + @fieldname + ')'
				+ ',convert(varchar(1000),i.' + @fieldname + ')' + ','''
				+ @UpdateDate + '''' + ','    
				+ 'convert(varchar(1000),i.' + @PKSelect +  ')' + ''
				+ ' from #ins i full outer join #del d '       
				+ @PKCols       
				+ ' where i.' + @fieldname + ' <> d.' + @fieldname        
				+ ' or (i.' + @fieldname + ' is null and  d.' 
								+ @fieldname 
								+ ' is not null)'        
				+ ' or (i.' + @fieldname + ' is not null and  d.' 
								+ @fieldname 
								+ ' is null)' 
                EXEC (@sql)       
		END
END
