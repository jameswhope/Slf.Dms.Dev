 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_Vici_MatterLog')
	BEGIN
		DROP  View vw_Vici_MatterLog
	END
GO

CREATE View vw_Vici_MatterLog AS
select ml.matterid, ml.reasonid, oldestcall = min(cl.created), latestcall = max(cl.created),
count=count(ml.matterdialerlogid)
from tblmatterdialerlog ml
join tblastcalllog cl on ml.primarycallmadeid = cl.callid
where ml.created > '2014-05-16'
group by  ml.matterid, ml.reasonid


GO
