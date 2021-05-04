
alter view vw_ClientTrustConvDate
as

select pk [ClientID], 
	max(case when audit_order = 1 then convert(int,[value]) else -1 end) [TrustID], 
	max(case when audit_order = 2 then convert(int,[value]) else -1 end) [OrigTrustID],
	max(case when audit_order = 1 then dc else '1/1/1900' end) [Converted]
from (
	select pk, [value], dc, row_number() over (partition by pk order by dc desc) as audit_order
	from tblaudit
	where auditcolumnid = 4
) d
where audit_order in (1,2)
group by pk

go