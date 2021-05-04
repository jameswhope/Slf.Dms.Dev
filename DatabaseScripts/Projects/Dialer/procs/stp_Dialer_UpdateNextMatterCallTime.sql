IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateNextMatterCallTime')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateNextMatterCallTime
	END

GO

CREATE Procedure stp_Dialer_UpdateNextMatterCallTime
@CallMadeId int,
@ReasonId int
AS
BEGIN
--Release expired locks
Update tblmatter Set
DialerLock = 0
Where  DialerRetryAfter is  not null
and DialerLock = 1
and DialerRetryAfter <= GetDate()
--Update next time to call. Onr week for those nondeposits older than a week
Update tblmatter set
DialerRetryAfter = Case When (@ReasonId = 2 and datediff(d, q.taskcreated, getdate()) > 7 )
				   Then DateAdd(d, 7, getdate())
				   Else DateAdd(n, q.defaultexpiration, getdate())
				   End
FROM
tblmatter mtt
inner join
(select mt.matterid, cr.reasonid, r.defaultexpiration, taskcreated = t.created from tbldialercallresolution cr
inner join tbltask t on cr.FieldValue = t.taskid 
inner join tblmattertask mt on mt.taskid = t.taskid
inner join tbldialercallreasontype r on cr.reasonid = r.reasonid
where cr.callmadeid = @CallMadeId and cr.reasonId = @reasonId) q on q.matterid = mtt.matterid
Where mtt.dialerlock = 0

END
GO

 

