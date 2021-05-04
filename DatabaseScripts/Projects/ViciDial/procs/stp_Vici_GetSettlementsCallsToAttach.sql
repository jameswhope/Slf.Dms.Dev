IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetSettlementCallsToAttach')
	BEGIN
		DROP  Procedure  stp_Vici_GetSettlementCallsToAttach
	END

GO

CREATE Procedure stp_Vici_GetSettlementCallsToAttach
@minminutes int = 3,
@maxdays int = 3
AS
select c.* 
from tblsettlementrecordedcall c
join tblcallrecording r on c.recid = r.recid 
where c.completed = 1 
and r.recFile is  null
and c.vicifilename is not null 
and DateAdd(d,@maxdays,c.enddate) > GetDate()
and DateAdd(n,@minminutes,c.enddate) < GetDate()

GO

 

