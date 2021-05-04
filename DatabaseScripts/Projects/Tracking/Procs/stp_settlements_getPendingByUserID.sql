IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_getPendingByUserID')
	BEGIN
		DROP  Procedure  stp_settlements_getPendingByUserID
	END

GO

CREATE Procedure stp_settlements_getPendingByUserID
	(
		@userid int,
		@includePaid bit = 0,
		@hideexpired bit = 0
	)
AS
BEGIN
	declare @year int,@month int,@IsSuper bit,@UserGroup int,@Team varchar(30)
	declare @tblData table([settlementid] int,[ClientID]  int
	,[CreditorAccountID] int,[ClientAcctNum] numeric,[ClientName]  varchar(200),[Client CDA Bal] money,[CreditorName]  varchar(200),[CreditorBal]  money
	,[SettlementAmt]  money,[SettlementFee]  money,[team] varchar(100),[Negotiator]  varchar(100),[Client Stipulation] varchar(100),[Payment Arrangement] varchar(100),[Restrictive Endorsement] varchar(100)
	,[LC Approval]  varchar(100),[Agency] varchar(100),[Status] varchar(100),[AccountStatus] varchar(100),[SettlementDueDate] datetime,[Created] datetime,[PaidDate] datetime)

	SET @year = year(getdate())
	SET @month = month(getdate())

	select @UserGroup= UserGroupID FROM tblUser where UserID = @userid

	SELECT @IsSuper = isnull(ne.IsSupervisor,0), @team = ng.Name
	FROM tblNegotiationEntity AS ne 
	left JOIN (SELECT NegotiationEntityID,  Name, ParentNegotiationEntityID, ParentType, UserID, Deleted, LastRefresh 
	FROM tblNegotiationEntity WHERE (Type = 'group')) AS ng ON ne.ParentNegotiationEntityID = ng.NegotiationEntityID 
	WHERE (ne.Type = 'Person') AND (ne.Name <> 'New Person') AND (ne.Deleted <> 1) and ne.UserID=@userid

	insert into @tblData
	SELECT s.settlementid
		,s.ClientID
		,s.CreditorAccountID
		 , [ClientAcctNum] = c.accountnumber
		 , [ClientName] = p.firstname + ' ' + p.lastname
		 , [Client CDA Bal] = s.availsda
		 , [CreditorName] = cc.name + ' #' + right(ci.AccountNumber,4)
		 , [CreditorBal] = ci.amount
		 , [SettlementAmt] = s.settlementamount
		 , [SettlementFee] = s.settlementfee
		 , sti.team
		 , [Negotiator] = uc.firstname + ' ' + uc.lastname
		 , [Client Stipulation] =
								  CASE
								  WHEN isnull(s.isclientstipulation, 0) = 1 THEN
									  'Y'
								  ELSE
									  'N'
								  END
		 , [Payment Arrangement] =
								   CASE
								   WHEN isnull(s.isPaymentArrangement, 0) = 1 THEN
									   'Y'
								   ELSE
									   'N'
								   END
		 , [Restrictive Endorsement] =
									   CASE
									   WHEN isnull(s.IsRestrictiveEndorsement, 0) = 1 THEN
										   'Y'
									   ELSE
										   'N'
									   END
		 , [LC Approval] =
						   CASE
						   WHEN s.recommend IS NULL THEN
							   'Y'
						   ELSE
							   'N'
						   END
		 , [Agency] = ag.name
		 , [Status] = isnull(msc.MatterStatusCodeDescr, 'NONE')
		 , [AccountStatus] = acs.Description
		 , s.SettlementDueDate
		 , s.Created
		 ,[PaidDate]=settpaid.TransactionDate
	FROM
		tblsettlementtrackerimports sti
		INNER JOIN tblagency ag
		ON ag.agencyid = sti.agencyid
		INNER JOIN tblsettlements s WITH (NOLOCK)
		ON s.settlementid = sti.settlementid
		INNER JOIN tblclient c WITH (NOLOCK)
		ON s.clientid = c.clientid
		INNER JOIN tblperson p WITH (NOLOCK)
		ON p.personid = c.primarypersonid
		INNER JOIN tblaccount a WITH (NOLOCK)
		ON a.accountid = s.creditoraccountid
		INNER JOIN tblcreditorinstance ci WITH (NOLOCK)
		ON ci.creditorinstanceid = a.currentcreditorinstanceid
		INNER JOIN tblcreditor cc WITH (NOLOCK)
		ON ci.creditorid = cc.creditorid
		INNER JOIN tbluser uc WITH (NOLOCK)
		ON uc.userid = s.createdby
		LEFT JOIN tblmatter m WITH (NOLOCK)
		ON s.matterid = m.matterid
		LEFT JOIN tblmatterstatuscode msc WITH (NOLOCK)
		ON m.matterstatuscodeid = msc.matterstatuscodeid
		INNER JOIN tblAccountStatus acs WITH (NOLOCK)
		ON acs.AccountStatusID = a.AccountStatusID
		left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
	WHERE
		s.active = 1
		and (acs.AccountStatusID <> 54 or @includePaid =1) 
		AND (s.createdby= @userID OR (@IsSuper = 1 AND Team = @team ) OR @userGroup = 11)
		AND year(s.SettlementDueDate) = @year
		AND month(s.SettlementDueDate) >= @month
	ORDER BY
		s.created
	OPTION (FAST 500)

	if @hideexpired=0
		BEGIN
			SELECT * from @tblData
		END
	ELSE
		BEGIN
			SELECT * from @tblData where settlementduedate > =getdate()
		END
	

END

GO


GRANT EXEC ON stp_settlements_getPendingByUserID TO PUBLIC

GO


