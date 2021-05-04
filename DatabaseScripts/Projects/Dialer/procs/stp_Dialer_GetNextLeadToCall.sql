IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextLeadToCall')
	BEGIN
		DROP  Procedure  stp_Dialer_GetNextLeadToCall
	END

GO

CREATE Procedure stp_Dialer_GetNextLeadToCall
@TopN int = 1 
AS
Begin

Declare @TotalMaxAttempt int
Declare @MaxAttemptDay int
Declare @CallStartDate Datetime
Declare @CriticalHours int Set @CriticalHours = 72

Select @TotalMaxAttempt = MaxAttempts, @MaxAttemptDay = MaxAttemptsPerDay, @CallStartDate =  CallStartDate  From tblDialerWorkGroupQueue
Where QueueName = 'CID Dialer Workgroup'

--Temporary version
select top 1  l.leadapplicantid, 
callorder = case 
				 when l.statusid = 16  then 0
				 else 1 
			end,
leadphone, homephone, cellphone, l.statusid, l.created, l.stateid
from tblleadapplicant l
join tblLeadProducts p on p.ProductID = l.ProductID
join tblLeadVendors v on v.VendorID = p.VendorID and v.Internal = 1
left join tblredoleads r on r.leadapplicantid = l.leadapplicantid
where 
--new, left message, no answer, recycled
(
	(l.statusid in (13, 15, 16, 17)
	and (@TotalMaxAttempt = 0 or 
	(Select Count(d.callmadeid) from vw_enrollment_CallsMade_Detail d 
	 where d.outboundcallkey is not null
	 and d.LeadApplicantId = l.leadapplicantId
	 and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	 ) < @TotalMaxAttempt)
	and (@MaxAttemptDay = 0 or 
	(Select Count(d.callmadeid) from vw_enrollment_CallsMade_Detail d 
	 where d.outboundcallkey is not null and convert(varchar(10),d.created,101) = convert(varchar(10),getdate(),101)
	and d.LeadApplicantId = l.leadapplicantId
	and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	) < @MaxAttemptDay)
	and (l.created > isnull(@CallStartDate, '2010-08-31') or isnull(l.DialerLastRecycled, '1900-01-01') > isnull(@CallStartDate, '2010-08-31'))
	and l.created > '2011-01-01'
	)
)
and (l.dialerretryafter is null or l.dialerretryafter < getdate())
and ((l.leadphone <> '(   )    -    ' and isnull(l.leadphone, '') <> '')
or (l.homephone <> '(   )    -    ' and isnull(l.homephone, '') <> '')
or (l.cellphone <> '(   )    -    ' and isnull(l.cellphone, '') <> ''))
and (l.productid not in (105))--160, 161, 162
--and not barker client
and l.companyid not in (6)
--call only new leads or with banking info
and (l.statusid = 16 or exists(select h.LeadHardShipId from tblleadhardship h
	 where isnull(h.bankaccount,'') in ('checking','savings', '', 'prepaid debit') and h.leadapplicantid = l.leadapplicantid)
	)
-- and not pending appointment
and not exists (select a.appointmentId from tblleadcallappointment a where a.leadapplicantId = l.leadapplicantid and a.appointmentstatusid in (0,4) and datediff(n, getdate(), AppointmentDate) > -60)  
order by 2 asc, l.created desc

/* --Normal version
--SET RowCount @TopN

select top 1 l.leadapplicantid, 
callorder = case when l.statusid = 16 and l.productid = 144 then 0 
				 when l.statusid = 16 and l.productid = 143 then 1 
				 when l.statusid = 16 and l.productid = 158 then 2
				 when l.statusid = 16 and l.productid = 159 then 3
				 when l.statusid = 16 and l.productid = 142 then 4 
				 when l.statusid <> 16 and l.productid = 144 and datediff(hh, l.created, getdate()) < @CriticalHours then 4 
				 when l.statusid <> 16 and l.productid = 143 and datediff(hh, l.created, getdate()) < @CriticalHours then 5
				 when l.statusid <> 16 and l.productid = 142 and datediff(hh, l.created, getdate()) < @CriticalHours then 6
 				 when l.statusid <> 16 and l.productid = 158 and datediff(hh, l.created, getdate()) < @CriticalHours then 7
				 when l.statusid <> 16 and l.productid = 159 and datediff(hh, l.created, getdate()) < @CriticalHours then 8
				 --when l.statusid <> 16 and l.productid = 144 and datediff(hh, l.created, getdate()) >= @CriticalHours then 9 
				 --when l.statusid <> 16 and l.productid = 143 and datediff(hh, l.created, getdate()) >= @CriticalHours then 10
				 --when l.statusid <> 16 and l.productid = 142 and datediff(hh, l.created, getdate()) >= @CriticalHours then 11
				 --when l.statusid in (3,6) then 11 
				 when l.statusid = 16 and l.productid = 146 then 13 
				 when l.statusid = 16 and l.productid = 147 then 14 
				 when l.statusid = 16 and l.productid = 145 then 15 
				 when l.statusid <> 16 and l.productid = 146 and datediff(hh, l.created, getdate()) < @CriticalHours then 16 
				 when l.statusid <> 16 and l.productid = 147 and datediff(hh, l.created, getdate()) < @CriticalHours then 17
				 when l.statusid <> 16 and l.productid = 145 and datediff(hh, l.created, getdate()) < @CriticalHours then 18
				 else 99 end,
 leadphone, homephone, cellphone, l.statusid, l.created from tblleadapplicant l
where 
--new, left message, no answer, recycled
(
	(l.statusid in (13, 15, 16, 17)
	and (@TotalMaxAttempt = 0 or 
	(Select Count(d.callmadeid) from tblleaddialercall d 
	 where d.outboundcallkey is not null
	 and d.LeadApplicantId = l.leadapplicantId
	 and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	 ) < @TotalMaxAttempt)
	and (@MaxAttemptDay = 0 or 
	(Select Count(d.callmadeid) from tblleaddialercall d 
	 where d.outboundcallkey is not null and convert(varchar(10),d.created,101) = convert(varchar(10),getdate(),101)
	and d.LeadApplicantId = l.leadapplicantId
	and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	) < @MaxAttemptDay)
	and (l.created > isnull(@CallStartDate, '2010-08-31') or isnull(l.DialerLastRecycled, '1900-01-01') > isnull(@CallStartDate, '2010-08-31'))
	)
-- await. signature, signed (once a day after 72 hrs)
or 
	(l.statusid in (3,6) and 
	datediff(hh,
	isnull(
	(select top 1 r.created from tblleadroadmap r 
    where r.leadapplicantid = l.leadapplicantid and r.leadstatusid in (3,6) 
    order by r.created desc), getdate()
	), getdate()
    ) > 72) 
)
and (l.dialerretryafter is null or l.dialerretryafter < getdate())
and ((l.leadphone <> '(   )    -    ' and isnull(l.leadphone, '') <> '')
or (l.homephone <> '(   )    -    ' and isnull(l.homephone, '') <> '')
or (l.cellphone <> '(   )    -    ' and isnull(l.cellphone, '') <> ''))
and (l.productid not in (105, 156))
--call only new leads with banking info
and (exists(select h.LeadHardShipId from tblleadhardship h
	 where h.bankaccount in ('checking','savings') and h.leadapplicantid = l.leadapplicantid)
	)
-- and not pending appointment
and not exists (select a.appointmentId from tblleadcallappointment a where a.leadapplicantId = l.leadapplicantid and a.appointmentstatusid in (0,4) and datediff(n, getdate(), AppointmentDate) > -60)  
order by 2 asc, l.created desc

--SET RowCount 0
*/

End