set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <03 - 23 December 2009>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Populating the tasks of a matter with the time zones

*/
CREATE procedure [dbo].[stp_GetMattertasks]
(
	@MatterId int
)
AS

BEGIN

Select *, (Select FromUTC from tblTimeZone Where DBIsHere=1) as DBTimeDiff
FROM dbo.tblMatterTask M, dbo.tblTask T left outer join tblTimeZone Z 
on T.DueDateZoneDisplay=Z.TimeZoneID
Where M.TaskID=T.TaskID and M.MatterID=@MatterId
--and t.Resolved is not null
order by Created

END




