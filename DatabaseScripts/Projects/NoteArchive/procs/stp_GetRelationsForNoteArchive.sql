IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetRelationsForNoteArchive')
	DROP  Procedure  stp_GetRelationsForNoteArchive
GO

create procedure stp_GetRelationsForNoteArchive
(
	@noteid int
)
as

select 
	noterelationid,
	n.noteid,
	nr.relationtypeid,
	nr.relationid,
	rt.name as relationtypename,
	dbo.getentitydisplay(rt.relationtypeid,relationid) as relationname,
	rt.iconurl,
	rt.navigateurl
from
	dms_archive..tblnoterelation nr inner join
	dms_archive..tblnote n on nr.noteid=n.noteid inner join
	tblrelationtype rt on nr.relationtypeid=rt.relationtypeid
where 
	n.noteid=@noteid

GO
 