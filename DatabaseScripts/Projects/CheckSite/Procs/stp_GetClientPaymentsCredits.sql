
if exists (select * from sysobjects where name = 'stp_GetClientPaymentsCredits')
	drop procedure stp_GetClientPaymentsCredits
go

create procedure stp_GetClientPaymentsCredits
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
	jhernandez		06/20/08	New method for returning client payments for batch processing
	jhernandez		06/25/08	Remove filtering items created today. If CheckSite's system
								is unavailable we'll want to send items out on next 
								attempt.
	jhernandez		07/09/08	Order by NachaRegisterId
	jhernandez		07/15/08	Also return credits (voided transactions that will credit
								the clients' shadow store). Also renamed proc from
								stp_GetClientPayments to stp_GetClientPaymentsCredits.
	jhernandez		07/24/08	Optional parameters @NachaFileId and @NachaRegisterId
								used for re-sending a batch.	
	jhernandez		11/18/08	Use tblNachaRegister2.Name for ControlledAccountName
*/


-- Get client payments and credits
select 
	n.NachaRegisterId, n.NachaFileId, n.Amount, n.ShadowStoreId,
	n.Name [ControlledAccountName], 
	case when r.AccountID is null then e.DisplayName else e.DisplayName + ' for Account ' + convert(varchar(50), r.AccountID) end [Notes1],
	n.Flow
into #batch
from tblNachaRegister2 n
join tblRegister r on r.RegisterId = n.RegisterId
left join tblRegisterPayment p on p.RegisterPaymentId = n.RegisterPaymentId -- left join needed to pickup settlement payments
join tblEntryType e on e.EntryTypeId = r.EntryTypeId
join tblTrust t on t.TrustID = n.TrustID
where n.NachaFileId = @NachaFileId 
and n.accountnumber is null
 
 
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