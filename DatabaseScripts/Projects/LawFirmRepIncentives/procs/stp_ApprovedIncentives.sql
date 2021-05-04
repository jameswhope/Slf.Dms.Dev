IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ApprovedIncentives')
	DROP  Procedure  stp_ApprovedIncentives
GO

create procedure stp_ApprovedIncentives
(
	@repid int
)
as
begin

select i.incentiveid, sum(case when d.initial = 1 then d.eligible else 0 end) [eligible]
into #eligible
from tblincentives i
join tblincentivedetail d on d.incentiveid = i.incentiveid
where i.repid = @repid
group by i.incentiveid

select top 6 datename(month,cast(i.incentivemonth as varchar(2))+'/1/2000')+' '+cast(i.incentiveyear as varchar(4)) [monthyear], 
	cast(i.initialcount as varchar(5)) + case when e.eligible <> i.initialcount then '(' + cast(e.eligible as varchar(5)) + ')' else '' end [initialcount], 
	i.initialpayment, i.initialtotal, 
	i.residualcount, i.residualpayment, i.residualtotal,
	i.teamcount, i.teampayment, i.teamtotal,
	i.initialcount + i.residualcount[totalcount], i.initialtotal + i.residualtotal[totalamt],
	(i.initialtotal + i.residualtotal + i.teamtotal) * isnull(i.adjustment,1.0) [indteamtotal],
	i.incentivemonth[month], i.incentiveyear[year], 1 [approved], i.adjustment
from tblincentives i
join tbluser u on u.userid = i.repid
join #eligible e on e.incentiveid = i.incentiveid
where i.repid = @repid
order by [year] desc, [month] desc

drop table #eligible

end
go 