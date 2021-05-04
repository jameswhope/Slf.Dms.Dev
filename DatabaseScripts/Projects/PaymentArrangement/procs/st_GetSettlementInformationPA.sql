IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementInformationPA')
	BEGIN
		DROP  Procedure  stp_GetSettlementInformationPA
	END
GO

CREATE Procedure [dbo].[stp_GetSettlementInformationPA]
(
	@PmtScheduleId int
)
AS BEGIN
declare @settlementid int, @clientid int, @fundsonhold money, @availablesda money, @duedate datetime, @settlementamount money, @paymentamount money, @settfees money, @settfeespaid money, @settfeesowed money, @totalpaid money, @creditoraccountid int, @settlementcost money, @deliveryfee money

select @settlementid = ps.settlementid, @clientid = c.clientid, @availablesda = c.availablesda, @settlementamount = s.settlementamount, @duedate = ps.pmtdate, @paymentamount = pmtamount, @creditoraccountid = s.creditoraccountid, @deliveryfee = isnull(s.DeliveryAmount, 0) 
from tblpaymentschedule ps
join tblsettlements s on ps.settlementid = s.settlementid
join tblclient c on c.clientid = s.clientid
where ps.PmtScheduleId = @PmtScheduleId

select @totalpaid = sum(ps.pmtamount) from tblpaymentschedule ps where ps.settlementid = @settlementid and ps.deleted is null and ps.registerid is not null

/* if we want to get the value directly from register
select @totalpaid = sum(r.amount) from tblregister r where r.accountid = @creditoraccountid and r.bounce is null and r.void is null and r.entrytypeid = 18
*/

select @settfees = sum(r.amount)
from tblregister r  
where r.entrytypeid = 4 
and r.accountid = @creditoraccountid
and r.void is null and r.bounce is null

select @settfeespaid = sum(rp.amount)
from tblregisterpayment rp
join tblregister r on r.registerid = rp.feeregisterid
where r.entrytypeid = 4 
and r.accountid = @creditoraccountid
and r.void is null and r.bounce is null
and rp.voided = 0 and rp.bounced = 0  

set @settfeesowed = (-1*(isnull(@settfees,0))) - isnull(@settfeespaid,0)
set @settlementcost = @settfeesowed + @deliveryfee
set @fundsonhold = dbo.udf_FundsOnHold(@clientid, @settlementid)
set @availablesda = @availablesda - @fundsonhold

SELECT	
	s.SettlementID, 
	s.CreditorAccountID,
	s.ClientID, 
	@availablesda [RegisterBalance],
	c.SDABalance,
	c.PFOBalance,
	c.BankReserve,
	@fundsonhold [FrozenAmount], 
	s.CreditorAccountBalance,
	s.SettlementAmount,
	@paymentamount [PaymentAmount],
	isnull(@totalpaid,0) as TotalPaidToCreditor,
	case 
	when s.SettlementAmount - isnull(@totalpaid,0) < 0 then 0
	else s.SettlementAmount - isnull(@totalpaid,0)	
	end [TotalStillOwedToCreditor],
	case 
		when @availablesda - @paymentamount > 0 then @paymentamount 
		else @availablesda 
	end [SettlementAmtAvailable], 
	case 
		when @availablesda - @paymentamount > 0 then @paymentamount 
		when @availablesda > 0 then @availablesda 
		else 0 
	end [SettlementAmtBeingSent], 
	case 
		when @availablesda - @paymentamount > 0 then 0 
		else abs(@availablesda - @paymentamount)
	end [SettlementAmtStillOwed], 
	@duedate [PaymentDueDate], 
	--s.SettlementFee,
	-1 * isnull(@settfees, 0) [SettlementFee],
	isnull(s.AdjustedSettlementFee, 0) AS AdjustedSettlementFee,
	isnull(s.SettlementFeeCredit, 0) as SettlementFeeCredit,
	isnull(@settfeespaid, 0) as SettlementFeesPaid,
	@settfeesowed as SettlementFeesOwed,
	@deliveryfee AS OvernightDeliveryAmount,
	DeliveryAmount,
	isnull(s.DeliveryMethod, 'Check') AS DeliveryMethod, 
	--s.SettlementCost, 
	@settlementcost as SettlementCost,  
	case 
		when @availablesda - @paymentamount - @settlementcost > 0 then @settlementcost 
		else @availablesda - @paymentamount 
	end [SettlementFeeAmtAvailable], 
	case 
		when @availablesda - @paymentamount - @settlementcost > 0 then @settlementcost 
		when @availablesda - @paymentamount > 0 then @availablesda - @paymentamount
		else 0
	end [SettlementFeeAmtBeingPaid], 
	case 
		when @availablesda - @paymentamount - @settlementcost > 0 then 0
		else abs(@availablesda - @paymentamount - @settlementcost)
	end [SettlementFeeAmtStillOwed], 
	m.MatterSubStatusId,
	m.MatterStatusCodeId,
	s.MatterId,
	msc.MatterStatusCode,
	mss.MatterSubStatus,
	ss.specialinstructions,
	a.currentamount,
	a.originalamount,
	c.created,
	a.accountid
FROM 
	tblSettlements as s inner join 
	tblClient c on c.ClientId = s.ClientId inner join
	tblMatter m on m.MatterId = s.MatterId inner join
	tblMatterSubStatus mss on mss.MatterSubStatusId = m.MatterSubStatusId inner join
	tblMatterStatusCode msc on msc.MatterStatusCodeId = m.MatterStatusCodeId 
	left join tblsettlements_specialinstructions ss with(nolock) on ss.settlementid = s.settlementid
	inner join tblaccount a on a.accountid = s.creditoraccountid
WHERE 
	s.SettlementID = @SettlementId


		
END