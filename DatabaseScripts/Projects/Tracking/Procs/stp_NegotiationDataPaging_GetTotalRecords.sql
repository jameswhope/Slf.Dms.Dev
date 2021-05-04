IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationDataPaging_GetTotalRecords')
	BEGIN
		DROP  Procedure  stp_NegotiationDataPaging_GetTotalRecords
	END

GO


CREATE procedure [dbo].[stp_NegotiationDataPaging_GetTotalRecords]
(
@EntityID int,
@FilterClause varchar(max) = NULL
)
as
declare @ssql varchar(max)

set @ssql = 'SELECT count(distinct AccountID)'
set @ssql = @ssql + 'FROM '
set @ssql = @ssql + '	( '
set @ssql = @ssql + '		SELECT '
set @ssql = @ssql + '			row_number() OVER (ORDER BY lastoffer desc, p.FirstName, p.LastName) as RowNum, '
set @ssql = @ssql + '			c.ClientID,  '
set @ssql = @ssql + '			a.AccountID,  '
set @ssql = @ssql + '			p.SSN,  '
set @ssql = @ssql + '			p.FirstName + '' '' + p.LastName AS ApplicantFullName,  '
set @ssql = @ssql + '			p.LastName AS ApplicantLastName,  '
set @ssql = @ssql + '			p.FirstName AS ApplicantFirstName,  '
set @ssql = @ssql + '			ISNULL(s.Abbreviation, ''Non-US'') AS ApplicantState,  '
set @ssql = @ssql + '			p.City AS ApplicantCity, '
set @ssql = @ssql + '			p.ZipCode AS ApplicantZipCode,  '
set @ssql = @ssql + '			c.AccountNumber AS SDAAccount, '
set @ssql = @ssql + '			FundsAvailable,  '
set @ssql = @ssql + '			ISNULL(cr2.Name, '''') AS OriginalCreditor,  '
set @ssql = @ssql + '			cr.Name as CurrentCreditor,  '
set @ssql = @ssql + '			ISNULL(cs.Abbreviation, ''Non-US'') AS CurrentCreditorState,  '
set @ssql = @ssql + '			CONVERT(varchar(20), ci.AccountNumber) AS CurrentCreditorAccountNumber, '
set @ssql = @ssql + '			  (	SELECT MIN(CurrentAmount) AS CurrentAmount '
set @ssql = @ssql + '				FROM dbo.tblAccount '
set @ssql = @ssql + '				WHERE ClientID = c.ClientID  '
set @ssql = @ssql + '					AND AccountStatusID NOT IN (54, 55)) AS LeastDebtAmount,  '
set @ssql = @ssql + '			a.CurrentAmount, '
set @ssql = @ssql + '			isnull(ad.description,'''') as AccountStatus,  '
set @ssql = @ssql + '			DATEDIFF(day, a.Created, GETDATE()) AS AccountAge,  '
set @ssql = @ssql + '			DATEDIFF(day, ISNULL(YEAR(p.DateOfBirth), YEAR(GETDATE())), YEAR(GETDATE())) AS ClientAge, '
set @ssql = @ssql + '			nlo.LastOffer,       '
set @ssql = @ssql + '			nlo.OfferDirection  '
set @ssql = @ssql + '		FROM '
set @ssql = @ssql + '			tblClient AS c  '
set @ssql = @ssql + '		INNER JOIN  '
set @ssql = @ssql + '		( '
set @ssql = @ssql + '			select  '
set @ssql = @ssql + '				clf.clientid, '
set @ssql = @ssql + '				isnull(clf.SDABalance,0) - isnull(clf.PFOBalance,0) - sum(case when rf.entrytypeid = 3 and rf.Hold > GETDATE() then isnull(rf.amount,0) else 0 end) - sum(case when rf.entrytypeid = 43 and rf.Hold > GETDATE() then isnull(rf.amount,0) else 0 end) as [FundsAvailable]  '
set @ssql = @ssql + '			FROM  '
set @ssql = @ssql + '				tblclient as clf  '
set @ssql = @ssql + '			left outer join   '
set @ssql = @ssql + '				tblRegister as rf on clf.clientid = rf.clientid  '
set @ssql = @ssql + '			WHERE  '
set @ssql = @ssql + '				rf.Void IS NULL '
set @ssql = @ssql + '				AND rf.Bounce IS NULL '
set @ssql = @ssql + '				AND rf.Clear IS NULL '
set @ssql = @ssql + '			group by  '
set @ssql = @ssql + '				clf.clientid '
set @ssql = @ssql + '				,clf.SDABalance '
set @ssql = @ssql + '				, clf.PFOBalance '
set @ssql = @ssql + '		) as funds on c.clientid = funds.clientid   '
set @ssql = @ssql + '		inner join '
set @ssql = @ssql + '			tblPerson p on p.personid = c.primarypersonid '
set @ssql = @ssql + '		inner join '
set @ssql = @ssql + '			tblAccount a on a.ClientID = c.ClientID AND (a.AccountStatusID is null or a.AccountStatusID NOT IN (54, 55))  '
set @ssql = @ssql + '		inner join  '
set @ssql = @ssql + '			tblAccountEntityXref ax on ax.accountid = a.accountid and ax.entityid = ' + cast(@EntityID as varchar)
set @ssql = @ssql + '		left join '
set @ssql = @ssql + '			tblAccountStatus ad on ad.AccountStatusID = a.AccountStatusID '
set @ssql = @ssql + '		inner join  '
set @ssql = @ssql + '			tblCreditorInstance ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID '
set @ssql = @ssql + '		inner join  '
set @ssql = @ssql + '			tblCreditor cr on cr.CreditorID = ci.CreditorID '
set @ssql = @ssql + '		left outer join '
set @ssql = @ssql + '			tblCreditor cr2 on ci.ForCreditorID = cr2.CreditorID  '
set @ssql = @ssql + '		LEFT OUTER JOIN '
set @ssql = @ssql + '			dbo.tblState AS s ON p.StateID = s.StateID  '
set @ssql = @ssql + '		LEFT OUTER JOIN  '
set @ssql = @ssql + '			dbo.tblState AS cs ON cr.StateID = cs.StateID  '
set @ssql = @ssql + '		LEFT OUTER JOIN '
set @ssql = @ssql + '			vw_NegotiationLastOffer nlo on nlo.AccountID = a.AccountID '
if (@FilterClause IS NULL)
	BEGIN
		set @ssql = @ssql + '		WHERE ' 
	END
ELSE IF (@FilterClause = '')
	BEGIN
		set @ssql = @ssql + '		WHERE ' 
	END
ELSE
	BEGIN
		set @ssql = @ssql + '		WHERE ' +  @FilterClause + ' AND '
	END	
set @ssql = @ssql + '			c.CurrentClientStatusID not in (15, 16, 17, 18)  '
set @ssql = @ssql + '	) as drv '

exec(@ssql)

GRANT EXEC ON stp_NegotiationDataPaging_GetTotalRecords TO PUBLIC