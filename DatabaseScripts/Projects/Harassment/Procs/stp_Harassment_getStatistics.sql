IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Harassment_getStatistics')
	BEGIN
		DROP  Procedure  stp_Harassment_getStatistics
	END

GO

CREATE Procedure stp_Harassment_getStatistics
AS
BEGIN
SELECT 
	[DateSubmitted]=convert(varchar(10),DateFormSubmitted,111) 
	,[Firm]=firmname
	,[NumberOfIntake]=count(*)
	,[NumberOfDecline]= sum(case when StatusDescription = 'Decline Letter' then 1 else 0 end)
	,[NumberOfDemand]= sum(case when StatusDescription = 'Demand Letter' then 1 else 0 end) 
from (
		SELECT  
		DateFormSubmitted
		, hsr.StatusDescription
		, [FirmName] = co.name 
		FROM tblHarassmentClient AS hc with(nolock) 
		INNER JOIN tblHarassmentStatusReasons AS hsr with(nolock) ON hsr.HarassmentStatusID = hc.HarassmentStatusID 
		LEFT OUTER JOIN tblHarassmentDeclineReasons AS hdr with(nolock) ON hdr.HarassmentDeclineReasonID = hc.HarassmentDeclineReasonID 
		INNER JOIN tblclient c with(nolock)  on c.clientid = hc.clientid 
		INNER JOIN tblDocRelation AS dr with(nolock) ON c.ClientID = dr.ClientID 
		INNER JOIN tblAccount AS a ON hc.CreditorAccountID = a.AccountID 
		INNER JOIN tblCompany co with(nolock) on c.companyid= co.companyid 
		where dr.relationid = hc.creditoraccountid  
		and dr.docid = hc.documentid 
		and convert(varchar(12),dr.relateddate,101) = convert(VARCHAR(12),hc.created,101)
		AND (dr.DeletedFlag = 0)	
		and dr.DocTypeID = 'D8008' 
	) as searchData 
where 
	year(DateFormSubmitted) > 2009  
GROUP BY
	convert(varchar(10),DateFormSubmitted,111) ,firmname 
ORDER BY 
	convert(varchar(10),DateFormSubmitted,111) desc ,firmName DESC 
OPTION (FAST 100) 



END

GO


GRANT EXEC ON stp_Harassment_getStatistics TO PUBLIC

GO


