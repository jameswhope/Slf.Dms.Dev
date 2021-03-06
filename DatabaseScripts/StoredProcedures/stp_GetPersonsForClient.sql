/****** Object:  StoredProcedure [dbo].[stp_GetPersonsForClient]    Script Date: 11/19/2007 15:27:13 ******/
DROP PROCEDURE [dbo].[stp_GetPersonsForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPersonsForClient]
	(
		@clientid int
	)

as

SELECT     tblPerson.PersonID, tblPerson.ClientID, tblPerson.SSN, tblPerson.FirstName, tblPerson.LastName, tblPerson.Gender, tblPerson.DateOfBirth, 
                      tblPerson.LanguageID, tblPerson.EmailAddress, tblPerson.Street, tblPerson.Street2, tblPerson.City, tblPerson.StateID, tblPerson.ZipCode, 
                      tblPerson.Relationship, tblPerson.CanAuthorize, tblPerson.Created, tblPerson.CreatedBy, tblPerson.LastModified, tblPerson.LastModifiedBy, 
                      tblPerson.WebCity, tblPerson.WebStateID, tblPerson.WebZipCode, tblPerson.WebAreaCode, tblPerson.WebTimeZoneID, tblPerson.ThirdParty, 
                      (CASE tblperson.relationship WHEN 'prime' THEN 1 ELSE 0 END) AS isprime, tblState.Name AS statename, tblState.Abbreviation AS stateabbreviation, 
                      tblLanguage.Name AS languagename, tblcreatedby.FirstName + ' ' + tblcreatedby.LastName AS createdbyname, 
                      tbllastmodifiedby.FirstName + ' ' + tbllastmodifiedby.LastName AS lastmodifiedbyname, DATEDIFF(day, ISNULL(YEAR(tblPerson.DateOfBirth), 
                      YEAR(GETDATE())), YEAR(GETDATE())) AS ClientAge, cNote.Value as [LastClientNote],
(CASE tblperson.relationship WHEN 'prime' THEN 'Client' ELSE 'Co-Applicant' END) as [LabelHdr]
FROM         (SELECT     TOP (1) cn.ClientID, n.Value
                       FROM          tblClientNote AS cn INNER JOIN
                                              tblNote AS n ON cn.NoteID = n.NoteID
                       WHERE      (cn.ClientID = @clientid)
                       ORDER BY cn.Created DESC) AS cNote RIGHT OUTER JOIN
                      tblPerson LEFT OUTER JOIN
                      tblState ON tblPerson.StateID = tblState.StateID INNER JOIN
                      tblLanguage ON tblPerson.LanguageID = tblLanguage.LanguageID ON cNote.ClientID = tblPerson.ClientID LEFT OUTER JOIN
                      tblUser AS tblcreatedby ON tblPerson.CreatedBy = tblcreatedby.UserID LEFT OUTER JOIN
                      tblUser AS tbllastmodifiedby ON tblPerson.LastModifiedBy = tbllastmodifiedby.UserID
WHERE     (tblPerson.ClientID = @clientid)
ORDER BY isprime DESC, tblPerson.CanAuthorize DESC, tblPerson.DateOfBirth DESC
GO
