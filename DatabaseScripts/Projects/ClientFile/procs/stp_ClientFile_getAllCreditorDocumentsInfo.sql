IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getAllCreditorDocumentsInfo')
	BEGIN
		DROP  Procedure  stp_ClientFile_getAllCreditorDocumentsInfo
	END

GO

CREATE Procedure stp_ClientFile_getAllCreditorDocumentsInfo
(
@clientid int
)
as 
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
			, '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.accountnumber + case when dr.subfolder is null or dr.subfolder = 'ClientDocs' then '\ClientDocs\' else '\CreditorDocs\' + dr.subfolder end + c.accountnumber + '_' + dr.Doctypeid + '_' + dr.DocID + '_' + dr.DateString + '.pdf'[pdfPath]
			, row_number() over(partition by DisplayName order by ISNULL(ds.ReceivedDate, '01-01-1900') ) as rowNum
		FROM  
			tblDocRelation AS dr INNER JOIN
			tblDocumentType AS dt ON dr.DocTypeID = dt.TypeID INNER JOIN
			tblDocScan AS ds ON dr.DocID = ds.DocID LEFT OUTER JOIN
			tblUser AS u ON u.UserID = ds.CreatedBy INNER JOIN
			tblUserGroup AS ug ON ug.UserGroupId = u.UserGroupID inner join
			tblClient c on c.ClientID = dr.ClientID
		WHERE     (dr.ClientID = @clientid) AND (dr.DeletedFlag <> 1) and (relationtype in ('account'))
	) as docData
	Order by created 
END

GRANT EXEC ON stp_ClientFile_getAllCreditorDocumentsInfo TO PUBLIC

GO


