IF EXISTS (SELECT * FROM sysobjects WHERE name = 'udf_FundsOnHold')
	BEGIN
		DROP  function  udf_FundsOnHold
	END
GO

create function [dbo].[udf_FundsOnHold] 
(
	@clientid int,
	@excludesettlementid int
) 
returns money
as
begin
-- Funds are on hold in between the time the client approves a settlement and the settlement gets paid.

-- Used for settlement calculations. Pass in the settlement id to exclude it from the calculations, otherwise pass in -1.

	declare @fundsonhold money

	select @fundsonhold = isnull(abs(sum(d.newamount)),0)
	from tbltask t
	join tblmattertask mt on mt.taskid = t.taskid
	join tblmatter m on m.matterid = mt.matterid 
		and m.clientid = @clientid
		and m.matterstatusid in (1,3) -- Open, Pending
	join tblsettlements s on s.matterid = m.matterid 
		and s.active = 1
		and s.settlementid <> @excludesettlementid
	join tblSettlement_AdjustedFeeDetail d on d.settlementid = s.settlementid 
		and d.isdeleted = 0
	join tblcreditorinstance ci on ci.creditorinstanceid = m.creditorinstanceid
	join tblaccount a on a.accountid = ci.accountid
	join tblaccountstatus at on at.accountstatusid = a.accountstatusid 
		and at.accountstatusid in (172) -- Settlement Pending
	where t.tasktypeid in (72,78) -- Client Approval
		and t.resolved is not null

		
	return @fundsonhold

end 