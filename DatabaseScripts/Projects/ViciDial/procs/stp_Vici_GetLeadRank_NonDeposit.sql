IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetLeadRank_NonDeposit')
	BEGIN
		DROP  Procedure stp_Vici_GetLeadRank_NonDeposit
	END
GO

CREATE PROCEDURE stp_Vici_GetLeadRank_NonDeposit 
@LeadId int
AS
/*
Calculate rank 
if no called
	1
else
	least Call Count
	least LastCalled
*/
declare @rank int

Select 
@rank =  
case when (isnull(m.dialercount, 0) = 0) then 1 
else 
cast(right(Convert(varchar(8),isnull(v.latestcall, '100000'),112),6) + replace(Convert(varchar(5),isnull(v.latestcall, '0000'),108),':','') as int)
end
from tblmatter m 
left join  vw_Vici_MatterLog v on v.matterid = m.matterid
where  m.mattertypeid = 5
and m.matterid = @LeadId

select isnull(@rank, 9999) as [rank]

GO

