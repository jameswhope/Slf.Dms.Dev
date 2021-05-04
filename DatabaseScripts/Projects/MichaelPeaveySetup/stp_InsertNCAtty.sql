IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertNCAtty')
	BEGIN
		DROP  Procedure  stp_InsertNCAtty
	END
GO

CREATE Procedure stp_InsertNCAtty
AS
INSERT INTO tblCompany (Name, Default, ShortCoName, Created, CreatedBy, LastModified, LastModifiedBy, Contact1, BillingMessage, SigPath, ControlledAccountName)
VALUES ('The Law Offices of Michael P. Peavey', 0, 'PEAVEY', getdate(), 24, getdate(), 24, 'Michael P. Peavey', 'Monday thru Friday 7:00 am to 6:00 pm PST', '\\nas02\Sig\signature_Peavey.jpg', 'Peavey General Clearing Account')
GO

GRANT EXEC ON stp_InsertNCAtty TO PUBLIC
GO


