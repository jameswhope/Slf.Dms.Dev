IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_paymentschedule_ordered')
	BEGIN
		DROP  View vw_paymentschedule_ordered
	END
GO

CREATE View vw_paymentschedule_ordered AS
select ps.*, 
[order] = row_number() over (partition by ps.settlementid order by ps.pmtdate, ps.created) 
from tblPaymentSchedule ps
where deleted is null

GO


