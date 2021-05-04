IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SettlementImport_ImportSettlements')
	BEGIN
		DROP  Procedure  stp_SettlementImport_ImportSettlements
	END

GO
create procedure stp_SettlementImport_ImportSettlements
(
@year int,
@month int,
@userID int
)
as
BEGIN
	/*
	declare @year int
	declare @month int

	set @year = 2009
	set @month = 7
	*/

	declare @guid uniqueidentifier
	set @guid= NEWID()

	INSERT INTO [tblSettlementTrackerImports]([TrackerImportBatchID],[Team],[Negotiator],[AgencyID],[LawFirm],[Date],[Status],[Due],[ClientAcctNumber],[Name],[CreditorAccountNum],[OriginalCreditor],[CurrentCreditor],[BALANCE],[SettlementAmt],[SettlementPercent],[FundsAvail],[Note],[sent],[paid],[days],[ClientSavings],[SettlementFees],[SettlementSavingsPct],[ImportDate],[ImportBy],[SettlementID])
	select distinct
		[TrackerImportBatchID] , [Team] , [Negotiator] , [AgencyID] , [LawFirm] , [Date], [Status] 
		, [Due] , [ClientAcctNum] , [Client Name] , [CreditorAcctNum] , [OriginalCreditor], [CurrentCreditor] 
		, [Balance] , [SettlementAmount] , [SettlementPct] , [FundsAvail] , [Note] , [sent] , [Paid] 
		, [Days] , [Client Savings], [SettlementFees] , [SettlementFeePct], [ImportDate] , [ImportBy],[SettlementID]
		from (
		SELECT DISTINCT 
		 [TrackerImportBatchID] = CONVERT(varchar(255), @guid)
		, [Team] = isnull(dbo.udf_Negotiators_getGroup(ne.NegotiationEntityID),'HOUSE(SP)') 
		, [Negotiator] =neg.username
		, [AgencyID] = c.AgencyID
		, [LawFirm] = co.ShortCoName
		, [Date] = convert(varchar(10),sett.Created,101)
		, [Status] = [as].Code 
		, [Due] = convert(varchar(10),sett.SettlementDueDate,101)
		, [ClientAcctNum] = c.AccountNumber
		, [Client Name] = p.FirstName + ' ' + p.LastName 
		, [CreditorAcctNum] = curr.AccountNumber 
		, [OriginalCreditor] = origname.Name 
		, [CurrentCreditor] = currname.Name 
		, [Balance] = a.CurrentAmount
		, [SettlementAmount] = sett.SettlementAmount
		, [SettlementPct] = case when sett.SettlementAmount > 0 then sett.SettlementAmount/ISNULL(NULLIF(convert(float,a.CurrentAmount),0),1) else 0 end
		, [FundsAvail] = c.SDABalance - c.PFOBalance -(SELECT ISNULL(SUM(Amount), 0) AS Expr1 FROM tblRegister WHERE (ClientId = c.ClientID) AND (EntryTypeId = 3) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) -(SELECT ISNULL(SUM(Amount), 0) AS Expr1 FROM tblRegister AS tblRegister_3 WHERE (ClientId = c.ClientID) AND (EntryTypeId = 43) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL))
		, [Note] = ''
		, [sent] = ''
		, [Paid] = case when [as].Code = 'SA' then a.settled else Null end
		, [Days] = DateDiff(d,sett.Created,getdate())
		, [Client Savings] = a.CurrentAmount - sett.SettlementAmount
		, [SettlementFees] = (a.CurrentAmount - sett.SettlementAmount)*c.SettlementFeePercentage
		, [SettlementFeePct] = c.SettlementFeePercentage
		, [ImportDate] = getdate()
		, [ImportBy] = @userID
		, sett.SettlementID
	FROM tblCompany AS co RIGHT OUTER JOIN
		tblCreditor AS origname RIGHT OUTER JOIN
		tblCreditorInstance AS orig ON origname.CreditorID = orig.CreditorID RIGHT OUTER JOIN
		tblClient AS c INNER JOIN
		tblSettlements AS sett ON c.ClientID = sett.ClientID LEFT OUTER JOIN
		tblNegotiationEntity AS ne ON sett.CreatedBy = ne.UserID LEFT OUTER JOIN
		tblAccount AS a INNER JOIN
		tblAccountStatus AS [as] ON a.AccountStatusID = [as].AccountStatusID ON sett.CreditorAccountID = a.AccountID LEFT OUTER JOIN
		tblCreditor AS currname RIGHT OUTER JOIN
		tblCreditorInstance AS curr ON currname.CreditorID = curr.CreditorID ON a.CurrentCreditorInstanceID = curr.CreditorInstanceID ON 
		orig.CreditorInstanceID = a.OriginalCreditorInstanceID LEFT OUTER JOIN
		tblPerson AS p ON c.PrimaryPersonID = p.PersonID ON co.CompanyID = c.CompanyID LEFT OUTER JOIN
		tblUser AS neg ON neg.UserID = ne.UserID
	WHERE   sett.status = 'a' and active = 1
	AND YEAR(sett.Created) = @year AND MONTH(sett.Created) = @month
	) as batchData 
	order by team, creditoracctnum
END




GRANT EXEC ON stp_SettlementImport_ImportSettlements TO PUBLIC


