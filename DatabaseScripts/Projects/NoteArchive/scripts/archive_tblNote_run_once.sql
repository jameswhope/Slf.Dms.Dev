-- RUN ONCE!
-- ran on dms_restored_daily in < 4min

declare @start datetime

set @start = dateadd(yy,-1,getdate())

print 'dropping FKs..'
alter table tblsettlementclientapproval drop FK_tblSettlementClientApproval_tblNote
alter table tblsettlementnote drop FK_tblSettlementNote_tblNote
alter table tblSettlementRoadmap drop FK_tblSettlementRoadmap_tblNote

-- backup notes
select *
into tblNote_bkup
from tblnote

print 'back up done'

-- move notes
select [NoteID],[Subject],[Value],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[OldTable],[OldID],[ClientID],[UserGroupID],[sysid],[ArchiveDate]=getdate()
INTO dms_archive..tblNote
from tblnote 
where created < @start

print 'archived notes'

-- get good notes
select [NoteID],[Subject],[Value],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[OldTable],[OldID],[ClientID],[UserGroupID],[sysid]
into #tbltempNotes
from tblnote where created > @start

print 'got good notes'

-- clear notes
truncate table tblnote
print 'truncated tblnotes'

-- insert good notes
SET IDENTITY_INSERT dbo.[tblnote] ON
insert into tblnote ([NoteID],[Subject],[Value],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[OldTable],[OldID],[ClientID],[UserGroupID],[sysid])
select [NoteID],[Subject],[Value],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[OldTable],[OldID],[ClientID],[UserGroupID],[sysid]
from #tbltempNotes
SET IDENTITY_INSERT dbo.[tblnote] OFF

print 'inserted good notes back into tblnotes'

--	Note Relations

select *
into tblNoteRelation_bkup
from tblnoterelation

print 'back up done'

-- move records
select nr.[NoteRelationID],nr.[NoteID],nr.[RelationTypeID],nr.[RelationID],[ArchiveDate]=getdate()
into dms_archive..tblNoteRelation
from [tblNoteRelation] nr
join dms_archive..tblnote na on na.noteid = nr.noteid

print 'archived note relations'

-- get good records
select nr.[NoteRelationID],nr.[NoteID],nr.[RelationTypeID],nr.[RelationID]
into #tblNRArchive
from [tblNoteRelation] nr
join tblnote n on n.noteid = nr.noteid

print 'got good relations'

-- clear table
truncate table [tblNoteRelation]  
print 'truncated tblnoterelation'

-- insert good records
set identity_insert tblNoteRelation on
insert [tblNoteRelation] (NoteRelationID,noteid,RelationTypeID,RelationID)
select nr.[NoteRelationID],nr.[NoteID],nr.[RelationTypeID],nr.[RelationID]
from #tblNRArchive nr
set identity_insert tblNoteRelation off

print 'inserted good relations back into tblnoterelation'

-- drop temp tables
drop table #tblNRArchive
drop table #tbltempNotes

print 're-indexing tblnote..'
DBCC DBREINDEX(tblnote,' ')

print 're-indexing tblnoterelation..'
DBCC DBREINDEX(tblNoteRelation,' ')


print 'creating indexes for archive tables..'

ALTER TABLE [dms_archive].[dbo].[tblNote] ADD  CONSTRAINT [PK_tblNote] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_tblNote_ClientID] ON [dms_archive].[dbo].[tblNote] 
(
	[ClientID] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]

DBCC DBREINDEX([dms_archive..tblNote],' ')



ALTER TABLE [dms_archive].[dbo].[tblNoteRelation] ADD  CONSTRAINT [PK_tblNoteRelation] PRIMARY KEY CLUSTERED 
(
	[NoteRelationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]

DBCC DBREINDEX([dms_archive..tblNoteRelation],' ')



print 'putting FKs back..'
ALTER TABLE [dbo].[tblSettlementClientApproval]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementClientApproval_tblNote] FOREIGN KEY([NoteId])
REFERENCES [dbo].[tblNote] ([NoteID])

ALTER TABLE [dbo].[tblSettlementNote]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementNote_tblNote] FOREIGN KEY([NoteId])
REFERENCES [dbo].[tblNote] ([NoteID])

ALTER TABLE [dbo].[tblSettlementRoadmap]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementRoadmap_tblNote] FOREIGN KEY([NoteId])
REFERENCES [dbo].[tblNote] ([NoteID])



print 'DONE!'


-- tblTaskNote doesnt need to be archived (under 1K rows currently), tblRoadmapNote under 20 rows
-- tblDocRelation.RelationType='note' not archived

/*
sp_help tblnote
DBCC SHOWCONTIG(tblnote)

select count(*) from tblnote 
select count(*) from dms_archive..tblNote
select count(*) from tblNoteRelation
select count(*) from dms_archive..tblNoteRelation
*/