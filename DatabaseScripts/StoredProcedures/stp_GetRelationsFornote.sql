/****** Object:  StoredProcedure [dbo].[stp_GetRelationsFornote]    Script Date: 11/19/2007 15:27:15 ******/
DROP PROCEDURE [dbo].[stp_GetRelationsFornote]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRelationsFornote]
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
	tblnoterelation nr inner join
	tblnote n on nr.noteid=n.noteid inner join
	tblrelationtype rt on nr.relationtypeid=rt.relationtypeid
where 
	n.noteid=@noteid
GO
