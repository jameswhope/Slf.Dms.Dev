Alter Procedure stp_NegotiationInsertSettlement
(
@CreditorAccountID int,
@ClientID int,
@RegisterBalance money = Null,
@FrozenAmount money = Null,
@CreditorAccountBalance money = Null,
@SettlementPercent float,
@SettlementAmount money,
@SettlementAmtAvailable money = Null,
@SettlementAmtBeingSent money = Null,
@SettlementAmtStillOwed money = Null,
@SettlementDueDate datetime =  Null,
@SettlementSavings money = Null,
@SettlementFee money = Null,
@OvernightDeliveryAmount money = Null,
@SettlementCost money = Null,
@SettlementFeeAmtAvailable money = Null,
@SettlementFeeAmtBeingPaid money = Null,
@SettlementFeeAmtStillOwed money = Null,
@SettlementNotes varchar(max) = Null,
@Status  varchar(1) = Null,
@SettlementRegisterHoldID int = Null,
@OfferDirection varchar(50),
@SettlementSessionGuid varchar(100) = Null,
@SettlementFeeCredit money = Null,
@UserId int
)
AS
BEGIN
/*
	History
	
	06.02.08 opereira Created
*/
--8.17.09.ug. set all other settlements to inactive
declare @settid numeric

update tblsettlements
set active = 0
where CreditorAccountID = @CreditorAccountID and ClientID = @ClientID

Insert Into tblSettlements(CreditorAccountID, ClientID, RegisterBalance,FrozenAmount, CreditorAccountBalance, SettlementPercent,SettlementAmount, SettlementAmtAvailable, SettlementAmtBeingSent,SettlementAmtStillOwed, SettlementDueDate, SettlementSavings,
SettlementFee, OvernightDeliveryAmount, SettlementCost,SettlementFeeAmtAvailable, SettlementFeeAmtBeingPaid, SettlementFeeAmtStillOwed,SettlementNotes, [Status], Created,CreatedBy, LastModified, LastModifiedBy,SettlementRegisterHoldID, OfferDirection, SettlementSessionGuid,SettlementFeeCredit,Active)
VALUES(@CreditorAccountID, @ClientID, @RegisterBalance,@FrozenAmount, @CreditorAccountBalance, @SettlementPercent,@SettlementAmount, @SettlementAmtAvailable, @SettlementAmtBeingSent,
@SettlementAmtStillOwed, @SettlementDueDate, @SettlementSavings,@SettlementFee, @OvernightDeliveryAmount, @SettlementCost,@SettlementFeeAmtAvailable, @SettlementFeeAmtBeingPaid, @SettlementFeeAmtStillOwed,
@SettlementNotes, @Status, GetDate(),@UserId, GetDate(), @UserId,@SettlementRegisterHoldID, @OfferDirection, @SettlementSessionGuid,@SettlementFeeCredit,1)

SELECT @settid = Scope_Identity()

if @status <> 'R'
	BEGIN
			
		--remove old settlements
		declare @ClientAcctNum numeric
		declare @origCreditor varchar(200)
		declare @CreditorAcctNum varchar(100)
		declare @bal money
		declare @settamt money

		SELECT DISTINCT 
		 @ClientAcctNum = c.AccountNumber
		, @origCreditor = origname.Name 
		, @CreditorAcctNum = curr.AccountNumber 
		, @bal = a.currentamount
		, @settamt = sett.settlementamount
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
		WHERE   sett.settlementid = @settid and sett.status ='a' and sett.active = 1

		delete from tblsettlementtrackerimports 
		where clientacctnumber =@ClientAcctNum 
		and @bal=balance
		and @settamt = settlementamt
		and originalcreditor = @origCreditor
		and creditoraccountnum = @CreditorAcctNum
		and paid is not null
		--insert settlement tracker
		declare @guid uniqueidentifier
		set @guid= NEWID()

		INSERT INTO [tblSettlementTrackerImports]([TrackerImportBatchID],[Team],[Negotiator],[AgencyID],[LawFirm],[Date],[Status],[Due],[ClientAcctNumber],[Name],[CreditorAccountNum],[OriginalCreditor],[CurrentCreditor],[BALANCE],[SettlementAmt],[SettlementPercent],[FundsAvail],[Note],[sent],[paid],[days],[ClientSavings],[SettlementFees],[SettlementSavingsPct],[ImportDate],[ImportBy],[SettlementID])
		select distinct[TrackerImportBatchID] , [Team] , [Negotiator] , [AgencyID] , [LawFirm] , [Date], [Status] , [Due] , [ClientAcctNum] , [Client Name] , [CreditorAcctNum] , [OriginalCreditor], [CurrentCreditor] 
		, [Balance] , [SettlementAmount] , [SettlementPct] , [FundsAvail] , [Note] , [sent] , [Paid] , [Days] , [Client Savings], [SettlementFees] , [SettlementFeePct], [ImportDate] , [ImportBy],[SettlementID]
		from (
		SELECT DISTINCT 
		 [TrackerImportBatchID] = CONVERT(varchar(255), @guid), [Team] = isnull(ne.NegotiationEntityID,-1) 
		, [Negotiator] =neg.firstname + ' ' + neg.lastname, [AgencyID] = c.AgencyID, [LawFirm] = co.ShortCoName
		, [Date] = convert(varchar(10),sett.Created,101), [Status] = [as].Code , [Due] = convert(varchar(10),sett.SettlementDueDate,101)
		, [ClientAcctNum] = c.AccountNumber, [Client Name] = p.FirstName + ' ' + p.LastName , [CreditorAcctNum] = curr.AccountNumber 
		, [OriginalCreditor] = origname.Name , [CurrentCreditor] = currname.Name , [Balance] = a.CurrentAmount, [SettlementAmount] = sett.SettlementAmount
		, [SettlementPct] = case when sett.SettlementAmount > 0 and a.CurrentAmount > 0 then sett.SettlementAmount/a.CurrentAmount else 0 end
		, [FundsAvail] = c.SDABalance - c.PFOBalance -(SELECT ISNULL(SUM(Amount), 0) AS Expr1 FROM tblRegister WHERE (ClientId = c.ClientID) AND (EntryTypeId = 3) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) -(SELECT ISNULL(SUM(Amount), 0) AS Expr1 FROM tblRegister AS tblRegister_3 WHERE (ClientId = c.ClientID) AND (EntryTypeId = 43) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL))
		, [Note] = '', [sent] = '', [Paid] = case when [as].Code = 'SA' then a.settled else Null end, [Days] = DateDiff(d,sett.Created,getdate())
		, [Client Savings] = a.CurrentAmount - sett.SettlementAmount, [SettlementFees] = (a.CurrentAmount - sett.SettlementAmount)*c.SettlementFeePercentage
		, [SettlementFeePct] = c.SettlementFeePercentage, [ImportDate] = getdate(), [ImportBy] = @userID, sett.SettlementID
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
		tblUser AS neg ON neg.UserID = sett.CreatedBy
		WHERE   sett.settlementid = @settid and sett.status ='a' and sett.active = 1
		) as batchData 
		order by team, creditoracctnum;

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


		update tblsettlementtrackerimports 
		set team = 'HOUSE(SP)'
		where isnumeric(team) = 1
	END

SELECT @settid 

END
GO
