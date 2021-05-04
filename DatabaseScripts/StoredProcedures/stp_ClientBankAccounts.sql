
alter procedure stp_ClientBankAccounts
(
	@ClientID int
)
as
begin



select r.customername + '::' + r.routingnumber + '::' + d.bankaccountnumber + '::' + d.banktype [bankaccount]
from (
	select distinct routingnumber [bankroutingnumber], accountnumber [bankaccountnumber], isnull(banktype,'C') [banktype]
	from tblclientbankaccount
	where clientid = @ClientID
	and disabled is null

	union 

	select bankroutingnumber, bankaccountnumber, isnull(banktype,'C') [banktype]
	from tblclient
	where clientid = @ClientID
	and bankaccountnumber is not null

	union

	select distinct bankroutingnumber, bankaccountnumber, isnull(banktype,'C') [banktype]
	from tbladhocach
	where clientid = @ClientID

	union 

	select distinct bankroutingnumber, bankaccountnumber, isnull(banktype,'C') [banktype]
	from tblruleach
	where clientid = @ClientID
) d
join tblroutingnumber r on r.routingnumber = d.bankroutingnumber



end
go 