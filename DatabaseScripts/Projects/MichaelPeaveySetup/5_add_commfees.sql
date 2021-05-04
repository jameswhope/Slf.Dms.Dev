

-- get palmer structs
select distinct cs.commstructid, commscenid, commrecid, parentcommrecid, [order] 
into #palmer
from tblcommstruct cs
join tblcommfee f on f.commstructid = cs.commstructid
where companyid = 2

-- get peavey structs
select distinct commstructid, commscenid, commrecid, parentcommrecid, [order] 
into #peavey
from tblcommstruct
where companyid = 5

-- need to differenciate any dup structs
update #palmer 
set [order] = 99
where commstructid in (
	select max(commstructid)
	from #palmer
	group by commstructid, commscenid, commrecid, parentcommrecid, [order] 
	having count(*) > 1
)

update #peavey
set [order] = 99
where commstructid in (
	select max(commstructid)
	from #peavey
	group by commstructid, commscenid, commrecid, parentcommrecid, [order] 
	having count(*) > 1
)


declare 
	@palmer_commstructid int, 
	@palmer_commscenid int,
	@palmer_commrecid int,
	@palmer_parentcommrecid int,
	@palmer_order int,
	@peavey_commstructid int

declare cur cursor for select commstructid, commscenid, commrecid, parentcommrecid, [order] from #palmer

open cur 
fetch next from cur into @palmer_commstructid, @palmer_commscenid, @palmer_commrecid, @palmer_parentcommrecid, @palmer_order

while @@fetch_status = 0 begin
	if @palmer_commrecid = 22 set @palmer_commrecid = 39
	if @palmer_commrecid = 20 set @palmer_commrecid = 38
	if @palmer_commrecid = 18 set @palmer_commrecid = 37

	if @palmer_parentcommrecid = 22 set @palmer_parentcommrecid = 39
	if @palmer_parentcommrecid = 20 set @palmer_parentcommrecid = 38
	if @palmer_parentcommrecid = 18 set @palmer_parentcommrecid = 37

	select @peavey_commstructid = commstructid
	from #peavey
	where commscenid = @palmer_commscenid
	and commrecid = @palmer_commrecid
	and parentcommrecid = @palmer_parentcommrecid
	and [order] = @palmer_order

	insert tblcommfee (commstructid,entrytypeid,[percent],created,createdby,lastmodified,lastmodifiedby)
	select @peavey_commstructid,entrytypeid,[percent],getdate(),820,getdate(),820
	from tblcommfee
	where commstructid = @palmer_commstructid

	fetch next from cur into @palmer_commstructid, @palmer_commscenid, @palmer_commrecid, @palmer_parentcommrecid, @palmer_order
end

close cur
deallocate cur

drop table #palmer
drop table #peavey 


--select cs.commscenid, cs.commrecid, cs.parentcommrecid, f.entrytypeid, f.[percent]
--from tblcommstruct cs
--join tblcommfee f on f.commstructid = cs.commstructid
--where cs.companyid = 2
--order by cs.commscenid, f.entrytypeid, f.[percent], cs.commrecid