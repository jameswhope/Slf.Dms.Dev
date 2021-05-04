IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementsForLCApproval')
	BEGIN
		DROP  Procedure  stp_GetSettlementsForLCApproval
	END

GO

CREATE Procedure [dbo].[stp_GetSettlementsForLCApproval]
(	
	@AttorneyId int	
)

AS
BEGIN	

	 SELECT 
		s.SettlementId,
		s.ClientId,
		s.CreditorAccountId,
		s.SettlementAmount,
		s.SettlementPercent,
		s.SettlementDueDate 
	 FROM tblSettlements s
	 INNER JOIN tblMatter m ON m.MatterId = s.MatterId AND 
	 m.MatterStatuscodeId NOT IN (25,28,29,30)	
	 WHERE s.LocalCounselId = @AttorneyId AND s.Active = 1	

	 UNION
	
	 SELECT 
		s.SettlementId,
		s.ClientId,
		s.CreditorAccountId,
		s.SettlementAmount,
		s.SettlementPercent,
		s.SettlementDueDate  
	 FROM tblSettlements s
	 INNER JOIN tblMatter m ON m.MatterId = s.MatterId AND 
	 m.MatterStatuscodeId NOT IN (25,28,29,30)	
	 INNER JOIN tblClient c ON s.ClientId = c.ClientId 
	 INNER JOIN tblAttyRelation ar ON c.CompanyId = ar.CompanyId AND 
	 ar.AttorneyId = @AttorneyId
	 WHERE s.LocalCounselId IS NULL AND s.Active = 1
	
END
GO


GRANT EXEC ON stp_GetSettlementsForLCApproval TO PUBLIC

GO


