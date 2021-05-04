 -- ran 8/11/10

alter table tblUserVisit drop PK_tblUserVisit
go
sp_rename 'tblUserVisit', 'tblUserVisitArchive'
go

declare @id bigint, @ident varchar(20)
select @id = max(uservisitid)+1 from tblUserVisitArchive
set @ident = cast(@id as varchar(15))

exec('
CREATE TABLE [dbo].[tblUserVisit](
	[UserVisitID] [int] IDENTITY(' + @ident + ',1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[TypeID] [int] NOT NULL,
	[Display] [varchar](50) NOT NULL,
	[Visit] [datetime] NOT NULL,
 CONSTRAINT [PK_tblUserVisit] PRIMARY KEY CLUSTERED 
(
	[UserVisitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
')
go


declare @userid int

declare cur cursor for 
	select userid 
	from tbluservisitarchive
	group by userid
	having count(*) > 10

set identity_insert tbluservisit on
open cur
fetch next from cur into @userid
while @@fetch_status = 0 begin

	insert tbluservisit (uservisitid, userid, [type], typeid, display, visit)
	select top 10 uservisitid, userid, [type], typeid, display, visit
	from tbluservisitarchive 
	where userid = @userid
	order by uservisitid desc

	fetch next from cur into @userid
end

close cur
deallocate cur
set identity_insert tbluservisit off


select * 
into dms_archive..tblUserVisit
from tbluservisitarchive

drop table tbluservisitarchive

alter table dms_archive..tblUserVisit add ArchiveDate datetime default(getdate()) not null