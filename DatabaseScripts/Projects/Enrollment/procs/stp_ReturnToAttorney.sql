
create procedure stp_ReturnToAttorney
(
	@clientid int,
	@depositamount money,
	@userid int
)
as
begin


if not exists (select 1 from tblPendingApproval where clientid = @clientid) begin 
	insert tblPendingApproval (ClientID) 
	values (@clientid) 
end;

-- this is the most likely change a rep will make when returning a client. other updates can be added here.
-- the import lead routine does not currently have functionality to update everything.

declare @id int

select top 1 @id=clientdepositid
from tblclientdepositday
where clientid = @clientid

update tblclientdepositday
set depositamount = @depositamount, lastmodified = getdate(), lastmodifiedby = @userid
where clientdepositid = @id
and depositamount <> @depositamount

update tblclient
set depositamount = @depositamount, lastmodified = getdate(), lastmodifiedby = @userid
where clientid = @clientid
and depositamount <> @depositamount


end
go 