﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsSearchGetSettlementsWaitingOnSIF')
	BEGIN
		DROP  Procedure  stp_NegotiationsSearchGetSettlementsWaitingOnSIF
	END

GO


CREATE procedure [dbo].[stp_NegotiationsSearchGetSettlementsWaitingOnSIF]
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
	creditoraccountid int,ClientAccountNumber numeric,[Creditor Name] varchar(500),creditorid int,
	[Client Name] varchar(500), CreditorAccountBalance money,SettlementAmount money, SettlementSavings money, 
	SettlementDueDate datetime,CreditorAccountNumber varchar(500), CreditorReferenceNumber varchar(500)
	,deliverymethod varchar(20),deliveryamount money,attentionto varchar(200),address varchar(500),city varchar(200),state varchar(2),zip varchar(20))
	
	declare @groupId int
	select @groupId = usergroupid from tbluser where userid = @userid 
	if @groupID = 11 or @groupID = 6
		BEGIN
			insert into @vtblResults
			SELECT top 500   
				s.SettlementID, 
				s.clientid,
				s.creditoraccountid,
				cl.accountnumber as ClientAccountNumber,
				c.Name AS [Creditor Name],
				c.creditorid,
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				s.CreditorAccountBalance,
				s.SettlementAmount, 
				s.SettlementSavings, 
				s.SettlementDueDate,
				substring(ci.accountnumber,len(ci.accountnumber)-4,4) as CreditorAccountNumber, 
				ci.referencenumber as CreditorReferenceNumber
				, isnull(s.deliverymethod,'chk')
				,s.deliveryamount
				,sd.attentionto
				,sd.[address]
				,sd.city
				,sd.[state]
				,sd.zip
				FROM (
			SELECT     SettlementID
			FROM         dbo.tblNegotiationRoadmap
			GROUP BY SettlementID
			having MAX(SettlementStatusID) = 5
	) nr INNER JOIN
		tblSettlements AS s with(nolock)  ON s.SettlementID = nr.SettlementID and s.active = 1 INNER JOIN
		tblPerson AS p with(nolock)  ON p.ClientID = s.ClientID INNER JOIN
		tblAccount AS a with(nolock)  ON a.AccountID = s.CreditorAccountID INNER JOIN
		tblCreditorInstance AS ci with(nolock)  ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
		tblCreditor AS c with(nolock)  ON c.CreditorID = ci.CreditorID inner join
		tblclient as cl with(nolock)  on p.clientid = cl.clientid
		left outer join tblsettlements_deliveryaddresses  sd with(nolock) on sd.settlementid = s.settlementid
			WHERE  (p.Relationship = 'Prime') --and (s.CreatedBy = @UserID)
			ORDER BY s.SettlementDueDate ASC
			option (fast 100)
		END
	ELSE
		BEGIN
			insert into @vtblResults
			SELECT     
				s.SettlementID, 
				s.clientid,
				s.creditoraccountid,
				cl.accountnumber as ClientAccountNumber,
				c.Name AS [Creditor Name],
				c.creditorid,
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				s.CreditorAccountBalance,
				s.SettlementAmount, 
				s.SettlementSavings, 
				s.SettlementDueDate,
				substring(ci.accountnumber,len(ci.accountnumber)-4,4) as CreditorAccountNumber, 
				ci.referencenumber as CreditorReferenceNumber
				, isnull(s.deliverymethod,'chk')
				,s.deliveryamount
				,sd.attentionto
				,sd.[address]
				,sd.city
				,sd.[state]
				,sd.zip
			FROM  (
			SELECT     SettlementID
			FROM         dbo.tblNegotiationRoadmap
			GROUP BY SettlementID
			having MAX(SettlementStatusID) = 5
	) nr INNER JOIN
		tblSettlements AS s with(nolock)  ON s.SettlementID = nr.SettlementID and s.active = 1 INNER JOIN
		tblPerson AS p with(nolock)  ON p.ClientID = s.ClientID INNER JOIN
		tblAccount AS a with(nolock)  ON a.AccountID = s.CreditorAccountID INNER JOIN
		tblCreditorInstance AS ci with(nolock)  ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
		tblCreditor AS c with(nolock)  ON c.CreditorID = ci.CreditorID inner join
		tblclient as cl with(nolock)  on p.clientid = cl.clientid
		left outer join tblsettlements_deliveryaddresses  sd with(nolock) on sd.settlementid = s.settlementid
			WHERE  (p.Relationship = 'Prime')  and (s.CreatedBy = @UserID)
			and convert(varchar(10),s.settlementduedate,101) >= convert(varchar(10),getdate(),101)
			ORDER BY s.SettlementDueDate ASC
			option (fast 25)
		END
	

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


