IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextClient4DepositQueue')
	BEGIN
		DROP  Procedure  stp_Dialer_GetNextClient4DepositQueue
	END

GO

CREATE Procedure stp_Dialer_GetNextClient4DepositQueue
@Top int,
@ReasonId int
AS
Begin
Declare @daycount int set @daycount = 31	
Declare @mindate datetime set @mindate = dateadd(day, -@daycount, getdate())

Set RowCount @Top
Select distinct  cl.clientid, @ReasonId as ReasonId
from
(Select c.clientid, convert(varchar,c.clientid) + '-' + Right(convert(varchar, DateAdd(month,-1, getDate()), 110),7)    clientIdMoYr
From tblClient c
where c.currentclientstatusid not in (15,16,17,18) 
and c.multideposit = 1
) cl
left join
(Select distinct clientId
from tblregister
Where entrytypeId = 3
and transactiondate >= @mindate
) h on h.clientid = cl.clientId
left join
(Select distinct d.clientid
From tbldepositruleach r 
inner join tblclientdepositday d on d.clientdepositid = r.clientdepositid
Where r.depositamount = 0 and d.deletedDate is null
and DateAdd(month,-1, getDate()) between r.startDate and isnull(r.enddate,'2050-12-31')
) rs on rs.clientid = cl.clientid
left join 
(select d.callmadeid, d.retryafter, d.clientid 	from tbldialercall d
	inner join 
	(select max(callmadeid) as LastCallMadeId, clientid from tbldialercall	group by clientid) d1 on d.callmadeid = d1.lastcallmadeid) d2 on d2.clientId = cl.clientId
left join
(select r.callresolutionid, r.closed, r.expiration, r.fieldvalue as clientIdMoYr
from tbldialercallresolution r
inner join
	(select max(callresolutionid) as lastResolutionId, fieldValue
	from tbldialercallresolution
	Where reasonid = @ReasonId 
	group by fieldValue) r1 on r1.lastResolutionId = r.callresolutionId) r2 on r2.clientIdMoYr = cl.clientIdMoYr
Where 
h.clientid is null 
and rs.clientid is null	
and (d2.clientid is null or d2.retryafter < getdate())
and (r2.clientIdMoYr is null or (r2.closed = 0 and r2.expiration < getdate()))


Set RowCount 0
	
End

GO



