--stp_ClientRelocations '8/21/09'

create procedure stp_ClientRelocations
(
	@StartDate datetime = null
)
as
begin
-- Created: 9/1/09	jhernandez	Currently monitors only NC activity


declare @day int

if @StartDate is null begin -- Start from last weekday
--	set @day = datepart(weekday,getdate())
--	if (@day = 1) set @StartDate = dateadd(dd,-2,getdate()) -- Sun
--	else if (@day = 2) set @StartDate = dateadd(dd,-3,getdate()) -- Mon
--	else set @StartDate = dateadd(dd,-1,getdate())
	set @StartDate = dateadd(dd,-30,getdate())
end


-- Get primary applicants that moved
select cp.name [Attorney], c.ClientID, AccountNumber, FirstName + ' ' + LastName [Client], OldState, NewState, convert(char(10),Moved,101) [Date], Moved [Date1]
from (
	select PersonID, 
		max(case when audit_order = 2 then [State] else '' end) [OldState],
		max(case when audit_order = 1 then [State] else '' end) [NewState], 
		max(case when audit_order = 1 then dc else '1/1/1900' end) [Moved]
	from (
		select pk [PersonID], s.name [State], cast(dc as datetime) [dc], row_number() over (partition by pk order by auditid desc) as audit_order
		from tblaudit a
		join tblstate s on s.stateid = a.value
		where auditcolumnid = 108 -- StateID
	) d
	where audit_order in (1,2)
	group by PersonID
) r
join tblPerson p on p.personid = r.personid
join tblClient c on c.primarypersonid = p.personid
join tblCompany cp on cp.companyid = c.companyid
where Moved >= @StartDate
and NewState in ('North Carolina')

union

-- Get new NC clients
select cp.name [Attorney], c.ClientID, AccountNumber, FirstName + ' ' + LastName [Client], '' [OldState], s.Name [NewState], convert(char(10),c.Created,101) [Date], c.Created [Date1]
from tblPerson p
join tblClient c on c.primarypersonid = p.personid
join tblCompany cp on cp.companyid = c.companyid
join tblState s on s.stateid = p.stateid
where c.Created >= @StartDate
and s.stateid in (34) -- NC

order by [Date1] desc


end
go 