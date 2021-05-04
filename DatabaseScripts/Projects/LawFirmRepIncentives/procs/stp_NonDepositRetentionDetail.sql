IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDepositRetentionDetail')
	DROP  Procedure  stp_NonDepositRetentionDetail
GO

create procedure stp_NonDepositRetentionDetail
(
	@repid int,
	@month int,
	@year int
)
as
begin


select c.clientid, c.accountnumber, p.firstname + ' ' + p.lastname [client], 
	case 
		when r.registerid is not null then r.transactiondate 
		when dr.replacementid is not null then dr.depositdate
		else null
	end [depositdate],
	case 
		when r.registerid is not null then 2 
		when dr.replacementid is not null then 1
		else 0 
	end [seq],
	case
		when r.bounce is null then 0
		else 1
	end [bounced]
from tblnondeposit n
join vw_leadapplicant_client v on v.clientid = n.clientid
join tblclient c on c.clientid = v.clientid
join tblperson p on p.personid = c.primarypersonid
join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
	and l.repid = @repid
left join tblnondepositreplacement dr on dr.replacementid = n.currentreplacementid
left join tblnondepositreplacementregisterxref x on x.replacementid = dr.replacementid
left join tblregister r on r.registerid = x.registerid
	--and r.bounce is null
	and (r.hold is null or r.clear < getdate())
	and r.transactiondate < getdate()
left join tblregister d on d.registerid = n.depositid
where n.deleted is null
	and (month(n.misseddate) = @month or month(d.transactiondate) = @month)
	and (year(n.misseddate) = @year or year(d.transactiondate) = @year)
order by [seq] desc, [depositdate], [client] 



end
go