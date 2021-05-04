-- used in SQL Job: Weekly Archive

--select count(*) [before] from tblusersearch
--select count(*) [before] from dms_archive..tblusersearch

declare @userid int

declare cur cursor for 
	select userid
	from tblusersearch
	group by userid
	having count(*) > 5

create table #archive
(
	row int,
	usersearchid int, 
	userid int, 
	search datetime, 
	terms varchar(255), 
	results int, 
	resultsclients int, 
	resultsnotes int, 
	resultscalls int, 
	resultstasks int, 
	resultsemail int, 
	resultspersonnel int
)

set identity_insert dms_archive..tblusersearch on

open cur
fetch next from cur into @userid
while @@fetch_status = 0 begin

	insert #archive
	select row_number() over (partition by userid order by search desc) [row], usersearchid, userid, search, terms, results, resultsclients, resultsnotes, resultscalls, resultstasks, resultsemail, resultspersonnel
	from tblusersearch
	where userid = @userid

	insert dms_archive..tblusersearch (usersearchid, userid, search, terms, results, resultsclients, resultsnotes, resultscalls, resultstasks, resultsemail, resultspersonnel,archivedate)
	select usersearchid, userid, search, terms, results, resultsclients, resultsnotes, resultscalls, resultstasks, resultsemail, resultspersonnel,getdate()
	from #archive
	where row > 5
	and userid = @userid
	and usersearchid not in (
		select usersearchid
		from dms_archive..tblusersearch
		where userid = @userid
	)

	delete from tblusersearch
	where usersearchid in (
		select usersearchid
		from #archive
		where row > 5
		and userid = @userid
	)

	truncate table #archive -- clear for next user

	fetch next from cur into @userid
end

close cur
deallocate cur

set identity_insert dms_archive..tblusersearch off

drop table #archive

DBCC DBREINDEX(tblUserSearch,' ')

--select count(*) [after] from tblusersearch
--select count(*) [after] from dms_archive..tblusersearch 