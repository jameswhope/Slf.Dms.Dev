
alter procedure stp_ActiveScenarioList
as
begin

select s.commscenid,'(' + cast(s.commscenid as varchar(10)) + ') ' 
	+ '(' + cast(s.agencyid as varchar(10)) + ') ' + a.name + ' ' 
	+ convert(varchar(10),s.startdate,101) + '-' 
	+ convert(varchar(10),isnull(s.enddate,'1/1/2050'),101) + ' (' 
	+ convert(varchar(5),s.retentionfrom) + '-' + convert(varchar(5),s.retentionto) 
	+ ')' [scenario] 
from tblcommscen s 
join tblagency a on a.agencyid = s.agencyid 
left join tblcommbatch b on b.commscenid = s.commscenid 
group by s.commscenid, s.agencyid, a.name, s.startdate, s.enddate, s.retentionfrom, s.retentionto 
having max(b.batchdate) > dateadd(mm,-3,getdate()) 
order by s.agencyid, s.startdate, s.enddate, s.retentionfrom, s.retentionto

end 