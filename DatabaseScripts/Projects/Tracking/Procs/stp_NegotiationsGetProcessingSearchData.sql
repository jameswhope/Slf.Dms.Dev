IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsGetProcessingSearchData')
	BEGIN
		DROP  Procedure  stp_NegotiationsGetProcessingSearchData
	END

GO

CREATE Procedure stp_NegotiationsGetProcessingSearchData
(
	@UserID int,
	@searchValue varchar(500),
	@depth varchar(15)
)
as

BEGIN
	declare @searchSQL varchar(max)

	IF @depth = 'system' 
		BEGIN
			set @searchSQL = 'SELECT  s.SettlementID, tblClient.Accountnumber , s.CreditorAccountID AS LexxCreditorAccountID, s.ClientID AS LexxClientID, tblClient.AccountNumber AS LexxAcctNum, '
			set @searchSQL = @searchSQL + 'tblCreditor.Name AS [Creditor Name], tblCreditor.CreditorID AS LexxCreditorID, ci.AccountNumber AS CreditAcctNum, '
			set @searchSQL = @searchSQL + 'ci.ReferenceNumber AS CreditorRefNum, tblPerson.FirstName + '' '' + tblPerson.LastName AS [Client Name], s.CreditorAccountBalance, '
			set @searchSQL = @searchSQL + 's.SettlementAmount, s.SettlementSavings, s.SettlementPercent, s.SettlementDueDate, s.CreatedBy, tblNegotiationSettlementStatus.[name] as SettlementStatus, '
			set @searchSQL = @searchSQL + 'tblNegotiationRoadmap.SettlementStatusID, tblNegotiationRoadmap.created as [StatusDate] FROM tblCreditor INNER JOIN '
			set @searchSQL = @searchSQL + 'tblCreditorInstance AS ci ON tblCreditor.CreditorID = ci.CreditorID INNER JOIN tblSettlements AS s INNER JOIN '
			set @searchSQL = @searchSQL + 'tblNegotiationRoadmap ON s.SettlementID = tblNegotiationRoadmap.SettlementID INNER JOIN '
			set @searchSQL = @searchSQL + 'tblNegotiationSettlementStatus ON tblNegotiationRoadmap.SettlementStatusID = tblNegotiationSettlementStatus.SettlementStatusID INNER JOIN '
			set @searchSQL = @searchSQL + 'tblPerson ON s.ClientID = tblPerson.ClientID INNER JOIN tblAccount ON s.CreditorAccountID = tblAccount.AccountID ON ci.CreditorInstanceID = tblAccount.CurrentCreditorInstanceID INNER JOIN '
			set @searchSQL = @searchSQL + 'tblClient ON s.ClientID = tblClient.ClientID '
			set @searchSQL = @searchSQL + 'WHERE '
			set @searchSQL = @searchSQL + '(tblCreditor.Name LIKE ''' + @searchValue + '%'') OR (tblPerson.FirstName LIKE ''' + @searchValue + '%'') OR '
			set @searchSQL = @searchSQL + '(tblPerson.LastName LIKE ''' + @searchValue + '%'') OR '
			set @searchSQL = @searchSQL + '(tblClient.Accountnumber LIKE ''' + @searchValue + '%'') OR '
			set @searchSQL = @searchSQL + '(ci.AccountNumber LIKE ''' + @searchValue + '%'') OR (ci.ReferenceNumber LIKE ''' + @searchValue + '%'') '
			set @searchSQL = @searchSQL + 'ORDER BY s.SettlementDueDate desc '

		END
	ELSE
		BEGIN
			
			set @searchSQL = 'SELECT	s.clientid as LexxClientID, s.creditoraccountid as LexxCreditorAccountID, s.SettlementID,'
			set @searchSQL = @searchSQL + 'c.Name AS [Creditor Name],p.FirstName + '' '' + p.LastName AS [Client Name], '
			set @searchSQL = @searchSQL + 's.CreditorAccountBalance,s.SettlementAmount, '
			set @searchSQL = @searchSQL + 's.SettlementDueDate,ci.accountnumber,nss.[name] as SettlementStatus,nr.created as [StatusDate] '
			set @searchSQL = @searchSQL + 'FROM (SELECT max(RoadmapID) as RoadmapID,SettlementID FROM tblNegotiationRoadmap GROUP BY '
			set @searchSQL = @searchSQL + 'SettlementID ) as nr2 '
			set @searchSQL = @searchSQL + 'inner join tblNegotiationRoadmap as nr on nr.RoadmapID = nr2.RoadmapID '
			set @searchSQL = @searchSQL + 'inner join tblNegotiationSettlementStatus as nss on nss.SettlementStatusID = nr.SettlementStatusID '
			set @searchSQL = @searchSQL + 'inner join tblSettlements as s on s.SettlementID = nr.SettlementID '
			set @searchSQL = @searchSQL + 'inner join tblPerson as p on p.ClientID = s.ClientID '
			set @searchSQL = @searchSQL + 'inner join tblAccount as a on a.AccountID = s.CreditorAccountID '
			set @searchSQL = @searchSQL + 'inner join tblCreditorInstance as ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID '
			set @searchSQL = @searchSQL + 'inner join tblCreditor as c on c.CreditorID = ci.CreditorID '
			set @searchSQL = @searchSQL + 'inner join tblSettlementProcessing as sp on sp.SettlementID = s.SettlementID '
			set @searchSQL = @searchSQL + 'WHERE sp.UserID = ' + cast(@UserID as varchar) + ' and (nr.SettlementStatusID in (6,8)) and (p.Relationship = ''Prime'') '
			set @searchSQL = @searchSQL + 'AND (c.Name LIKE ''' + @searchValue + '%'') OR (p.FirstName + '' '' + p.LastName LIKE ''' + @searchValue + '%'') OR '
			set @searchSQL = @searchSQL + '(ci.accountnumber LIKE ''' + @searchValue + '%'') OR (ci.referencenumber LIKE ''' + @searchValue + '%'')'
			set @searchSQL = @searchSQL + 'ORDER BY s.SettlementDueDate desc '
		END
		--print(@searchSQL)
		exec(@searchSQL)
END

