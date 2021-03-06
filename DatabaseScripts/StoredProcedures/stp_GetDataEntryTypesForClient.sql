/****** Object:  StoredProcedure [dbo].[stp_GetDataEntryTypesForClient]    Script Date: 11/19/2007 15:27:08 ******/
DROP PROCEDURE [dbo].[stp_GetDataEntryTypesForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetDataEntryTypesForClient]
	(
		@clientid int
	)

as

select
	tbldataentrytype.*,
	t.numdataentries
from
	tbldataentrytype left outer join
	(
		select
			dataentrytypeid,
			count(dataentryid) as numdataentries
		from
			tbldataentry
		where
			clientid = @clientid
		group by
			dataentrytypeid
	)
	as t on tbldataentrytype.dataentrytypeid = t.dataentrytypeid
order by
	[order], [name]
GO
