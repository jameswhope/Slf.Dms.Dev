IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_clientfile_getLSAInfo')
	BEGIN
		DROP  Procedure  stp_clientfile_getLSAInfo
	END

GO

CREATE Procedure stp_clientfile_getLSAInfo
	(
		@clientid int 
	)

AS
BEGIN
	select 
		 [SetupFee] = convert(varchar,(c.SetupFeePercentage * 100)) + '%'
	, [SettlementFee] = convert(varchar,(c.SettlementFeePercentage * 100)) + '%'
	, [MaintenanceFee] = '$' + convert(varchar, CONVERT(money, c.MonthlyFee),1)
	, [SubsequentMaintenanceFee] = '$' + convert(varchar, CONVERT(money, isnull(c.SubsequentMaintFee,0.00)),1)
	, [AdditionalAccountFee] = '$' + convert(varchar, CONVERT(money, isnull(c.AdditionalAccountFee,0.00)),1)
	, [ReturnedCheckFee] = '$' + convert(varchar, CONVERT(money, isnull(c.returnedcheckfee,0.00)),1)
	, [OvernightDeliveryFee] = '$' + convert(varchar, CONVERT(money, isnull(c.OvernightDeliveryFee,0.00)),1)
	from 
		tblclient c
	where 
		clientid = @clientid
END


GRANT EXEC ON stp_clientfile_getLSAInfo TO PUBLIC



