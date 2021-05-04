IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementDocuments')
	BEGIN
		DROP  Procedure  stp_GetSettlementDocuments
	END

GO

CREATE Procedure [dbo].[stp_GetSettlementDocuments]
	(
		@SettlementId int	)

AS BEGIN

	DECLARE @ClientId INT
			,@AccountId INT
			,@SettlementCreatedDate DATETIME
			,@SIFAttachedDate DATETIME
			,@AccountNumber VARCHAR(50) ;

	DECLARE @Paths TABLE
					(
						DocumentName NVARCHAR(100),
						FilePath VARCHAR(200),
						FolderName VARCHAR(25)
					);

	SELECT 
		@ClientId = s.ClientId, 
		@AccountId = s.CreditorAccountId, 
		@SettlementCreatedDate = s.Created, 
		@SIFAttachedDate = DATEADD(mi, 2, nr.Created)
	FROM 
		tblSettlements s with(nolock) left join
		tblNegotiationRoadmap nr with(nolock) on nr.SettlementId = s.SettlementId And (SettlementStatusId = 8 or SettlementStatusId = 6)
	WHERE 
		s.SettlementId = @SettlementId;

	SELECT @AccountNumber = AccountNumber FROM tblClient with(nolock) WHERE ClientId = @ClientId;

	--Insert D6004SCAN for the settlement
	INSERT INTO @Paths(FilePath, DocumentName, FolderName)
	SELECT DISTINCT
		(CASE 
			WHEN dr.DocTypeId = '9074' THEN isnull(dr.SubFolder, '')+@AccountNumber+'_'+dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.wav'
			ELSE isnull(dr.SubFolder, '')+@AccountNumber+'_'+dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf'
		END),
		d.DisplayName, d.DocFolder 
	FROM tblSettlements s with(nolock) inner join		
		tblMatter m with(nolock) ON m.MatterId = s.MatterId left join
		tblDocRelation dr with(nolock) ON dr.RelationId = m.MatterId inner join
		tblDocumentType d with(nolock) ON dr.DocTypeId = d.TypeID
	WHERE 
		s.SettlementId = @SettlementId
		and dr.DeletedFlag <> 1 
		and dr.RelationType = 'matter' 
		and dr.DocTypeId IN('D6004SCAN','D9011', 'D6011', '9074', 'D3033', 'D6004');;

	--Insert other settlement Docs for the settlement
	INSERT INTO @Paths(FilePath, DocumentName, FolderName)
	SELECT 
		dr.SubFolder+@AccountNumber+'_'+dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf', d.DisplayName, d.DocFolder 
	FROM
		tblDocRelation dr with(nolock) inner join
		tblDocumentType d with(nolock) ON dr.DocTypeId = d.TypeID		
	WHERE 
		dr.ClientId = @ClientId and dr.RelationId = @AccountId and dr.RelationType = 'account' and 
		dr.DocTypeId in ('D6011', 'D3033') and DeletedFlag <> 1 and
		dr.RelatedDate between @SettlementCreatedDate and @SIFAttachedDate;

	----Insert client Docs
	INSERT INTO @Paths(FilePath, DocumentName, FolderName)
	SELECT 
		(CASE 
			WHEN dr.DocTypeId = 'C1001' THEN
				@AccountNumber+'_'+dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.tif'
			ELSE	
				@AccountNumber+'_'+dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' 
		 END), d.DisplayName, d.DocFolder
	FROM		
		tblDocRelation dr with(nolock) inner join
		tblDocumentType d with(nolock) ON dr.DocTypeId = d.TypeID
	WHERE
	    dr.ClientId = @ClientId and dr.RelationId = @ClientId and 
		dr.RelationType = 'client'  and DeletedFlag <> 1

	SELECT DISTINCT Filepath, DocumentName, FolderName FROM @Paths;

	DELETE @Paths;

END
GO


GRANT EXEC ON stp_GetSettlementDocuments TO PUBLIC

GO


