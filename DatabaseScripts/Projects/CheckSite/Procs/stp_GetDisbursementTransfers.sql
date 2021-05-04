/*
if exists (select * from sysobjects where name = 'stp_GetDisbursementTransfers')
	drop procedure stp_GetDisbursementTransfers
go*/

create procedure stp_GetDisbursementTransfers
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
	jhernandez		10/29/09	New method for returning dispursement-to-foreign bank transfers 
								for batch processing.
*/


-- Get dispursement-to-foreign bank transfers
select 
	n.NachaRegisterId, n.NachaFileId, n.Amount, n.ShadowStoreId, 
	n.Name, n.RoutingNumber, n.AccountNumber, n.Type [AccountType], 
	e.DisplayName [Notes1],
	t.name [ControlledAccountName]
into #batch
from tblNachaRegister2 n
join tblRegister r on r.RegisterId = n.RegisterId
join tblEntryType e on e.EntryTypeId = r.EntryTypeId
join tblTrust t on t.TrustID = n.TrustID and t.trustid = 23
where n.NachaFileId = @NachaFileId 
and n.ispersonal = 1
 
 
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