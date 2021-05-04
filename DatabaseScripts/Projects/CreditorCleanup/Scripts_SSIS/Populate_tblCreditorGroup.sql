--Populate tblCreditorGroup from MasterCreditorList
DECLARE @counter int
SET @counter = 1
DECLARE @Name varchar(250)

DECLARE cursor_Creditor CURSOR FOR
SELECT [creditor name], MasterCreditorListID FROM MasterCreditorList

OPEN cursor_Creditor

FETCH NEXT FROM cursor_Creditor INTO @Name,  @counter

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE tblCreditorGroup
		SET MasterCreditorListID = @counter
		WHERE [Name] = @Name

		FETCH NEXT FROM cursor_Creditor INTO @Name, @counter
	END

CLOSE cursor_Creditor
DEALLOCATE cursor_Creditor