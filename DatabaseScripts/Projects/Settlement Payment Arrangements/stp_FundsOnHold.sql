IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = '[stp_FundsOnHold]')
	BEGIN
		DROP  Procedure  [stp_FundsOnHold]
	END

GO

CREATE Procedure [stp_FundsOnHold]
(
	@clientid int,
    @excludesettlementid int = 0
) 
as
begin
-- Funds are on hold in between the time the client approves a settlement and the settlement gets paid.

-- Used for settlement calculations. Pass in the settlement id to exclude it from the calculations, otherwise pass in -1.

-- First determine if there is a settlement payment arrangement
-- Test*********************************
--DECLARE @clientid int
--DECLARE @excludesettlementid int
--set @clientid = 25889
-- End Test****************************


SELECT ps.SettlementID, ps.PmtAmount 
INTO #PaymentArrangements 
FROM tblSettlements s
JOIN tblPaymentSchedule ps on ps.SettlementID = s.SettlementID 
WHERE s.ClientID = @clientid 
AND s.Status = 'A' 
AND s.IsPaymentArrangement = 1 
AND ps.pmtDate >= getdate()
AND ps.pmtdate <= dateadd(month, 1, getdate())

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
		and at.accountstatusid in (172, 173) -- Settlement Pending or payment arrangement
	where t.tasktypeid = 72 -- Client Approval
		and t.resolved is not null

		SET @fundsonhold = @fundsonhold + isnull((SELECT sum(pmtamount) from #PaymentArrangements),0)
		DROP table #paymentarrangements
		
	SELECT @fundsonhold

end
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

