IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetNotMappedPlannedDeposits')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetNotMappedPlannedDeposits
	END

GO

CREATE Procedure stp_NonDeposit_GetNotMappedPlannedDeposits
@Date datetime
AS
Select p.* 
from tblplanneddeposit p
left join tblplanneddepositregisterxref x on p.planid = x.planid
left join tblnondeposit n on p.planid = n.planid
where x.planid is null
and n.planid is null
and p.expecteddepositamount > 0
and convert(varchar(10), p.scheduleddate, 101) = convert(varchar(10), getdate(), 101)
GO

 

