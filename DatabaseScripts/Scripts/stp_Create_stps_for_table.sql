 /*-- =======================================================================================
-- Author      : Jim Hope
-- Create date : July 23 2009  9:06AM
-- Description : Generate the Insert / Update/ Delete Stored procedure script of any table  
--				 by passing the table name
	Exec [dbo].[stp_create_stps_for_table] 'Table Name'

-- ========================================================================================= */
CREATE PROCEDURE [dbo].[stp_create_stps_for_table]
	@tblName Varchar(50) 
AS
BEGIN
	Declare @dbName Varchar(50) 
	Declare @insertSPName Varchar(50), @updateSPName Varchar(50), @deleteSPName Varchar(50) ;
	Declare @tablColumnParameters Varchar(1000), @tableColumns Varchar(1000),@tableColumnVariables   Varchar(1000);
	Declare @tableCols	    Varchar(1000);
	Declare @space			Varchar(50)  ;
	Declare @colName 		Varchar(100) ;
	Declare @colVariable	Varchar(100) ;
	Declare @colParameter	Varchar(100) ;
	Declare @strSpText		Varchar(8000);
	Declare @updCols		Varchar(2000);
	Declare @delParamCols	Varchar(2000);
	Declare @whereCols		Varchar(2000);
	Set		@tblName		   =  SubString(@tblName,CharIndex('.',@tblName)+1, Len(@tblName))
	Set		@insertSPName      = '[dbo].[sp_' + lower(@tblName) +'_insert]'  ;
	Set		@updateSPName      = '[dbo].[sp_' + lower(@tblName) +'_update]'  ;
	Set		@deleteSPName      = '[dbo].[sp_' + lower(@tblName) +'_delete]'  ;
	Set		@space				  = REPLICATE(' ', 4)  ;
	Set		@tablColumnParameters = '' ;
	Set		@tableColumns		  = '' ;
	Set		@tableColumnVariables = '' ;
	Set		@strSPText			  = '' ;
	Set		@tableCols			  = '' ;
	Set		@updCols			  = '' ;
	Set		@delParamCols		  = '' ;
	Set		@whereCols			  = '' ;
	SET NOCOUNT ON 
	-- Get all columns & data types for a table 
	SELECT distinct
			sysobjects.name as 'Table', 
			syscolumns.colid ,
			'[' + syscolumns.name + ']' as 'ColumnName',
			'@'+syscolumns.name  as 'ColumnVariable',
			systypes.name + 
	Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + Convert(varchar(10),syscolumns.length) +')' Else '' end as 'DataType' ,
			'@'+syscolumns.name  + '  ' + systypes.name + 
	Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + Convert(varchar(10),syscolumns.length) +')' Else '' end as 'ColumnParameter'
	Into	#tmp_Structure	
	From	sysobjects , syscolumns ,  systypes
	Where	sysobjects.id			 = syscolumns.id
			and syscolumns.xusertype = systypes.xusertype
			and sysobjects.xtype	 = 'u'
			and sysobjects.name		 = @tblName
	Order by syscolumns.colid
	-- Get all Primary KEY columns & data types for a table 
	SELECT		t.name as 'Table', 
				c.colid ,
				'[' + c.name + ']' as 'ColumnName',
				'@'+c.name  as 'ColumnVariable',
				systypes.name + 
		Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + Convert(varchar(10),c.length) +')' Else '' end as 'DataType' ,
				'@'+c.name  + '  ' + systypes.name + 
		Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + Convert(varchar(10),c.length) +')' Else '' end as 'ColumnParameter'
	Into	#tmp_PK_Structure	
	FROM    sysindexes i, sysobjects t, sysindexkeys k, syscolumns c, systypes
	WHERE	i.id = t.id	 AND
			i.indid = k.indid  AND i.id = k.ID And
			c.id = t.id    AND c.colid = k.colid AND  
			i.indid BETWEEN 1 And 254  AND 
			c.xusertype = systypes.xusertype AND
			(i.status & 2048) = 2048 AND t.id = OBJECT_ID(@tblName)

	/* Read the table structure and populate variables*/
	Declare SpText_Cursor Cursor For
		Select ColumnName, ColumnVariable, ColumnParameter
		From #tmp_Structure 

	Open SpText_Cursor

	Fetch Next From SpText_Cursor Into @colName,  @colVariable, @colParameter
	While @@FETCH_STATUS = 0
	Begin
		Set @tableColumns			= @tableColumns + @colName + CHAR(13) + @space + @space + ',' ; 		
		Set @tablColumnParameters   = @tablColumnParameters + @colParameter + CHAR(13) + @space + ',' ; 
		Set @tableColumnVariables   = @tableColumnVariables + @colVariable + CHAR(13) + @space + @space + ',' ; 
		Set @tableCols				= @tableCols + @colName +  ',' ; 		
		Set @updCols				= @updCols + @colName + ' = ' + @colVariable + CHAR(13) + @space + @space + ',' ; 
	    Fetch Next From SpText_Cursor Into @colName,  @colVariable, @colParameter 
	End

	Close SpText_Cursor
	Deallocate SpText_Cursor

	/* Read the Primary Keys from the table and populate variables*/
	Declare SpPKText_Cursor Cursor For
		Select ColumnName, ColumnVariable, ColumnParameter
		From #tmp_PK_Structure 

	Open SpPKText_Cursor

	Fetch Next From SpPKText_Cursor Into @colName,  @colVariable, @colParameter
	While @@FETCH_STATUS = 0
	Begin
		Set @delParamCols   = @delParamCols + @colParameter + CHAR(13) + @space + ',' ; 
		Set @whereCols		= @whereCols + @colName + ' = ' + @colVariable + ' AND '  ; 
	    Fetch Next From SpPKText_Cursor Into @colName,  @colVariable, @colParameter 
	End

	Close SpPKText_Cursor
	Deallocate SpPKText_Cursor

	-- Stored procedure scripts starts here
	If (LEN(@tablColumnParameters)>0)
	Begin 
		Set @tablColumnParameters	= LEFT(@tablColumnParameters,LEN(@tablColumnParameters)-1) ;
		Set @tableColumnVariables	= LEFT(@tableColumnVariables,LEN(@tableColumnVariables)-1) ;
		Set @tableColumns			= LEFT(@tableColumns,LEN(@tableColumns)-1) ;
		Set @tableCols				= LEFT(@tableCols,LEN(@tableCols)-1) ;
		Set @updCols				= LEFT(@updCols,LEN(@updCols)-1) ;

		If (LEN(@whereCols)>0)
		Begin 
			Set @whereCols			= 'WHERE ' + LEFT(@whereCols,LEN(@whereCols)-4) ;
			Set @delParamCols		= LEFT(@delParamCols,LEN(@delParamCols)-1) ;
		End

		/*  Create INSERT stored procedure for the table if it does not exist */
		IF  Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(@insertSPName) AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
		Begin
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + '/*-- ============================================='
			Set @strSPText = @strSPText +  CHAR(13) + '-- Author      : dbo'
			Set @strSPText = @strSPText +  CHAR(13) + '-- Create date : ' + Convert(varchar(20),Getdate())
			Set @strSPText = @strSPText +  CHAR(13) + '-- Description : Insert Procedure for ' + @tblName
			Set @strSPText = @strSPText +  CHAR(13) + '-- Exec ' + @insertSPName + ' ' + @tableCols
			Set @strSPText = @strSPText +  CHAR(13) + '-- ============================================= */'
			Set @strSPText = @strSPText +  CHAR(13) + 'CREATE PROCEDURE ' + @insertSPName
			Set @strSPText = @strSPText +  CHAR(13) + @space + ' ' + @tablColumnParameters
			Set @strSPText = @strSPText +  CHAR(13) + 'AS'
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'INSERT INTO [dbo].['+@tblName +']' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + '( ' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + @space + ' ' + @tableColumns  
			Set @strSPText = @strSPText +  CHAR(13) + @space + ')'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'VALUES'
			Set @strSPText = @strSPText +  CHAR(13) + @space + '('
			Set @strSPText = @strSPText +  CHAR(13) + @space + @space + ' ' + @tableColumnVariables
			Set @strSPText = @strSPText +  CHAR(13) + @space + ')'
			Set @strSPText = @strSPText +  CHAR(13) + 'END'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			--Print @strSPText ;
			Exec(@strSPText);

			if (@@ERROR=0) 
				Print 'Procedure ' + @insertSPName + ' Created Successfully '
		End
		Else
		Begin
			Print 'Sorry!!  ' + @insertSPName + ' Already exists in the database. '
		End
		/*  Create UPDATE stored procedure for the table if it does not exist */
		IF  Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(@updateSPName) AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
		Begin
			Set @strSPText = ''
			Set @strSPText = @strSPText +  CHAR(13) + '/*-- ============================================='
			Set @strSPText = @strSPText +  CHAR(13) + '-- Author      : dbo'
			Set @strSPText = @strSPText +  CHAR(13) + '-- Create date : ' + Convert(varchar(20),Getdate())
			Set @strSPText = @strSPText +  CHAR(13) + '-- Description : Update Procedure for ' + @tblName
			Set @strSPText = @strSPText +  CHAR(13) + '-- Exec ' + @updateSPName + ' ' + @tableCols
			Set @strSPText = @strSPText +  CHAR(13) + '-- ============================================= */'
			Set @strSPText = @strSPText +  CHAR(13) + 'CREATE PROCEDURE ' + @updateSPName
			Set @strSPText = @strSPText +  CHAR(13) + @space + ' ' + @tablColumnParameters
			Set @strSPText = @strSPText +  CHAR(13) + 'AS'
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'UPDATE [dbo].['+@tblName +']' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'SET ' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + @space + ' ' + @updCols  
			Set @strSPText = @strSPText +  CHAR(13) + @space + @whereCols
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			--Print @strSPText ;
			Exec(@strSPText);

			if (@@ERROR=0) 
				Print 'Procedure ' + @updateSPName + ' Created Successfully '
		End
		Else
		Begin
			Print 'Sorry!!  ' + @updateSPName + ' Already exists in the database. '
		End
		/*  Create DELETE stored procedure for the table if it does not exist */
		IF  Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(@deleteSPName) AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
		Begin
			Set @strSPText = ''
			Set @strSPText = @strSPText +  CHAR(13) + '/*-- ============================================='
			Set @strSPText = @strSPText +  CHAR(13) + '-- Author      : dbo'
			Set @strSPText = @strSPText +  CHAR(13) + '-- Create date : ' + Convert(varchar(20),Getdate())
			Set @strSPText = @strSPText +  CHAR(13) + '-- Description : Delete Procedure for ' + @tblName
			Set @strSPText = @strSPText +  CHAR(13) + '-- Exec ' + @deleteSPName + ' ' + @delParamCols
			Set @strSPText = @strSPText +  CHAR(13) + '-- ============================================= */'
			Set @strSPText = @strSPText +  CHAR(13) + 'CREATE PROCEDURE ' + @deleteSPName
			Set @strSPText = @strSPText +  CHAR(13) + @space + ' ' + @delParamCols
			Set @strSPText = @strSPText +  CHAR(13) + 'AS'
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'DELETE FROM [dbo].['+@tblName +']' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + @whereCols
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			--Print @strSPText ;
			Exec(@strSPText);

			if (@@ERROR=0) 
				Print 'Procedure ' + @deleteSPName + ' Created Successfully '
		End
		Else
		Begin
			Print 'Sorry!!  ' + @deleteSPName + ' Already exists in the database. '
		End
	End
	Drop table #tmp_Structure
	Drop table #tmp_PK_Structure
END