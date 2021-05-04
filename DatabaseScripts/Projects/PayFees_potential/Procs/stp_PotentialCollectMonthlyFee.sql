
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PotentialCollectMonthlyFee')
	BEGIN
		DROP Procedure stp_PotentialCollectMonthlyFee
	END
GO 

create procedure stp_PotentialCollectMonthlyFee
(
	@fordate datetime
)
as
begin

declare @feemonth int
declare @feeyear int

set @feemonth = datepart(month,@fordate)
set @feeyear = datepart(year,@fordate)

insert tblpotentialregistertmp 
	(clientid,transactiondate,amount,isfullypaid,entrytypeid,entrytypeorder,fee,feemonth,feeyear)
select 
	clientid,@fordate,-monthlyfee,0,1,4,1,@feemonth,@feeyear
from 
	tblclient 
where
	currentclientstatusid not in (15,17,18) and 
	(
		@fordate >= monthlyfeestartdate or
		monthlyfeestartdate is null
	)
	--and fee has not already been assessed for this month
	and not clientid in (select clientid from tblpotentialregistertmp where feemonth=@feemonth and feeyear=@feeyear)
	and not monthlyfee is null
	and not monthlyfee = 0
	and depositday = datepart(day,@fordate) --only clients on this deposit day

	
end
GO
 