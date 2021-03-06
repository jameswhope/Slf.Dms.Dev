/****** Object:  StoredProcedure [dbo].[stp_DeleteRelation]    Script Date: 11/19/2007 15:27:00 ******/
DROP PROCEDURE [dbo].[stp_DeleteRelation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DeleteRelation]
	(
		@relationtypeid int,
		@relationid int
	)

as

-- for notes
delete
from
	tblnoterelation
where
	relationtypeid = @relationtypeid and
	relationid = @relationid


-- for phone calls
delete
from
	tblphonecallrelation
where
	relationtypeid = @relationtypeid and
	relationid = @relationid
GO
