IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetFirmRegister')
	BEGIN
		DROP  Procedure  stp_GetFirmRegister
	END

GO

CREATE Procedure [dbo].[stp_GetFirmRegister]

AS
BEGIN

	SELECT
		r.FirmRegisterId,
		r.RegisterId,
		r.FirmId,
		r.ProcessedDate,
		r.RequestType AS RequestedType,
		(CASE
			WHEN r.DataType = 'DEBITS' THEN (r.Amount * -1)
			ELSE r.Amount
		END) As Amount,
		r.CheckNumber,
		isnull(r.ReferenceNumber, '') AS ReferenceNumber,
		isnull(r.Detail, '') AS Detail,
		r.Cleared,
		r.DataType,
		isnull(r.Void, 0) AS Void,
		c.[Name] AS FirmName,
		cl.ClientId,
		p.FirstName + ' ' + p.LastName + ' - ' + cl.AccountNumber + ' - ' + cr.[Name] AS ClientDetails,
		(CASE
			WHEN isnull(r.Void, 0) = 1 THEN r.VoidedDate
			WHEN r.Cleared = 1 THEN r.ClearedDate
			ELSE null
		END) AS ClearedDate
	FROM tblFirmRegister r inner join
	tblCompany c ON c.CompanyId = r.FirmId inner join
	tblRegister rg ON rg.RegisterId = r.RegisterId inner join
	tblClient cl ON cl.ClientId = rg.ClientId inner join
	tblPerson p ON p.PersonId = cl.PrimaryPersonId inner join 
	tblAccount a ON a.AccountId = rg.AccountID inner join
	tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
	tblCreditor cr ON cr.CreditorId = ci.CreditorId
END
GO


GRANT EXEC ON stp_GetFirmRegister TO PUBLIC

GO


