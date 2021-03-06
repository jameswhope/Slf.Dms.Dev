/****** Object:  StoredProcedure [dbo].[stp_GetDataEntriesForClient]    Script Date: 11/19/2007 15:27:08 ******/
DROP PROCEDURE [dbo].[stp_GetDataEntriesForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetDataEntriesForClient]
	(
		@clientid int
	)

as

select
	tbldataentry.*,
	tbldataentrytype.[name] as dataentrytypename,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname
from
	tbldataentry inner join
	tbldataentrytype on tbldataentry.dataentrytypeid = tbldataentrytype.dataentrytypeid left outer join
	tbluser as tblcreatedby on tbldataentry.createdby = tblcreatedby.userid
where
	tbldataentry.clientid = @clientid
order by
	tbldataentry.conducted desc
GO
