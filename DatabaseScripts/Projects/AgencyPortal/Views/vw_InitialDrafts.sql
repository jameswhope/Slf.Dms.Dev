
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_InitialDrafts')
	BEGIN
		DROP  VIEW vw_InitialDrafts
	END
GO

create view vw_InitialDrafts as

select clientid, min(registerid) [RegisterID]
from tblregister
where entrytypeid = 3
group by clientid