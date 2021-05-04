IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementClientInfo')
	BEGIN
		DROP  Procedure  stp_GetSettlementClientInfo
	END

GO

CREATE Procedure [dbo].[stp_GetSettlementClientInfo]
	(
		@ClientId int
	)

AS BEGIN

SELECT 
	c.AccountNumber, 
	p.PersonID, 
	p.ClientID, 
	p.SSN, 
	p.FirstName, 
	p.LastName, 
	p.Gender, 
	isnull(ph.AreaCode,'') as [AreaCode], 
	isnull(ph.Number,'') as [PhoneNumber],  
	isnull(extension, '') as [Extension], 
	isnull(p.DateOfBirth,'') as [DateOfBirth], 
	p.EmailAddress, 
	p.Street, 
	p.Street2, 
	p.City, 
	p.StateID, 
	p.ZipCode, 
	p.Relationship, 
	p.CanAuthorize, 
	p.ThirdParty, 
	(CASE p.relationship WHEN 'prime' THEN 1 ELSE 0 END) AS isprime, 
	s.Name AS statename, 
	s.Abbreviation AS stateabbreviation,
	DATEDIFF(day, ISNULL(YEAR(p.DateOfBirth),YEAR(GETDATE())), YEAR(GETDATE())) AS ClientAge, 
	(CASE p.relationship WHEN 'prime' THEN 'Client' ELSE 'Co-Applicant' END) AS LabelHdr, 
	tblCompany.Name as [SettlementAttorney]
FROM 
	tblPerson as p LEFT OUTER JOIN 
	tblState as s ON p.StateID = s.StateID INNER JOIN 
	tblClient as c ON p.ClientID = c.ClientID INNER JOIN 
	tblCompany ON c.CompanyID = tblCompany.CompanyID LEFT OUTER JOIN 	
	tblPersonPhone pp ON pp.PersonId = p.PersonId LEFT JOIN
	tblPhone ph ON ph.PhoneId = pp.PhoneId AND ph.PhoneTypeId = 27 
WHERE 
	p.ClientID = @ClientId 
ORDER BY 
	isprime DESC, p.CanAuthorize DESC, p.DateOfBirth DESC 

END

GO


GRANT EXEC ON stp_GetSettlementClientInfo TO PUBLIC

GO


