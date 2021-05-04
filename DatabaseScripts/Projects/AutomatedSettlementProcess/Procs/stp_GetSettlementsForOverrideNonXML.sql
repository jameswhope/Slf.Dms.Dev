IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementsForOverrideNonXML')
	BEGIN
		DROP  Procedure  stp_GetSettlementsForOverrideNonXML
	END

GO

CREATE Procedure stp_GetSettlementsForOverrideNonXML
(
@UserId int
)
AS BEGIN
	declare @ModifiedMatters xml
	EXEC [stp_MarkSettlementsForManagerOverride] @UserId, @ModifiedMatters ;

	SELECT
		a.AccountId,	 
		c.accountnumber,
		c.ClientId,
		s.SettlementId , 
		s.SettlementDueDate,
		co.shortconame AS firm, 
		p.firstname + ' ' + isnull(p.lastname,'') AS ClientName,
		cr.name AS creditorname,
		s.SettlementAmount, 
		c.AvailableSDA - dbo.udf_FundsOnHold(s.ClientID,s.SettlementID) [RegisterBalance], 
		c.AvailableSDA - dbo.udf_FundsOnHold(s.ClientID,s.SettlementID) - s.SettlementAmount [diffAmount], 
		(SELECT count(*) FROM tblRegister r WHERE r.ClientId = c.ClientId and (TransactionDate between dateadd(mm,-6,getdate()) and getdate()) and bounce is not null) AS Bounce
	FROM  
		tblSettlements s inner join
		tblClient c ON c.ClientId = s.ClientId inner join
		tblCompany co ON c.CompanyId = co.CompanyId inner join 
		tblPerson p ON p.PersonId = c.PrimaryPersonId inner join
		tblAccount a ON a.AccountId = s.CreditorAccountId inner join
		tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
		tblCreditor cr ON cr.CreditorId = ci.CreditorId inner join
		tblMatter m ON m.MatterId = s.MatterId and m.IsDeleted = 0 and (m.MatterStatusCodeId = 27 or m.MatterStatusCodeId = 33) inner join 
		tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 
	ORDER BY
		s.SettlementDueDate, [ClientName]
	
END


GRANT EXEC ON stp_GetSettlementsForOverrideNonXML TO PUBLIC

GO


