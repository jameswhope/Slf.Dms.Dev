IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetLeadPhoneList')
	BEGIN
		DROP  Procedure  stp_GetLeadPhoneList
	END
GO

create procedure stp_GetLeadPhoneList
(
	@ForDate datetime
)
as
begin

select p.LeadPhoneListID, m.market, s.Source, p.Phone, p.Budget, p.Actual, (p.Budget - p.Actual) [Diff], p.LastModified, u.Username [LastModifiedBy]
from tblLeadPhoneList p
join tblLeadSource s on s.LeadSourceID = p.LeadSourceID
join tblLeadMarket m on m.LeadMarketID = s.LeadMarketID
join tblUser u on u.UserID = p.LastModifiedBy
where p.ForDate = @ForDate
	and p.Deleted = 0
order by m.Market, s.Source


end
go 