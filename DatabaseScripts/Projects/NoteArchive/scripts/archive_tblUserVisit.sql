select count(*) [before] from tbluservisit
select count(*) [before] from dms_archive..tbluservisit

declare @userid int

set identity_insert dms_archive..tbluservisit on

declare cur cursor for 
	select userid
	from tbluservisit
	group by userid
	having count(*) > 10

create table #archive
(
	row int,
	uservisitid int, 
	userid int, 
	type varchar(50),
	typeid int,
	display varchar(50),
	visit datetime
)

open cur
fetch next from cur into @userid
while @@fetch_status = 0 begin

	insert #archive
	select row_number() over (partition by userid order by visit desc) [row], uservisitid, userid, [type], typeid, display, visit
	from tbluservisit
	where userid = @userid

	insert dms_archive..tbluservisit (uservisitid, userid, [type], typeid, display, visit)
	select uservisitid, userid, [type], typeid, display, visit
	from #archive
	where row > 10
	and userid = @userid
	and uservisitid not in (
		select uservisitid
		from dms_archive..tbluservisit
		where userid = @userid
	)

	delete from tbluservisit
	where uservisitid in (
		select uservisitid
		from #archive
		where row > 10
		and userid = @userid
	)

	truncate table #archive -- clear for next user

	fetch next from cur into @userid
end

close cur
deallocate cur

drop table #archive

set identity_insert dms_archive..tbluservisit off

DBCC DBREINDEX(tbluservisit,' ')

select count(*) [after] from tbluservisit
select count(*) [after] from dms_archive..tbluservisit 