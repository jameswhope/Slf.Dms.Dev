-- ran 3/19/10

sp_rename 'tblUserSearch', 'tblUserSearchArchive'
go

declare @id bigint, @ident varchar(20)
select @id = max(usersearchid)+1 from tblUserSearchArchive
set @ident = cast(@id as varchar(15))

exec('
CREATE TABLE [dbo].[tblUserSearch](
	[UserSearchID] [int] IDENTITY(' + @ident + ',1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[Search] [datetime] NOT NULL,
	[Terms] [varchar](255) NOT NULL,
	[Results] [int] NOT NULL,
	[ResultsClients] [int] NOT NULL,
	[ResultsNotes] [int] NOT NULL,
	[ResultsCalls] [int] NOT NULL,
	[ResultsTasks] [int] NOT NULL,
	[ResultsEmail] [int] NOT NULL,
	[ResultsPersonnel] [int] NOT NULL,
	CONSTRAINT [PKI_tblUserSearch] PRIMARY KEY CLUSTERED 
(
	[UserSearchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
')
go


declare @userid int
declare cur cursor for select userid from tbluser where locked = 0 and userid not in (select distinct userid from tblusersearch) and userid in (select distinct userid from tblusersearcharchive)

set identity_insert tblusersearch on
open cur
fetch next from cur into @userid
while @@fetch_status = 0 begin

	insert tblusersearch (usersearchid, userid, search, terms, results, resultsclients, resultsnotes, resultscalls, resultstasks, resultsemail, resultspersonnel)
	select top 5 usersearchid, userid, search, terms, results, resultsclients, resultsnotes, resultscalls, resultstasks, resultsemail, resultspersonnel
	from tblusersearcharchive 
	where userid = @userid
	order by usersearchid desc

	fetch next from cur into @userid
end

close cur
deallocate cur
set identity_insert tblusersearch off


select * 
into dms_archive..tblUserSearch
from tblusersearcharchive

drop table tblusersearcharchive

alter table dms_archive..tblUserSearch add ArchiveDate datetime default(getdate()) not null