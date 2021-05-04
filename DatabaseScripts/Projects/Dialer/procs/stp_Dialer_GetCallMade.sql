IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetCallMade')
	BEGIN
		DROP  Procedure  stp_Dialer_GetCallMade
	END

GO

CREATE Procedure stp_Dialer_GetCallMade
@CallMadeId int
AS
select c.clientid, 
lastphone = isnull(ph.areacode,'') + isnull(ph.number,''), 
dialerName = w.queuename,
reasonid = c.reasonid,
primarycallmadeid = isnull(c.primarycallmadeid, c.callmadeid)
from tbldialercall c
inner join tblphone ph on ph.phoneid = c.phoneid
inner join tbldialerworkgroupqueue w on w.queueid = c.workgroupqueueid
where c.callmadeid = @callmadeid

GO

 

