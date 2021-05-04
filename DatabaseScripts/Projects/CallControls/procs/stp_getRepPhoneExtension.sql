
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getRepPhoneExtension')
	BEGIN
		DROP  Procedure  stp_getRepPhoneExtension
	END

GO

CREATE Procedure stp_getRepPhoneExtension

AS

BEGIN

	BEGIN TRY 

		BEGIN TRANSACTION

			TRUNCATE TABLE tblUserExt

			INSERT INTO tblUserExt

			SELECT SUBSTRING(ic.value,2, 6) [Ext], 
			i.FirstName + ' ' + i.lastname [FullName], 
			i.weblogin [Login] 
			FROM [DMF-SQL-0001].I3_CIC.dbo.[IndivConnection] ic
			JOIN [DMF-SQL-0001].I3_CIC.dbo.individual i ON i.IndivID = ic.IndivID
			WHERE LEFT(VALUE, 1) = '/'
			
			COMMIT TRAN
			
	END TRY
		
	BEGIN CATCH
		
			IF @@TRANCOUNT > 0
				BEGIN
					ROLLBACK TRAN
				
					SELECT ERROR_MESSAGE()
				END
				
	END CATCH
	
END

GO