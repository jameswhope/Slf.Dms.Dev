IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_UpdateMissingSettlements')
	BEGIN
		DROP  Procedure  stp_settlementimport_UpdateMissingSettlements
	END

GO

CREATE Procedure stp_settlementimport_UpdateMissingSettlements
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS
BEGIN
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
		, [Team] = ne.NegotiationEntityID 
		, [Negotiator] =neg.firstname + ' ' + neg.lastname
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
		, [ImportBy] = -1
		, sett.SettlementID
	FROM tblCompany AS co with(nolock) RIGHT OUTER JOIN
		tblCreditor AS origname with(nolock) RIGHT OUTER JOIN
		tblCreditorInstance AS orig with(nolock) ON origname.CreditorID = orig.CreditorID RIGHT OUTER JOIN
		tblClient AS c with(nolock) INNER JOIN
		tblSettlements AS sett with(nolock) ON c.ClientID = sett.ClientID LEFT OUTER JOIN
		tblNegotiationEntity AS ne with(nolock) ON sett.CreatedBy = ne.UserID LEFT OUTER JOIN
		tblAccount AS a with(nolock) INNER JOIN
		tblAccountStatus AS [as] with(nolock) ON a.AccountStatusID = [as].AccountStatusID ON sett.CreditorAccountID = a.AccountID LEFT OUTER JOIN
		tblCreditor AS currname with(nolock) RIGHT OUTER JOIN
		tblCreditorInstance AS curr with(nolock) ON currname.CreditorID = curr.CreditorID ON a.CurrentCreditorInstanceID = curr.CreditorInstanceID ON 
		orig.CreditorInstanceID = a.OriginalCreditorInstanceID LEFT OUTER JOIN
		tblPerson AS p with(nolock) ON c.PrimaryPersonID = p.PersonID ON co.CompanyID = c.CompanyID LEFT OUTER JOIN
		tblUser AS neg with(nolock) ON neg.UserID = sett.CreatedBy
	WHERE   sett.status = 'a' and active = 1
	and not settlementid in (select settlementid from tblsettlementtrackerimports)
	) as batchData 
	order by team, creditoracctnum
	option (fast 100)

	declare @tblGroups table(NegotiationEntityID int,Name varchar(100))
	declare @tblTeams table(tid int,Name varchar(100))

	insert into @tblGroups 
	select NegotiationEntityID, name from tblnegotiationentity with(nolock) where type = 'group'

	--select * from @tblGroups 
	insert into @tblTeams
	select sti.trackerimportid, tg.name
	from tblsettlementtrackerimports sti with(nolock)
	inner join tblnegotiationentity  ne with(nolock) on ne.negotiationentityid = sti.team
	inner join @tblGroups tg on tg.NegotiationEntityID = ne.parentNegotiationEntityID
	where isnumeric(sti.team) = 1 and ne.parentnegotiationentityid is not null


	update tblsettlementtrackerimports 
	set team = tm.name
	from @tblTeams tm
	inner join tblsettlementtrackerimports sti with(nolock) on sti.trackerimportid = tm.tid
END

GO


GRANT EXEC ON stp_settlementimport_UpdateMissingSettlements TO PUBLIC

GO


