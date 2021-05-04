--Populate tblCreditor with linked creditor data, linked to tblCreditorGroup
DECLARE @CreditorGroupID int
DECLARE @Name nvarchar(250)
DECLARE @Servicer nvarchar(250)
DECLARE @Address nvarchar(100)
DECLARE @City nvarchar(50)
DECLARE @StateID int
DECLARE @Zip nvarchar(20)

DECLARE cursor_Creditor CURSOR FOR
SELECT 
cg.CreditorGroupID, 
cg.[Name],
CASE WHEN ml.[Collection Payments] IS NOT NULL THEN ml.[Collection Payments] ELSE cg.[Name] END [Servicer],
ml.Address,
ml.City,
s.StateID,
ml.Zip
FROM tblcreditorgroup cg
INNER JOIN mastercreditorlist ml ON ml.[creditor name] = cg.name
INNER JOIN tblstate s ON s.abbreviation = ml.state
ORDER BY cg.name

OPEN cursor_Creditor

FETCH NEXT FROM cursor_Creditor INTO @CreditorGroupID, @Name,  @Servicer, @Address, @City, @StateID, @Zip

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO tblCreditor 
		(
			[Name],
			Street,
			City,
			StateID,
			ZipCode,
			Created,
			CreatedBy,
			LastModified,
			LastModifiedBy,
			Validated,
			CreditorGroupID
			)
			VALUES 
			(
			@Servicer,
			@Address,
			@City,
			@StateID,
			@Zip,
			getdate(),
			24,
			getdate(),
			24,
			1,
			@CreditorGroupID
			)
		FETCH NEXT FROM cursor_Creditor INTO @CreditorGroupID, @Name,  @Servicer, @Address, @City, @StateID, @Zip
	END

CLOSE cursor_Creditor
DEALLOCATE cursor_Creditor