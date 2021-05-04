IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_Vici_Client_Phones')
	BEGIN
		DROP  View vw_Vici_Client_Phones
	END
GO

CREATE View vw_Vici_Client_Phones AS
select p1.*, 
ranked = rank() over (partition by p1.clientid order by p1.personorder, p1.[phoneorder], p1.phoneid) 
from (
select 
p.clientid,
[personorder] = case when p.relationship = 'prime' then 1 
					when p.relationship = 'spouse' then 2
					else 3 end,
[phoneorder] =  case when ph.phonetypeid in (27,28,35) then 1
					 when ph.phonetypeid = 31 then 2
					 else 3 end,
phone =	ph.areacode+ph.number, 
p.personid,
ph.phoneid
from tblPerson p 
inner join tblPersonPhone pp ON pp.PersonId = p.PersonId 
left join tblPhone ph ON ph.PhoneId = pp.PhoneId 
Where
ph.PhoneId is not null 
and ph.phonetypeid not in (23,29,33) -- all phones but faxes
and ph.excludefromdialer = 0 
and ph.ExcludeFromDialerPerm = 0
and isnull(p.isdeceased,0) = 0) p1

GO

 