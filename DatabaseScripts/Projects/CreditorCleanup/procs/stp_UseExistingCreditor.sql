IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UseExistingCreditor')
	BEGIN
		DROP  Procedure   stp_UseExistingCreditor
	END
GO

create procedure stp_UseExistingCreditor
(
	@OldCreditorID int,
	@NewCreditorID int,
	@UserID int
)
as
begin
/*
	Used when validating creditors. The user determined that the creditor pending validation already
	exists.
*/

update tblcreditorinstance
set creditorid = @NewCreditorID, lastmodified = getdate(), lastmodifiedby = @UserID
where creditorid = @OldCreditorID

update tblcreditorinstance
set forcreditorid = @NewCreditorID, lastmodified = getdate(), lastmodifiedby = @UserID
where forcreditorid = @OldCreditorID

update tblcontact
set creditorid = @NewCreditorID, lastmodified = getdate(), lastmodifiedby = @UserID
where creditorid = @OldCreditorID

update tblcreditorphone
set creditorid = @NewCreditorID, lastmodified = getdate(), lastmodifiedby = @UserID
where creditorid = @OldCreditorID	

update tblcreditorhistory
set newcreditorid = @NewCreditorID
where creditorid = @OldCreditorID	

update tblleadcreditorinstance
set creditorid = @NewCreditorID
where creditorid = @OldCreditorID

update tblleadcreditorinstance
set creditorgroupid = c.creditorgroupid, name = c.name, street = c.street, street2 = c.street2, city = c.city, stateid = c.stateid, zipcode = c.zipcode
from tblleadcreditorinstance ci
join tblcreditor c on c.creditorid = ci.creditorid
	and c.creditorid = @NewCreditorID
	
update tblcreditliabilitylookup
set creditorid = @NewCreditorID, CreditorIdUpdated = getdate(), CreditorIdUpdatedBy = @UserID
where creditorid = @OldCreditorID	

-- now that the old creditor is not being used, delete it
delete from tblcreditor where creditorid = @OldCreditorID


end 
go 