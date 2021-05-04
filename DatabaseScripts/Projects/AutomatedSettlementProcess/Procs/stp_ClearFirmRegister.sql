IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClearFirmRegister')
	BEGIN
		DROP  Procedure  stp_ClearFirmRegister
	END

GO

--the xml is of the form <ClearChecks><ClearCheck FirmRegisterID = "123"/></ClearChecks>

CREATE Procedure [dbo].[stp_ClearFirmRegister]
(
@ClearXml XML,
@UserId INT
)

AS
BEGIN
	SET ARITHABORT ON;
	DECLARE @InTran BIT
			,@Return INT
			,@FirmRegisterExist BIT;
	

	SELECT @InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
			,@Return = 0
			,@FirmRegisterExist = (CASE WHEN (SELECT count(*) FROM tblFirmRegister WHERE FirmRegisterId NOT IN(
								  SELECT ParamValues.ParamId.value('@FirmRegisterId','int') 
	                     FROM @ClearXml.nodes('/ClearChecks/ClearCheck') AS ParamValues(ParamId))) = 0 THEN 1 ELSE 0 END);

	--IF @FirmRegisterExist = 1 SET @Return = -2;
	
	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY

			UPDATE tblFirmRegister SET
				Cleared = 1,
				ClearedDate = getdate(),
				LastModified = getdate(),
				LastModifiedBy = @UserId
			WHERE FirmRegisterId IN 
			(SELECT 
					ParamValues.ParamId.value('@FirmRegisterId','int')			
			 FROM 
					@ClearXml.nodes('/ClearChecks/ClearCheck') AS ParamValues(ParamId))

			IF @InTran = 0 COMMIT
		END TRY
		BEGIN CATCH
			SET @Return = -1
			IF @InTran = 0 ROLLBACK
		END CATCH
	END	
	SET ARITHABORT OFF;
	RETURN @Return;			
END
GO


GRANT EXEC ON stp_ClearFirmRegister TO PUBLIC

GO


