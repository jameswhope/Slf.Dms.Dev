IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetVerificationCallsToAttach')
	BEGIN
		DROP  Procedure  stp_Vici_GetVerificationCallsToAttach
	END

GO

CREATE Procedure stp_Vici_GetVerificationCallsToAttach
@minminutes int = 3,
@maxdays int = 3
AS
select c.* 
from tblVerificationcall c
where c.completed = 1 
and c.vicifilename is not null 
and c.RecordedCallPath is null
and DateAdd(d,@maxdays,c.enddate) > GetDate()
and DateAdd(n,@minminutes,c.enddate) < GetDate()

GO

