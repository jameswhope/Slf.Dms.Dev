
ALTER procedure [dbo].[stp_NegotiationsSearchGetSettlementsWaitingOnSIF]
(
	@UserID numeric,
	@SearchTerm varchar(500)
)
as
BEGIN

	/* development		
	declare @UserID int
	declare @SearchTerm varchar(500)
	set @UserID = 353
	set @SearchTerm = '%car%'
	*/
		declare @vtblResults table (SettlementID int, clientid int,
	creditoraccountid int,ClientAccountNumber numeric,[Creditor Name] varchar(500), [OriginalCreditorName] varchar(500),creditorid int,
	[Client Name] varchar(500), CreditorAccountBalance money,SettlementAmount money, SettlementSavings money, 
	SettlementDueDate datetime,CreditorAccountNumber varchar(4), CreditorAccountNumberFull varchar(200),CreditorReferenceNumber varchar(500)
	,deliverymethod varchar(20),deliveryamount money,attentionto varchar(200),address varchar(500),city varchar(200),state varchar(2),zip varchar(20))
	
	declare @groupId int
	declare @HasRights bit
	set @HasRights = 0
	select @groupId = usergroupid from tbluser where userid = @userid 
	if @groupID = 11 or @groupID = 6
		BEGIN
			set @HasRights = 1
		END
		
	insert into @vtblResults
	SELECT     
		s.SettlementID, 
		s.clientid,
		s.creditoraccountid,
		cl.accountnumber as ClientAccountNumber,
		c.Name AS [Creditor Name],
		oc.[Name] AS [OriginalCreditorName],
		c.creditorid,
		p.FirstName + ' ' + p.LastName AS [Client Name], 
		s.CreditorAccountBalance,
		s.SettlementAmount, 
		s.SettlementSavings, 
		s.SettlementDueDate,
		right(ci.accountnumber,4) as CreditorAccountNumber, 
		ci.accountnumber[CreditorAccountNumberFull],
		ci.referencenumber as CreditorReferenceNumber,
		isnull(s.deliverymethod,'chkbytel'),
		isnull(s.deliveryamount,0)[deliveryamount],
		sd.attentionto,
		sd.[address],
		sd.city,
		sd.[state],
		sd.zip
	FROM  (SELECT SettlementID FROM tblNegotiationRoadmap GROUP BY SettlementID having MAX(SettlementStatusID) = 5) nr INNER JOIN
	tblSettlements AS s with(nolock)  ON s.SettlementID = nr.SettlementID and s.active = 1 and s.status = 'a' INNER JOIN
	tblPerson AS p with(nolock)  ON p.ClientID = s.ClientID INNER JOIN
	tblAccount AS a with(nolock)  ON a.AccountID = s.CreditorAccountID INNER JOIN
	tblCreditorInstance AS ci with(nolock)  ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
	tblCreditorInstance AS oci with(nolock) ON oci.CreditorInstanceId = a.OriginalCreditorInstanceId INNER JOIN
	tblCreditor AS oc with(nolock) ON oc.CreditorId = oci.CreditorID inner join
	tblCreditor AS c with(nolock)  ON c.CreditorID = ci.CreditorID inner join
	tblclient as cl with(nolock)  on p.clientid = cl.clientid left outer join 
	tblsettlements_deliveryaddresses  sd with(nolock) on sd.settlementid = s.settlementid
	WHERE  
		(p.Relationship = 'Prime')  
		and (s.CreatedBy = @UserID or @HasRights = 1)
		and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 --and convert(varchar(10),s.settlementduedate,101) >= convert(varchar(10),getdate(),101)
		--and s.matterid is null
	ORDER BY s.SettlementDueDate ASC
	option (fast 25)


	if @SearchTerm is null 
		select * from @vtblResults order by [client name]
	else
		select * from @vtblResults
		where	
			ClientAccountNumber like @searchTerm or 
			[Client Name] like @searchTerm or 
			[Creditor Name] like @searchTerm  or 
			[CreditorReferenceNumber] like @searchTerm  or 
			ClientAccountNumber like @searchTerm 
		order by [client name]
END