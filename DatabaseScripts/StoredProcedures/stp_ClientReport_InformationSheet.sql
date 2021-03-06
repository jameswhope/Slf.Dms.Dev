/****** Object:  StoredProcedure [dbo].[stp_ClientReport_InformationSheet]    Script Date: 11/19/2007 15:26:56 ******/
DROP PROCEDURE [dbo].[stp_ClientReport_InformationSheet]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[stp_ClientReport_InformationSheet]
	(
		@clientId int
	)

as 

declare @secPersonId int
set @secPersonId = (SELECT TOP 1 PersonId FROM tblPerson WHERE ClientId=@ClientId AND NOT PersonId = (SELECT PrimaryPersonId FROM tblClient WHERE ClientId=@ClientId))

SELECT 
	(SELECT [Name] FROM tblLanguage WHERE LanguageId=prim.LanguageID) as Lang,
	DepositMethod,
	DepositAmount,
	DepositDay,
	
	prim.FirstName + ' ' + prim.LastName as Name1,
	prim.Street as Street1,
	prim.Street2 as Street1b,
	prim.City as City1,
	(SELECT [Name] FROM tblState WHERE StateId=prim.StateId) as State1,
	prim.ZipCode as Zip1,
	prim.DateOfBirth as DOB1,
	prim.SSN as SSN1,
	(SELECT TOP 1 AreaCode + Number + ' ' + isnull(Extension,'') FROM tblPhone WHERE PhoneTypeId=27 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=prim.PersonId)) as HomePhone1,
	(SELECT TOP 1 AreaCode + Number + ' ' + isnull(Extension,'') FROM tblPhone WHERE PhoneTypeId=29 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=prim.PersonId)) as HomeFax1,
	(SELECT TOP 1 AreaCode + Number + ' ' + isnull(Extension,'') FROM tblPhone WHERE PhoneTypeId=21 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=prim.PersonId)) as BusinessPhone1,
	(SELECT TOP 1 AreaCode + Number + ' ' + isnull(Extension,'') FROM tblPhone WHERE PhoneTypeId=23 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=prim.PersonId)) as BusinessFax1,
	(SELECT TOP 1 AreaCode + Number + ' ' + isnull(Extension,'') FROM tblPhone WHERE PhoneTypeId=31 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=prim.PersonId)) as CellPhone1,
	prim.EmailAddress as Email1,

	sec.FirstName + ' ' + sec.LastName as Name2,
	sec.LastName as LastName2,
	sec.Street as Street2,
	sec.Street2 as Street2b,
	sec.City as City2,
	(SELECT [Name] FROM tblState WHERE StateId=sec.StateId) as State2,
	sec.ZipCode as Zip2,
	sec.DateOfBirth as DOB2,
	sec.SSN as SSN2,
	(SELECT TOP 1 AreaCode + Number + ' ' + Extension FROM tblPhone WHERE PhoneTypeId=27 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=@secPersonId)) as HomePhone2,
	(SELECT TOP 1 AreaCode + Number + ' ' + Extension FROM tblPhone WHERE PhoneTypeId=29 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=@secPersonId)) as HomeFax2,
	(SELECT TOP 1 AreaCode + Number + ' ' + Extension FROM tblPhone WHERE PhoneTypeId=21 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=@secPersonId)) as BusinessPhone2,
	(SELECT TOP 1 AreaCode + Number + ' ' + Extension FROM tblPhone WHERE PhoneTypeId=23 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=@secPersonId)) as BusinessFax2,
	(SELECT TOP 1 AreaCode + Number + ' ' + Extension FROM tblPhone WHERE PhoneTypeId=31 AND tblPhone.PhoneID IN (SELECT PhoneID FROM tblPersonPhone WHERE PersonId=@secPersonId)) as CellPhone2,
	sec.EmailAddress as Email2
FROM 
	tblClient INNER JOIN
	tblPerson as prim ON tblClient.PrimaryPersonId=prim.PersonId LEFT OUTER JOIN
	tblPerson as sec ON sec.PersonId=@secPersonId
	
WHERE
	tblClient.ClientId=@clientId
GO
