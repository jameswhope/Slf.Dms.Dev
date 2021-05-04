IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetLastCalls')
	BEGIN
		DROP  Procedure  stp_Dialer_GetLastCalls
	END

GO

CREATE Procedure stp_Dialer_GetLastCalls
@UserId int
AS
Select top 5 a.* from (
Select distinct d.CallMadeId, d.ClientId, l.eventdate, isnull(p.firstname,'') + ' ' + isnull(p.LastName, '') as FullName
From tblDialerCall d
Inner join tblCallLog l on l.callidkey = d.callidkey
Inner join tblperson  p on p.clientid = d.clientid and p.relationship = 'prime'
Where l.eventby = @UserId
and l.eventname = 'pickup'
) a
order by a.eventdate desc
GO



