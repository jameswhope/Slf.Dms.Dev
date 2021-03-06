/****** Object:  StoredProcedure [dbo].[stp_ReportGetCommissionBatches]    Script Date: 11/19/2007 15:27:41 ******/
DROP PROCEDURE [dbo].[stp_ReportGetCommissionBatches]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetCommissionBatches]
(
	@date1 datetime,
	@date2 datetime,
	@CompanyID int
)
as

select cb.commbatchid, nr.name [AgencyName], cbt.CommRecID, sum(cbt.amount) [Amount]
from tblnacharegister nr
join tblnachacabinet nc on nc.nacharegisterid = nr.nacharegisterid
	and nc.type = 'CommBatchTransferID'
join tblcommbatchtransfer cbt on cbt.commbatchtransferid = nc.typeid
join tblcommbatch cb on cb.commbatchid = cbt.commbatchid
	and cb.batchdate between @date1 and dateadd(dd,1,@date2)
where nr.amount > 0
	and cbt.amount <> 0
	and nr.nachafileid > 0
	and nr.companyid = @companyid
	and nr.name not like '%General Clearing Account%'
group by cb.commbatchid, nr.name, cbt.CommRecID
order by nr.name
