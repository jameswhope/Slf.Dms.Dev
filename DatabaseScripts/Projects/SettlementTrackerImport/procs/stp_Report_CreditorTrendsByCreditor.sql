IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Report_CreditorTrendsByCreditor')
	BEGIN
		DROP  Procedure  stp_Report_CreditorTrendsByCreditor
	END

GO

create procedure stp_Report_CreditorTrendsByCreditor
(
	@creditorName varchar(250) 
)
as
BEGIN
/*
	declare @creditorName varchar(150)

	set @credname = 'accounts'--Null
	
	stp_Report_CreditorTrendsByCreditor 'accounts'
*/
	
		declare @tblTrends table (TimeFrame varchar(20),TotalUnits int,TotalSettlementAmt float ,MinSettlementPct float,MaxSettlementPct float,AvgSettlementPct float)
	
	--get last 30 days
	insert into @tblTrends
	SELECT 
	[TimeFrame] = 'Last 30 Days'
	,count(*)[TotalUnits]
	,sum(sett.settlementamount)[TotalSettlementAmt]
	,min(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),0),1))[MinSettlementPct]
	,max(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),0),1))[MaxSettlementPct]
	,sum(sett.settlementamount)/sum(ISNULL(NULLIF(convert(float,a.currentamount),0),1))[AvgSettlementPct]
	FROM tblSettlements AS sett 
	inner join tblaccount a on a.accountid = sett.creditoraccountid
	inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor cur on cur.creditorid = ci.creditorid
	WHERE   sett.status = 'a' and active = 1
	and (cur.name = @creditorName) and sett.created >= dateadd(d,-30,getdate())
	group by cur.name
	
	--get last 90 days
	insert into @tblTrends
	SELECT 
	[TimeFrame] = 'Last 90 Days'
	,count(*)[TotalUnits]
	,sum(sett.settlementamount)[TotalSettlementAmt]
	,min(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),0),1))[MinSettlementPct]
	,max(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),0),1))[MaxSettlementPct]
	,sum(sett.settlementamount)/sum(ISNULL(NULLIF(convert(float,a.currentamount),0),1))[AvgSettlementPct]
	FROM tblSettlements AS sett 
	inner join tblaccount a on a.accountid = sett.creditoraccountid
	inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor cur on cur.creditorid = ci.creditorid
	WHERE   sett.status = 'a' and active = 1
	and (cur.name = @creditorName) and sett.created >= dateadd(d,-90,getdate())
	group by cur.name
	
	--get ytd
	insert into @tblTrends
	SELECT 
	[TimeFrame] = 'YTD'
	,count(*)[TotalUnits]
	,sum(sett.settlementamount)[TotalSettlementAmt]
	,min(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),0),1))[MinSettlementPct]
	,max(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),0),1))[MaxSettlementPct]
	,sum(sett.settlementamount)/sum(ISNULL(NULLIF(convert(float,a.currentamount),0),1))[AvgSettlementPct]
	FROM tblSettlements AS sett 
	inner join tblaccount a on a.accountid = sett.creditoraccountid
	inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor cur on cur.creditorid = ci.creditorid
	WHERE   sett.status = 'a' and active = 1
	and (cur.name = @creditorName)
	group by cur.name
	
	select * from @tblTrends
END




GO


GRANT EXEC ON stp_Report_CreditorTrendsByCreditor TO PUBLIC

GO


 