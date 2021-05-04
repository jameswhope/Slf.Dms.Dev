IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Nondeposit_ResetPendingCancellation')
	BEGIN
		DROP  Procedure  stp_Nondeposit_ResetPendingCancellation
	END

GO

CREATE Procedure stp_Nondeposit_ResetPendingCancellation
AS
Begin

--Remove those with a good deposit after the last nondeposit

update tblnondepositpendingcancellation set
deleted = getdate(), deletedby = 32
where deleted is null
and clientid in (
select c.clientid 
from 
	tblnondepositpendingcancellation c
join --get the last good deposit per client
	(select t.* 
	 from	(select r.clientid, r.transactiondate, 
			rank() over (partition by r.clientid order by r.transactiondate desc) as ranked
			from tblregister r
			where r.entrytypeid = 3
			and r.void is null
			and r.bounce is null) t
	where t.ranked = 1) t1 on t1.clientid = c.clientid
join --get the last nondeposit per client
	(select t.*
	from	(select n.clientid, n.created,
			rank() over (partition by n.clientid order by n.created desc) as ranked
			from tblnondeposit n
			where n.deleted is null) t
			where t.ranked = 1) t2 on t2.clientid = c.clientid
where c.deleted is null
and t1.transactiondate > t2.created)


End

GO

 
