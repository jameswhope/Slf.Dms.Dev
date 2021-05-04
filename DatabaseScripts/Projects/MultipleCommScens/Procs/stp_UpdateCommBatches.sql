
if exists (select * from sysobjects where name = 'stp_UpdateCommBatches')
	drop procedure stp_UpdateCommBatches
go

create procedure stp_UpdateCommBatches
(
	@agencyid int, 
	@companyid int, 
	@oldcommrecid int, 
	@newcommrecid int,
	@startdate datetime, 
	@enddate datetime
)
as
begin

declare @oldcommstructid int, @newcommstructid int, @mincommbatchid int


select @oldcommstructid = cs.commstructid
from tblcommstruct cs
join tblcommscen s on s.commscenid = cs.commscenid
	and s.agencyid = @agencyid
where cs.companyid = @companyid
	and cs.commrecid = @oldcommrecid


select @newcommstructid = cs.commstructid
from tblcommstruct cs
join tblcommscen s on s.commscenid = cs.commscenid
	and s.agencyid = @agencyid
where cs.companyid = @companyid
	and cs.commrecid = @newcommrecid


-- only batches since we started pushing funds to the new commrec should be updated
select @mincommbatchid  = min(commbatchid)
from tblcommbatchtransfer
where commrecid = @newcommrecid


update tblcommpay
set commstructid = @newcommstructid
from tblcommpay cp
join tblregisterpayment rp on rp.registerpaymentid = cp.registerpaymentid
join tblregister r on r.registerid = rp.feeregisterid
join tblclient c on c.clientid = r.clientid
	and c.created between @startdate and @enddate
where cp.commbatchid >= @mincommbatchid
	and cp.commstructid = @oldcommstructid


update tblcommchargeback
set commstructid = @newcommstructid
from tblcommchargeback cb
join tblregisterpayment rp on rp.registerpaymentid = cb.registerpaymentid
join tblregister r on r.registerid = rp.feeregisterid
join tblclient c on c.clientid = r.clientid
	and c.created between @startdate and @enddate
where cb.commbatchid >= @mincommbatchid
	and cb.commstructid = @oldcommstructid


end