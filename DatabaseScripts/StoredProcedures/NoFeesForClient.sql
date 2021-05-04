
Declare @ClientID int
Declare @AccountNumber int

set @AccountNumber = 6006252 

if @AccountNumber is not null
	begin
		select @ClientID = clientid from tblclient where accountnumber = @AccountNumber
	end
--********************************All Fees to 0
update tblclient set SetupFeePercentage = 0.00, 
SettlementFeePercentage = 0.00, 
MonthlyFee = 0.00, 
AdditionalAccountFee = 0.00, 
ReturnedCheckFee = 0.00, 
OvernightDeliveryFee = 0.00 
where clientid = @ClientID
--********************************Put fees back to where they were
--update tblclient set SetupFeePercentage = 0.08, 
--SettlementFeePercentage = 0.33, 
--MonthlyFee = 55.00, 
--AdditionalAccountFee = 35.00, 
--ReturnedCheckFee = 25.00, 
--OvernightDeliveryFee = 15.00 
--where clientid = @ClientID
--***********************************Maintenance fees only
--update tblclient set MonthlyFee = 0.00 
--where clientid = @ClientID
--*************************Weird stuff
--update tblclient set SettlementFeePercentage = 0.15 
--where clientid = @ClientID

select cl.accountnumber, pe.firstname, pe.lastname, setupfeepercentage, settlementfeepercentage, monthlyfee, additionalaccountfee, returnedcheckfee, overnightdeliveryfee from tblclient cl
inner join tblperson pe on pe.ClientID = cl.ClientID
where cl.clientid = @ClientID

