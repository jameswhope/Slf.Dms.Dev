IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getDocumentStatistics')
	BEGIN
		DROP  Procedure  stp_ClientFile_getDocumentStatistics
	END

GO

CREATE Procedure stp_ClientFile_getDocumentStatistics
(
	@CompanyID int,
	@end datetime,
	@OnlyMatters bit
)
as
BEGIN
/*
	declare @CompanyID int
	declare @OnlyMatters bit
	declare @end datetime
	set @CompanyID = 6
	set @OnlyMatters = 1
	set @end = '12/31/2010'
*/

	declare @start datetime

	select @start = min(created) from tblclient where companyid = @CompanyID	--get min client created date for company

	select DocTypeID,DisplayName,[TotalDocuments]=count(*)
	from
	(
		SELECT dr.DocTypeID, ISNULL(dt.DisplayName, 'NA') AS DisplayName
		FROM  tblDocRelation AS dr with(nolock) 
		INNER JOIN tblDocumentType AS dt with(nolock) ON dr.DocTypeID = dt.TypeID 
		INNER JOIN tblDocScan AS ds with(nolock) ON dr.DocID = ds.DocID 
		LEFT OUTER JOIN tblUser AS u with(nolock) ON u.UserID = ds.CreatedBy 
		INNER JOIN tblUserGroup AS ug with(nolock) ON ug.UserGroupId = u.UserGroupID 
		INNER JOIN tblClient c with(nolock) on c.ClientID = dr.ClientID 
		left JOIN tblmatter m with(nolock) on m.matterid = dr.relationid
		WHERE (dr.ClientID in (
		SELECT c.ClientID
		FROM tblClient AS c WITH (nolock) 
		INNER JOIN tblPerson AS p WITH (nolock) ON c.PrimaryPersonID = p.PersonID 
		INNER JOIN tblState AS s WITH (nolock) ON p.StateID = s.StateID 
		left join tblmatter m WITH (nolock) on m.clientid = c.clientid 
		inner join tblcompany co WITH (nolock) on co.companyid = c.companyid
		WHERE (c.companyid IN (@CompanyID)) and c.created between @start and @end and 
		case @OnlyMatters when 1 then case when m.mattertypeid in (1) then 1 else 0 end else 1 end=1
	)
	) AND (dr.DeletedFlag <> 1) and 
	case @OnlyMatters 
		when 1 then 
			case when relationtype in ('matter') and m.mattertypeid in (1) or dr.doctypeid in ('L0001','L0002','L0003','L0005','L0006','L1000','L1001') then 1 else 0 end
		else 1 end = 1
	) as docData
	group by DocTypeID,DisplayName
	Order by displayname 
	option (fast 100)

END

GRANT EXEC ON stp_ClientFile_getDocumentStatistics TO PUBLIC

GO


