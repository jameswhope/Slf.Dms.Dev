
if exists (select * from sysobjects where name = 'stp_GetClientDeposits')
	drop procedure stp_GetClientDeposits
go

create procedure stp_GetClientDeposits
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
	jhernandez		06/20/08	New method for returning client deposits for batch processing
	jhernandez		06/25/08	Remove filtering items created today. If CheckSite's system
								is unavailable we'll want to send items out on next 
								attempt.
	jhernandez		07/02/08	Include SDA balance transfer deposits
	jhernandez		07/09/08	Order by NachaRegisterId
	jhernandez		07/21/08	Added Flow and Reverse deposits
	jhernandez		07/24/08	Optional parameters @NachaFileId and @NachaRegisterId
								used for re-sending a batch.	
*/


-- Get deposits
select n.NachaRegisterId, n.NachaFileId, n.Amount, n.ShadowStoreId, 
	n.Name, n.RoutingNumber, n.AccountNumber, n.Type [AccountType], n.IsPersonal,
	case when r.AccountID is null then e.DisplayName 
		else e.DisplayName + ' for Account ' + convert(varchar(50), r.AccountID) 
	end [Notes1],
	n.Flow
into #batch
from tblNachaRegister2 n
join tblRegister r on r.RegisterId = n.RegisterId
join tblEntryType e on e.EntryTypeId = r.EntryTypeId
 and e.EntryTypeId in (3,45,47) -- Deposit, Transfer deposit, Reverse deposit
where n.NachaFileId = @NachaFileId
 and len(n.RoutingNumber) = 9
 and n.RegisterPaymentId is null
 
 
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