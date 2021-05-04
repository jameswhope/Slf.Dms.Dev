IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getAllMatterDocuments')
	BEGIN
		DROP  Procedure  stp_ClientFile_getAllMatterDocuments
	END

GO

CREATE Procedure stp_ClientFile_getAllMatterDocuments
	(
		@clientid int
	)
AS
BEGIN
	select 
		DocTypeID
		,DisplayName
		, Received
		, Created
		, Createdby
		, pdfPath
		,rowNum
	from
	(
		SELECT     
			DocOrder = CASE 
				WHEN CHARINDEX('Power of Attorney', dt.DisplayName) > 0 THEN 
					1 
				ELSE 
					CASE WHEN CHARINDEX('Legal Service Agreement', dt.DisplayName) > 0 THEN 2 ELSE 999 END 
			END 
			, dr.DocTypeID
			, ISNULL(dt.DisplayName, 'NA') AS DisplayName
			, ISNULL(ds.ReceivedDate, '01-01-1900') AS Received
			, ISNULL(ds.Created, '01-01-1900') AS Created
			, ISNULL(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, 'NA') AS CreatedBy
			, '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.accountnumber + case when dr.subfolder is null or dr.subfolder in ('ClientDocs','') then '\ClientDocs\' when dr.subfolder in ('\') then '\CreditorDocs\' else '\CreditorDocs\' + dr.subfolder end + c.accountnumber + '_' + dr.Doctypeid + '_' + dr.DocID + '_' + dr.DateString + '.pdf'[pdfPath]
			, row_number() over(partition by DisplayName order by ISNULL(ds.ReceivedDate, '01-01-1900') ) as rowNum
		FROM  
			tblDocRelation AS dr with(nolock) INNER JOIN
			tblDocumentType AS dt with(nolock) ON dr.DocTypeID = dt.TypeID INNER JOIN
			tblDocScan AS ds with(nolock) ON dr.DocID = ds.DocID LEFT OUTER JOIN
			tblUser AS u with(nolock) ON u.UserID = ds.CreatedBy INNER JOIN
			tblUserGroup AS ug with(nolock) ON ug.UserGroupId = u.UserGroupID inner join
			tblClient c with(nolock) on c.ClientID = dr.ClientID	inner join 
			tblmatter m with(nolock) on m.matterid = dr.relationid
		WHERE     (dr.ClientID = @clientid) AND (dr.DeletedFlag <> 1) and ((relationtype in ('matter')) and m.mattertypeid in (1,2) or dr.doctypeid in ('L0001','L0002','L0003','L0005','L0006','L1000','L1001'))
	) as docData
	where rownum = 1
	Order by created 
END

GO


GRANT EXEC ON stp_ClientFile_getAllMatterDocuments TO PUBLIC

GO


