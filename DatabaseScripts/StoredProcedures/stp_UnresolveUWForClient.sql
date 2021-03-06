/****** Object:  StoredProcedure [dbo].[stp_UnresolveUWForClient]    Script Date: 11/19/2007 15:27:46 ******/
DROP PROCEDURE [dbo].[stp_UnresolveUWForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_UnresolveUWForClient]
	(
		@ClientId int
	)

as

delete from tblroadmap where clientstatusid in (12,11,14) and clientid=@clientid

select tbltask.taskid as taskid into #tmp from tbltask inner join tblclienttask on tbltask.taskid=tblclienttask.taskid where tblclienttask.clientid=@clientid and tasktypeid=6

delete from tblclienttask where taskid in(
	select taskid from #tmp
)

delete from tbltask where taskid in (
	select taskid from #tmp
)

update tblclient set vwuwresolved=null,vwuwresolvedby=null where clientid=@clientid

drop table #tmp
GO
