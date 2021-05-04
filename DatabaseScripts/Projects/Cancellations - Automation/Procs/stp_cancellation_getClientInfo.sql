IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_cancellation_getClientInfo')
	BEGIN
		DROP  Procedure  stp_cancellation_getClientInfo
	END

GO

CREATE procedure [dbo].[stp_Cancellation_GetClientInfo]
(
	@clientid int
)
as
BEGIN
	SELECT 
		p.FirstName
		,p.LastName
		,c.AccountNumber
		,cs.[Name] As ClientStatus
		,isnull(p.IsDeceased,0) As IsDeceased
		,p.SSN
		,isnull(p.Street,'') AS Street
		,isnull(p.Street2,'') AS Street2
		, p.City 
		,s.Abbreviation 
		,p.ZipCode 
		,isnull(p.EmailAddress,'') As EmailAddress
		,(CASE
				WHEN len(ph.Number) > 3 THEN ('(' + isnull(ph.AreaCode,'') + ')' +substring(ph.Number,1,3) + '-' + substring(ph.Number,4,4) ) 
				ELSE ('(' + isnull(ph.AreaCode,'') + ')' +ph.Number ) 
		 END) AS ClientPhone
		,p.ThirdParty
		,p.Relationship
		,p.CanAuthorize
		,ph.PhoneTypeId
		,(select max(HardshipDate) FROM tblHardshipData WHERE ClientId = c.ClientId) As HardshipDate
		,com.[Name] As CompanyName
	FROM 
		tblClient c left join        
		tblPerson AS p ON p.ClientId = c.ClientId left join
		tblClientStatus cs ON cs.ClientStatusId = c.CurrentClientStatusId left join
		tblCompany com ON com.CompanyId = c.CompanyId left join
		tblState AS s ON p.StateID = s.StateID left join
		tblPersonPhone AS perph ON p.PersonID = perph.PersonID left join
		tblPhone AS ph ON perph.PhoneID = ph.PhoneID and ph.PhoneTypeId in (27,29) 
	WHERE     
		(p.ClientID = @clientid)
END
GO


GRANT EXEC ON stp_cancellation_getClientInfo TO PUBLIC



