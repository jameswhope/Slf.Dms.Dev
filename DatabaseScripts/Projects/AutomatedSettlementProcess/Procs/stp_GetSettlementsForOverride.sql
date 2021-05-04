IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementsForOverride')
	BEGIN
		DROP  Procedure  stp_GetSettlementsForOverride
	END

GO

CREATE Procedure [dbo].[stp_GetSettlementsForOverride]
(
@UserId int,
@ModifiedMatters xml output
)
AS BEGIN	
	EXEC [stp_MarkSettlementsForManagerOverride] @UserId, @ModifiedMatters output;

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
		c.AvailableSDA - dbo.udf_FundsOnHold(s.ClientID,s.SettlementID) - (case when isnull(s.ispaymentarrangement,0) = 1 then isnull(v.PmtAmount, 0) else s.SettlementAmount end) [diffAmount], 
		(SELECT count(*) FROM tblRegister r WHERE r.ClientId = c.ClientId and (TransactionDate between dateadd(mm,-6,getdate()) and getdate()) and bounce is not null) AS Bounce,
		s.IsPaymentArrangement,
		case when isnull(s.ispaymentarrangement,0) = 1 then isnull(v.PmtAmount, 0) else s.SettlementAmount end [PaymentAmount]
	FROM  
		tblSettlements s with(nolock) inner join
		tblClient c with(nolock) ON c.ClientId = s.ClientId inner join
		tblCompany co with(nolock) ON c.CompanyId = co.CompanyId inner join 
		tblPerson p with(nolock) ON p.PersonId = c.PrimaryPersonId inner join
		tblAccount a with(nolock) ON a.AccountId = s.CreditorAccountId inner join
		tblCreditorInstance ci with(nolock) ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
		tblCreditor cr with(nolock) ON cr.CreditorId = ci.CreditorId inner join
		tblMatter m with(nolock) ON m.MatterId = s.MatterId and m.IsDeleted = 0 and (m.MatterStatusCodeId = 27 or m.MatterStatusCodeId = 33) inner join 
		tblMatterStatus ms with(nolock) ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 
		left join vw_paymentschedule_ordered v on v.settlementid = s.settlementid and v.[order] = 1
	WHERE s.active = 1
	ORDER BY
		s.SettlementDueDate, [ClientName]
	option (fast 10)
	
END
GO


GRANT EXEC ON stp_GetSettlementsForOverride TO PUBLIC

GO


