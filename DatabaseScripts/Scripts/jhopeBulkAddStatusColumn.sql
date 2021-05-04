--==========================================================================
-- Add column to tblBulkNegotiationListXref
-- Created: 05/15/2008
-- By:		Jim Hope
--==========================================================================
USE DMS_DEV
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tblBulkNegotiationListXref' 
AND COLUMN_NAME = 'SettlementStatusID')
	BEGIN
		-- Add a new column to the table
		ALTER TABLE dbo.tblBulkNegotiationListXref
		ADD SettlementStatusID INT NOT NULL
	END
GO
