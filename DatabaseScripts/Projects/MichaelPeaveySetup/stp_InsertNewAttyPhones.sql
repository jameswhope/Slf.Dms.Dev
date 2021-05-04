IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertNCAttyPhones')
	BEGIN
		DROP  Procedure  stp_InsertNCAttyPhones
	END
GO

CREATE Procedure stp_InsertNCAttyPhones
AS
INSERT INTO tblCompanyPhone (CompanyPhoneID, CompanyID, PhoneType, PhoneNumber) VALUES (35, 5, 46, '8006962930')
INSERT INTO tblCompanyPhone (CompanyPhoneID, CompanyID, PhoneType, PhoneNumber) VALUES (35, 5, 48, '8006974018')
INSERT INTO tblCompanyPhone (CompanyPhoneID, CompanyID, PhoneType, PhoneNumber) VALUES (35, 5, 50, '9095817487')
INSERT INTO tblCompanyPhone (CompanyPhoneID, CompanyID, PhoneType, PhoneNumber) VALUES (35, 5, 44, '8006961081')
GO
GRANT EXEC ON stp_InsertNCAttyPhones TO PUBLIC
GO


