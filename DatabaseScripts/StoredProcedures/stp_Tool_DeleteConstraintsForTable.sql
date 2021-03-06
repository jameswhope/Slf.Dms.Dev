/****** Object:  StoredProcedure [dbo].[stp_Tool_DeleteConstraintsForTable]    Script Date: 11/19/2007 15:27:46 ******/
DROP PROCEDURE [dbo].[stp_Tool_DeleteConstraintsForTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Tool_DeleteConstraintsForTable]
	(@TableName varchar (255))

AS


-- Retrieve a list of constraints for @TableName and stuff into temp table

SELECT
	tblAllConstraints.ConstraintName,
	tblAllConstraints.TableName
INTO
	#tblConstraints
FROM
	(
		SELECT
			Name AS ConstraintName,
			(Select Name From sysobjects Where ID = s.parent_obj) AS TableName
		FROM
			sysobjects s
		WHERE
			xtype in ('C', 'F', 'PK', 'UQ', 'D')
	)
	AS tblAllConstraints
WHERE
	tblAllConstraints.TableName = @TableName


-- Loop through all constraint information in #tblConstraint and delete them

DECLARE @ConstraintName varchar (255)

DECLARE cursor_DeleteConstraintsForTable CURSOR FOR SELECT ConstraintName FROM #tblConstraints

OPEN cursor_DeleteConstraintsForTable

FETCH NEXT FROM cursor_DeleteConstraintsForTable INTO @ConstraintName
WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC ('ALTER TABLE [' + @TableName + '] DROP CONSTRAINT [' + @ConstraintName + ']')

	FETCH NEXT FROM cursor_DeleteConstraintsForTable INTO @ConstraintName
END

CLOSE cursor_DeleteConstraintsForTable
DEALLOCATE cursor_DeleteConstraintsForTable

DROP TABLE #tblConstraints
GO
