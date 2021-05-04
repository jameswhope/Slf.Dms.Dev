IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCheckByPhoneProcessing')
	BEGIN
		DROP  Procedure  stp_GetCheckByPhoneProcessing
	END

GO

CREATE PROCEDURE [dbo].[stp_GetCheckByPhoneProcessing]
(
@UserId INT
)

AS
BEGIN
	DECLARE @isManager bit;
    declare @ssql varchar(max)

	SET @isManager = (case WHEn (select Manager From tblUser Where UserId = @UserId) = 1 Then 1 else 0 end);
    
    set @ssql = 'SELECT acc.PaymentProcessingId,acc.MatterId,acc.CheckAmount AS Amount,acc.DueDate AS DueDate,c.ClientId,acc.CheckNumber, '
    set @ssql = @ssql + 'ci.AccountId AS AccountId,p.FirstName + '' '' + p.LastName AS ClientName,com.[ShortCoName] AS Firm, '
    set @ssql = @ssql + 'cr.[Name] AS CreditorName,c.accountnumber,su.firstname + '' '' + su.lastname[NegName] '
    set @ssql = @ssql +'FROM '
    set @ssql = @ssql +'tblAccount_PaymentProcessing acc inner join '
    set @ssql = @ssql +'tblMatter m ON m.MatterId = acc.MatterId inner join '
    set @ssql = @ssql +'tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join '
    set @ssql = @ssql +'tblClient c ON c.ClientId = m.ClientId inner join '
    set @ssql = @ssql +'tblPerson p ON p.Personid = c.PrimaryPersonId inner join '
    set @ssql = @ssql +'tblCompany com ON c.CompanyId = com.CompanyId inner join '
    set @ssql = @ssql +'tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join '
    set @ssql = @ssql +'tblCreditor cr ON cr.CreditorId = ci.CreditorId left join '
    set @ssql = @ssql +'tblSettlements s ON s.MatterId = acc.MatterId inner join '
    set @ssql = @ssql +'tbluser su with(nolock) on s.createdby = su.userid '
    set @ssql = @ssql +'WHERE '
    set @ssql = @ssql +'acc.DeliveryMethod = ''P'' and acc.Processed = 0 and acc.IsApproved = 1 and (' + cast(@ismanager as varchar) + '= 1 or '
    set @ssql = @ssql +'s.Createdby IN (select userid from tblNegotiationEntity where ParentNegotiationEntityID in '
    set @ssql = @ssql +'(select ParentNegotiationEntityID from tblNegotiationEntity where userid = ' + cast(@UserId as varchar) + ')) '
    set @ssql = @ssql +') ORDER BY acc.DueDate'

    exec(@ssql)
END
GO


GRANT EXEC ON stp_GetCheckByPhoneProcessing TO PUBLIC

GO


