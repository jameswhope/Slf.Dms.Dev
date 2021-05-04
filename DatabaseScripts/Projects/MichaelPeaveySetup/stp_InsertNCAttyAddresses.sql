IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertNCAttyAddresses')
	BEGIN
		DROP  Procedure  stp_InsertNCAttyAddresses
	END
GO
CREATE Procedure stp_InsertNCAttyAddresses
AS
/*INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (1, 5, '', '', '', '', '', getdate())
INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (2, 5, '', '', '', '', '', getdate())*/
INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (3, 5, 'P.O. Box 1300', ' ', 'Rancho Cucamonga', 'CA', '91729-1300', getdate())
INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (4, 5, 'P.O. Box 3600', ' ', 'Rancho Cucamonga', 'CA', '91729-3600', getdate())
INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (5, 5, '11690 Pacific Ave.', 'Suite 100', 'Fontana', 'CA', '92337-8244', getdate())
GO
GRANT EXEC ON stp_InsertNCAttyAddresses TO PUBLIC
GO

