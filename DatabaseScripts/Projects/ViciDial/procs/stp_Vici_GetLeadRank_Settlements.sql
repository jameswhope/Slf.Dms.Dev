IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetLeadRank_Settlements')
	BEGIN
		DROP  Procedure stp_Vici_GetLeadRank_Settlements
	END
GO

CREATE PROCEDURE stp_Vici_GetLeadRank_Settlements 
@LeadId int
AS
/*
Calculate rank 
if no called
	sooner DueDate
else
	least LastCalled
--	least Call Count
--	sooner DueDate
*/
declare @rank int

Select @rank =  
case when (isnull(m.dialercount, 0) = 0) then 1 + case when datediff(d, Getdate(), s.SettlementDueDate) < 0 then 0 else datediff(d, Getdate(), s.SettlementDueDate) end
else 
cast(right(Convert(varchar(8),isnull(v.latestcall, '100000'),112),6) + replace(Convert(varchar(5),isnull(v.latestcall, '0000'),108),':','') as int)
end
from tblsettlements s 
join tblmatter m on s.matterid = m.matterid
left join  vw_Vici_MatterLog v on v.matterid = m.matterid
where s.matterid =  @LeadId

select isnull(@rank, 9999) as [rank]

GO

