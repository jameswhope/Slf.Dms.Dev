IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_printQ_getdocpath')
	BEGIN
		DROP  Procedure  stp_printQ_getdocpath
	END

GO

CREATE Procedure stp_printQ_getdocpath
	(
		@matterID int, @settlementID int, @doctypeid varchar(20)
	)
AS
BEGIN
	select top 1 
		TypeName
		,s.SettlementID
		, s.matterid
		,'\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath 
	from tblDocRelation dr WITH(NOLOCK)
		inner join tblDocumentType d WITH(NOLOCK) ON d.TypeId = dr.DocTypeId 
		inner join tblClient c WITH(NOLOCK) ON c.ClientId = dr.ClientId 
		inner join tblSettlements s WITH(NOLOCK) on s.ClientID=c.ClientID and s.CreditorAccountID=dr.RelationID
	where DeletedFlag = 0 and DocTypeId = @doctypeid 
		and (s.MatterId = @matterID OR s.SettlementID = @settlementID)
	order by dr.RelatedDate desc 
END

GO

GRANT EXEC ON stp_printQ_getdocpath TO PUBLIC

GO

