
alter procedure stp_GetAccountsByCreditorID
(
	@CreditorID int
)
as
begin

	select distinct c.clientid, c.accountnumber, a.accountid
	from tblcreditorinstance ci
	join tblaccount a on a.accountid = ci.accountid
	join tblclient c on c.clientid = a.clientid
	where ci.creditorid = @CreditorID 
		or ci.forcreditorid = @CreditorID
	order by c.accountnumber

end
go	 