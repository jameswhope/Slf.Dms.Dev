/****** Object:  StoredProcedure [dbo].[stp_ClientReport_WelcomeLetter]    Script Date: 11/19/2007 15:26:56 ******/
DROP PROCEDURE [dbo].[stp_ClientReport_WelcomeLetter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ClientReport_WelcomeLetter]
	(
		@clientId int
	)

as 

SELECT 
	tblPerson.*,
	tblPerson.FirstName + ' ' + tblPerson.LastName as ClientName,
	tblClient.AccountNumber,
	tblState.[Name] as State
FROM
	tblClient INNER JOIN 
	tblPerson ON tblClient.PrimaryPersonId=tblPerson.PersonId INNER JOIN
	tblState ON tblPerson.StateId=tblState.StateId
	
WHERE
	tblClient.ClientId=@clientId
GO
