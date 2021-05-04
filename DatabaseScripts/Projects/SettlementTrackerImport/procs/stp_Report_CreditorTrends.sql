IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Report_CreditorTrends')
	BEGIN
		DROP  Procedure  stp_Report_CreditorTrends
	END

GO

create procedure stp_Report_CreditorTrends
(
	@year int = Null,
	@month int = Null,
	@creditorName varchar(150) = Null
)
as
BEGIN
/*
	declare @credName varchar(150)
	declare @year int
	declare @month int

	set @credname = 'accounts'--Null
	set @year = 2010
	set @month = 1
	
	stp_Reporting_CreditorTrends 2010,1,null
*/
	if @year is null
		BEGIN
			set @year = year(getdate())
		END
	if @month is null
		BEGIN
			set @month = month(getdate())
		END

	if @creditorName is not null
		BEGIN
			set @creditorName = @creditorName + '%'
		END

	SELECT 
	cur.name,count(*)[TotalUnits]
	,sum(a.currentamount)[TotalDebtWithCreditor]
	,min(sett.settlementamount)[MinSettlementAmt]
	,max(sett.settlementamount)[MaxSettlementAmt]
	,avg(sett.settlementamount)[AvgSettlementAmt]
	,sum(sett.settlementamount)[TotalSettlementAmt]
	,min(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),1),1))[MinSettlementPct]
	,max(sett.settlementamount/ISNULL(NULLIF(convert(float,a.currentamount),1),1))[MaxSettlementPct]
	,sum(sett.settlementamount)/sum(ISNULL(NULLIF(convert(float,a.currentamount),1),1))[AvgSettlementPct]
	,sum(settlementfee)[TotalSettlementFees]
	FROM tblSettlements AS sett 
	inner join tblaccount a on a.accountid = sett.creditoraccountid
	inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor cur on cur.creditorid = ci.creditorid
	WHERE   sett.status = 'a' and active = 1
	AND YEAR(sett.Created) = @year AND MONTH(sett.Created) = @month and (cur.name like @creditorName or @creditorName is null)
	group by cur.name
	order by cur.name
END




GO


GRANT EXEC ON stp_Report_CreditorTrends TO PUBLIC

GO


