IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Matters_GetAttachmentsForRelation')
	BEGIN
		DROP  Procedure  stp_Matters_GetAttachmentsForRelation
	END

GO

CREATE Procedure stp_Matters_GetAttachmentsForRelation

	(
		@accountid int,
		@clientid int
	)


AS
BEGIN
	SELECT dr.RelationID
		, dr.DocRelationID
		, dt.DisplayName
		, isnull(dr.relateddate, '01/01/1900') as ReceivedDate--, isnull(ds.ReceivedDate, '01/01/1900') as ReceivedDate
		, isnull(dr.relateddate, '01/01/1900') as Created
		, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as CreatedBy 
	FROM 
		tblDocRelation as dr with(nolock) 
		inner join tblDocumentType as dt with(nolock) on dt.TypeID = dr.DocTypeID 
		--left join tblDocScan as ds with(nolock) on ds.DocID = dr.DocID 
		left join tblUser as u with(nolock) on u.UserID = dr.relatedby
		inner join tblusergroup as ug with(nolock) on ug.usergroupid = u.usergroupid     
	WHERE 
		dr.RelationID  in 
		(
			 select m.MatterId 
			 from dbo.tblMatter m 
			 join dbo.tblClient c on c.ClientId=m.ClientId 
			 join tblAccount ac with(nolock) on ac.ClientId=c.ClientId and ac.AccountId= @accountid   
			 join tblCreditorInstance ti with(nolock) on ti.CreditorInstanceId=m.CreditorInstanceId and ti.AccountId= ac.AccountId  
			 where c.ClientId=@clientid and IsNull(m.IsDeleted,0)=0   
		)  
		and dr.RelationType = 'matter' 
		and (DeletedFlag = 0 or DeletedBy = -1)   
	ORDER BY  dr.relateddate desc 
 END

GO


GRANT EXEC ON stp_Matters_GetAttachmentsForRelation TO PUBLIC

GO


