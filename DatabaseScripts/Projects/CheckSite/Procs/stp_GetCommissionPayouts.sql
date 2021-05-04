
if exists (select * from sysobjects where name = 'stp_GetCommissionPayouts')
	drop procedure stp_GetCommissionPayouts
go

create procedure stp_GetCommissionPayouts
(
	@Date datetime
,	@EffectiveDate datetime
,	@NachaFileId int = -1
,	@NachaRegisterId int = -1
)
as
begin
/*
	History:
	jhernandez		06/20/08	New method for returning commission payouts for batch processing
	jhernandez		06/25/08	Remove filtering items created today. If CheckSite's system
								is unavailable we'll want to send items out on next 
								attempt.
	jhernandez		07/24/08	Optional parameters @NachaFileId and @NachaRegisterId
								used for re-sending a batch.
	jhernandez		11/18/08	Use company-specific controlled account name
	jhernandez		07/28/09	Include credits into the GCA from converted clients' orig trust account.
								For when payments are voided that processed through Colonial.
*/


-- Get commission payouts
select n.NachaRegisterId, n.NachaFileId, n.Amount, n.Name, n.RoutingNumber,
	n.AccountNumber, n.Type [AccountType], n.IsPersonal, c.ControlledAccountName, 
	'Commission payout' [Notes1], n.Flow
into #batch
from tblNachaRegister2 n
join tblCompany c on c.CompanyID = n.CompanyID
join tblCommRec r on r.CommRecId = n.CommRecId
where n.NachaFileId = @NachaFileId 
 and len(n.RoutingNumber) = 9


insert #batch (NachaRegisterId,NachaFileId,Amount,Name,RoutingNumber,AccountNumber,AccountType,IsPersonal,ControlledAccountName,Notes1,Flow)
select n.NachaRegisterId, n.NachaFileId, n.Amount, n.Name, n.RoutingNumber,
	n.AccountNumber, n.Type [AccountType], n.IsPersonal, c.ControlledAccountName, 
	'GCA Credit' [Notes1], n.Flow
from tblNachaRegister2 n
join tblCompany c on c.CompanyID = n.CompanyID
join tblRegisterPayment rp on rp.RegisterPaymentID = n.RegisterPaymentID
where n.NachaFileId = @NachaFileId 
 and len(n.RoutingNumber) = 9	
 
 
 -- Only create nacha file id if batch has records and is not a re-send
if (exists (select 1 from #batch)) and (@NachaFileId = -1) begin
	insert tblNachaFile ([Date],EffectiveDate) values (@Date,@EffectiveDate)
	select @NachaFileId = scope_identity()

	update #batch set NachaFileId = @NachaFileId
	update tblNachaRegister2 set NachaFileId = @NachaFileId where NachaRegisterId in (select NachaRegisterId from #batch)
end


-- output
select * 
from #batch 
where NachaRegisterId >= @NachaRegisterId
order by NachaRegisterId

-- cleanup
drop table #batch  


end