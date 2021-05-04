if exists (select 1 from sys.objects where name = 'stp_GetNachaRegister2DepositDups') begin
	drop procedure stp_GetNachaRegister2DepositDups
end
go

create procedure stp_GetNachaRegister2DepositDups
(
	@nachafileid int
)
as
begin
-- returns batch items that may be duplicate drafts
-- most common cause: dup client records


select n.*
from tblnacharegister2 n
join (
	-- grouping by client's first initial to omit husband/wife scenarios where they're drafting from the same account
	-- on the same day (not common)
	select left(name,1) [init], accountnumber, routingnumber
	from tblnacharegister2
	where nachafileid = @nachafileid
	group by left(name,1), accountnumber, routingnumber
	having count(*) > 1
) d
on left(n.name,1) = d.init
and n.accountnumber = d.accountnumber
and n.routingnumber = d.routingnumber
where n.nachafileid = @nachafileid
order by n.accountnumber


end
go