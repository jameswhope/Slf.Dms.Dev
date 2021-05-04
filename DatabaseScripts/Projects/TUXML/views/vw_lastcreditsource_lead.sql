IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_lastcreditrequest_OK')
	BEGIN
		DROP  View vw_lastcreditrequest_OK
	END
GO

CREATE View vw_lastcreditrequest_OK AS
select  l.ssn, l.RequestDate, l.xmlfile, l.fileHitIndicator, l.flags, l.creditsourceid 
from (
select cr.RequestDate, cs.ssn, cs.xmlfile, cs.fileHitIndicator, cs.flags, cs.creditsourceid, ranked = rank() over (partition by cs.ssn order by cr.requestdate desc) 
from tblcreditsource cs 
join tblcreditreport cr on cr.reportid = cs.reportid
where len(ltrim(rtrim(isnull(cs.xmlfile,'')))) > 0 and isnull(cs.requeststatus,'') = 'OK'
) l
where l.ranked = 1
GO


