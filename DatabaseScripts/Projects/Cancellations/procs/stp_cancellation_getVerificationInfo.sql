IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_cancellation_getVerificationInfo')
	BEGIN
		DROP  Procedure  stp_cancellation_getVerificationInfo
	END

GO

create procedure [dbo].[stp_cancellation_getVerificationInfo]
(
	@clientid int
)
as
BEGIN
	SELECT     
		RTRIM(p.Street + ' ' + ISNULL(p.Street2, '')) AS ClientAddress
		, p.City + ', ' + s.Abbreviation + ' ' + p.ZipCode AS ClientCSZ
		, c.AgencyID
		, c.Created AS EnrollmentDate
		, ph.AreaCode + ph.Number AS ClientPhone
	FROM         
		tblPerson AS p INNER JOIN
		tblClient AS c ON p.ClientID = c.ClientID INNER JOIN
		tblState AS s ON p.StateID = s.StateID INNER JOIN
		tblPersonPhone AS perph ON p.PersonID = perph.PersonID INNER JOIN
		tblPhone AS ph ON perph.PhoneID = ph.PhoneID
	WHERE     
		(p.ClientID = @clientid) AND (ph.PhoneTypeID = 27)
END


GRANT EXEC ON stp_cancellation_getVerificationInfo TO PUBLIC

