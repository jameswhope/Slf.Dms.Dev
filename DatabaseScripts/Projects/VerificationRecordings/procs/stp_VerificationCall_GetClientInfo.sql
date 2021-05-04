IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_GetClientInfo')
	BEGIN
		DROP  Procedure  stp_VerificationCall_GetClientInfo
	END

GO

CREATE Procedure stp_VerificationCall_GetClientInfo
@VerificationId int
AS
	Select v.ClientId,
	c.AccountNumber,
	isnull(p.FirstName,'') + ' ' + isnull(p.LastName,'') as [FullName],
	v.LanguageId,
	v.callidkey,
	isnull(u.firstname,'') + ' ' + isnull(u.lastname,'') as [VerifiedBy]
	From tblVerificationCall v
	inner join tblClient c on c.clientid = v.clientid
	inner join tblPerson p on p.PersonId = c.PrimaryPersonId  
	inner join tbluser u on u.userid = v.executedby
	Where v.VerificationCallId = @VerificationId

GO


