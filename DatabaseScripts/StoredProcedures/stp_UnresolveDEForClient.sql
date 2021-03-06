/****** Object:  StoredProcedure [dbo].[stp_UnresolveDEForClient]    Script Date: 11/19/2007 15:27:46 ******/
DROP PROCEDURE [dbo].[stp_UnresolveDEForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_UnresolveDEForClient]
	(
		@ClientId int
	)

as

exec stp_UnresolveUWForClient @clientid

delete from tblroadmap where clientstatusid in (10) and clientid=@clientid

select tbltask.taskid as taskid into #tmp2 from tbltask inner join tblclienttask on tbltask.taskid=tblclienttask.taskid where tblclienttask.clientid=@clientid and tasktypeid=4

delete from tblclienttask where taskid in(
	select taskid from #tmp2
)

delete from tbltask where taskid in (
	select taskid from #tmp2
)

update tblclient set vwderesolved=null,vwderesolvedby=null where clientid=@clientid

drop table #tmp2
GO
