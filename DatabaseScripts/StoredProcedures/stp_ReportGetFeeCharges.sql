/****** Object:  StoredProcedure [dbo].[stp_ReportGetFeeCharges]    Script Date: 11/19/2007 15:27:43 ******/
DROP PROCEDURE [dbo].[stp_ReportGetFeeCharges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetFeeCharges]

as

select
	tblcommrec.commrecid,
	tblcommrec.display,
	tblentrytype.name as feetype,
	tblentrytype.entrytypeid,
	tblcommfeecharge.fixedamount
from
	tblcommrec inner join
	tblcommfeecharge on tblcommrec.commrecid=tblcommfeecharge.commrecid inner join
	tblentrytype on tblcommfeecharge.entrytypeid=tblentrytype.entrytypeid
GO
