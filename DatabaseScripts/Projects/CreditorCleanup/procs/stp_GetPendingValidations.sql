IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPendingValidations')
	BEGIN
		DROP  Procedure  stp_GetPendingValidations
	END
GO

create procedure stp_GetPendingValidations
as
begin

SELECT c.CreditorID, g.name, c.street, c.street2, c.city, isnull(c.stateid,-1) [stateid], 
	c.zipcode, c.validated, s.abbreviation, c.CreditorGroupID, c.CreditorAddressTypeID, 
	c.Created, u.firstname + ' ' + u.lastname [createdby], ug.name [dept]
FROM tblcreditor c 
JOIN tblCreditorGroup g ON g.CreditorGroupID = c.CreditorGroupID 
LEFT JOIN tblState s ON s.StateID = c.StateID 
LEFT JOIN tbluser u ON u.userid = c.createdby 
LEFT JOIN tblusergroup ug on ug.usergroupid = u.usergroupid
WHERE c.validated = 0 
ORDER BY c.Created

end
go 