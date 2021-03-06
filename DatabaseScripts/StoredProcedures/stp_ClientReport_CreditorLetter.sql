/****** Object:  StoredProcedure [dbo].[stp_ClientReport_CreditorLetter]    Script Date: 11/19/2007 15:26:56 ******/
DROP PROCEDURE [dbo].[stp_ClientReport_CreditorLetter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[stp_ClientReport_CreditorLetter]
	(
		@clientId int
	)

as 

declare @secPersonId int
set @secPersonId = (SELECT TOP 1 PersonId FROM tblPerson WHERE ClientId=@ClientId AND NOT PersonId = (SELECT PrimaryPersonId FROM tblClient WHERE ClientId=@ClientId))

SELECT 
	tblPerson.FirstName + ' ' + tblPerson.LastName as ClientName,
	sec.FirstName + ' ' + sec.LastName as ClientName2,
		tblAttorney.FirstName + ' ' + Coalesce(tblAttorney.MiddleName,'') + 
		(CASE WHEN tblAttorney.MiddleName is NULL THEN '' ELSE ' ' END) + 
		tblAttorney.LastName + 
		(CASE WHEN tblAttorney.Suffix is NULL THEN '' ELSE ', ' END)
		+ Coalesce(tblAttorney.Suffix,'') AS AttorneyName,

	tblCreditorInstance.AccountNumber,
	tblCreditorInstance.ReferenceNumber,
	tblCreditor.[Name] as CreditorName,
	tblCreditor.Street as CreditorStreet,
	tblCreditor.Street2 as CreditorStreet2,
	tblCreditor.City as CreditorCity,
	(SELECT [Name] FROM tblState WHERE StateId=tblCreditor.StateId) as CreditorState,
	(SELECT [Name] FROM tblState WHERE StateId=tblPerson.StateId) as PrimaryPersonState,
	tblCreditor.ZipCode as CreditorZipCode
FROM
	tblAccount INNER JOIN 
	tblCreditorInstance ON tblAccount.CurrentCreditorInstanceId=tblCreditorInstance.CreditorInstanceId INNER JOIN
	tblCreditor ON tblCreditorInstance.CreditorId=tblCreditor.CreditorId INNER JOIN
	tblClient ON tblAccount.ClientId=tblClient.ClientId INNER JOIN
	tblPerson ON tblClient.PrimaryPersonId=tblPerson.PersonId LEFT OUTER JOIN
	tblAttorney ON tblAttorney.CompanyId=tblClient.CompanyId AND tblAttorney.StateId=tblPerson.StateId LEFT OUTER JOIN
	tblPerson as sec ON sec.PersonId=@secPersonId
WHERE
	tblAccount.ClientId=@clientId
GO
