IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementInformation')
	BEGIN
		DROP  Procedure  stp_GetSettlementInformation
	END
GO

CREATE Procedure [dbo].[stp_GetSettlementInformation]
(
	@SettlementId int
)
AS BEGIN
-- History
-- 8/12/10	jh	Settlement amounts calculated dynamically.
-- 8/19/10	jh	Factor in funds on hold for any pending settlements except this one
-- 9/9/2014 op  Factor Down Payment	for Payment Arrangements
declare @clientid int, @fundsonhold money, @availablesda money, @downpayment money, @ispaymentarrangement bit, @settlementamount money, @paymentamount money

select @clientid = c.clientid, @availablesda = c.availablesda, @ispaymentarrangement = s.ispaymentarrangement, @settlementamount = s.settlementamount
from tblsettlements s
join tblclient c on c.clientid = s.clientid
where s.settlementid = @settlementid

set @fundsonhold = dbo.udf_FundsOnHold(@clientid, @settlementid)
set @availablesda = @availablesda - @fundsonhold

if @ispaymentarrangement = 1 
Begin
	select top 1 @downpayment = pmtamount from tblpaymentschedule
	where settlementid = @settlementid and deleted is null
	order by  pmtdate, created
	
	if @downpayment is null
		RAISERROR('First scheduled payment of arrangement not found',16,1)
	else
		select @paymentamount = @downpayment
end
else
	select @paymentamount = @settlementamount

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
	s.SettlementPercent, 
	s.SettlementAmount,
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
	s.SettlementDueDate, 
	s.SettlementSavings, 
	s.SettlementFee,
	isnull(s.AdjustedSettlementFee, 0) AS AdjustedSettlementFee,
	isnull(s.SettlementFeeCredit, 0) as SettlementFeeCredit,
	isnull(s.OvernightDeliveryAmount, 0) AS OvernightDeliveryAmount,
	DeliveryAmount,
	isnull(s.DeliveryMethod, 'Check') AS DeliveryMethod, 
	s.SettlementCost, 
	case 
		when @availablesda - @paymentamount - s.SettlementCost > 0 then s.SettlementCost 
		else @availablesda - @paymentamount 
	end [SettlementFeeAmtAvailable], 
	case 
		when @availablesda - @paymentamount - s.SettlementCost > 0 then s.SettlementCost 
		when @availablesda - @paymentamount > 0 then @availablesda - @paymentamount
		else 0
	end [SettlementFeeAmtBeingPaid], 
	case 
		when @availablesda - @paymentamount - s.SettlementCost > 0 then 0
		else abs(@availablesda - @paymentamount - s.SettlementCost)
	end [SettlementFeeAmtStillOwed], 
	s.IsRestrictiveEndorsement, 
	m.MatterSubStatusId,
	m.MatterStatusCodeId,
	s.MatterId,
	msc.MatterStatusCode,
	mss.MatterSubStatus,
	ss.specialinstructions,
	a.currentamount,
	a.originalamount,
	c.created,
	s.ispaymentarrangement,
	@downpayment [DownPayment]
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

GO