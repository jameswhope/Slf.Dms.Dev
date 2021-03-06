/****** Object:  StoredProcedure [dbo].[stp_ReportGetPayRates]    Script Date: 11/19/2007 15:27:43 ******/
DROP PROCEDURE [dbo].[stp_ReportGetPayRates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetPayRates]
	(
		@date as datetime = null,
		@companyid int = null
	)

as

if @date is null 
	set @date = getdate()

select
	tblagency.name as Agency,
	tblagency.agencyid,
	tblcommrec.abbreviation as CommRec,
	tblcommrec.commrecid,
	tblentrytype.displayname as FeeType,
	tblentrytype.entrytypeid,
	sum(tblcommfee.[Percent]) as [Percent]	
from
	tblagency inner join
	tblcommscen on tblcommscen.agencyid=tblagency.agencyid inner join
	tblcommstruct on tblcommstruct.commscenid=tblcommscen.commscenid inner join
	tblcommrec on tblcommstruct.commrecid=tblcommrec.commrecid inner join
	tblcommfee on tblcommstruct.commstructid=tblcommfee.commstructid inner join
	tblentrytype on tblentrytype.entrytypeid=tblcommfee.entrytypeid 
where
	tblcommscen.startdate<@date and (tblcommscen.enddate>@date or tblcommscen.enddate is null)
	and (@companyid is null or tblcommstruct.companyid = @companyid)
group by 
	tblagency.name, tblagency.agencyid, tblcommrec.abbreviation, tblcommrec.commrecid, tblentrytype.displayname, tblentrytype.entrytypeid	
order by
	tblagency.name, [FeeType], [CommRec]
	
GO
