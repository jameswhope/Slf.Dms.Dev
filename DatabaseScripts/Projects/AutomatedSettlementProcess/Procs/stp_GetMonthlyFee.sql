IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetMonthlyFee') BEGIN
	DROP  Procedure  stp_GetMonthlyFee
END
GO

create procedure stp_GetMonthlyFee 
(
	@clientid int
)
as

declare 
	@monthlyfee money,
	@subsequentmaintfee money,
	@submaintfeestart datetime,
	@maintenancefeecap money


select 
	@monthlyfee = monthlyfee,
	@subsequentmaintfee = subsequentmaintfee,
	@submaintfeestart = submaintfeestart,
	@maintenancefeecap = maintenancefeecap
from 
	tblclient 
where
	clientid = @clientid


if (@maintenancefeecap is not null and @maintenancefeecap <> 0) begin
	select @monthlyfee = count(a.accountid) * @monthlyfee 
	from tblaccount a
	where a.clientid = @clientid
	and a.accountstatusid not in (55,171) -- Removed, NR
	and not (a.accountstatusid = 54 and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))
	
	if @monthlyfee > @maintenancefeecap begin
		select @monthlyfee = @maintenancefeecap
	end
end
else if (@subsequentmaintfee is not null and @subsequentmaintfee <> 0 and @submaintfeestart is not null) begin
	select @monthlyfee = @subsequentmaintfee
end


select isnull(@monthlyfee,0)