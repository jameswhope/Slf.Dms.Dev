/****** Object:  StoredProcedure [dbo].[stp_Tool_DeleteConstraintsForTableField]    Script Date: 11/19/2007 15:27:46 ******/
DROP PROCEDURE [dbo].[stp_Tool_DeleteConstraintsForTableField]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Tool_DeleteConstraintsForTableField]
	(@TableName varchar (255), @FieldName varchar (255)) AS


-- Retrieve a list of constraints and stuff into temp table #tblConstraint 

SELECT
	[Name] AS ConstraintName
INTO
	#tblConstraints
FROM
	sysobjects so
	JOIN sysconstraints sc ON so.id = sc.constid
WHERE
	object_name(so.parent_obj) = @TableName AND
	so.xtype IN ('C', 'F', 'PK', 'UQ', 'D') AND 
	sc.colid =
		(
			SELECT colid FROM syscolumns WHERE [ID] = object_id('dbo.' + @TableName) AND [Name] = @FieldName
		)


-- Loop through all constraint information in #tblConstraint and delete them

DECLARE @ConstraintName varchar (255)

DECLARE MCTCursor CURSOR FOR SELECT ConstraintName FROM #tblConstraints

OPEN MCTCursor

FETCH NEXT FROM MCTCursor INTO @ConstraintName
WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC ('ALTER TABLE [' + @TableName + '] DROP CONSTRAINT [' + @ConstraintName + ']')

	FETCH NEXT FROM MCTCursor INTO @ConstraintName
END

CLOSE MCTCursor
DEALLOCATE MCTCursor

DROP TABLE #tblConstraints
GO
