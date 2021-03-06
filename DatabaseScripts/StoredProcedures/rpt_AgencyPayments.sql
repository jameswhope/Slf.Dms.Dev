/****** Object:  StoredProcedure [dbo].[rpt_AgencyPayments]    Script Date: 11/19/2007 15:26:49 ******/
DROP PROCEDURE [dbo].[rpt_AgencyPayments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_AgencyPayments]
(
	@startdate VARCHAR(10) = null, 
	@enddate VARCHAR(10) = null, 
	@commrecid VARCHAR(10) = null, 
	@OrderBY VARCHAR(30)
)

AS

DECLARE @sql VARCHAR(8000)

--order by payment date, payment ount, batch date, comm amount.


create table #AgencyPayments
(
	RegisterPaymentID int null,
	Agency VARCHAR(255) null,
	Abbreviation VARCHAR(10) NULL,
	AccountNumber VARCHAR(10) NULL,
	[Client Name] VARCHAR(200) NULL,
	[Trans Type] VARCHAR(20) NULL,
	[Creditor Name] VARCHAR(200) NULL,
	[Payment Date] VARCHAR(10) NULL,
	Amount MONEY NULL,
	CompanyID INT NULL,
	[Commission Amount] MONEY NULL,
	[Comm Percentage] MONEY NULL,
	[Batch Date] VARCHAR(10) NULL	
)



INSERT INTO #AgencyPayments
select	rp.registerpaymentid [Pymt ID],
		a.name[Agency],
		cr.Abbreviation [Comm Rec],
		c.accountnumber,
		p.firstname + ' ' + p.lastname as [Client Name],
		[Trans Type] =	CASE 
							WHEN r.entrytypeid = 42 THEN '(2%) ' + e.name + ' Pymt'
							WHEN r.entrytypeid = 2 THEN '(8%) ' + e.name + ' Pymt'
							ELSE e.name + ' Pymt'
						END,
		[Cred Name] =	coalesce(c2.[Name], c1.[Name], ' '),
		convert(varchar, rp.paymentdate, 101) as [Pymt Date], 
		rp.amount as [Pymt Amount], 
		cp.commpayid [CP ID], 
		cp.amount as [Comm Amt],
		cp.[percent] as [Comm %],
		convert(varchar, cb.batchdate, 101) as [Batch Date]
from tblregisterpayment rp 
inner join tblregister r on rp.feeregisterid = r.registerid
inner join tblcommpay cp on cp.registerpaymentid = rp.registerpaymentid
inner join tblcommstruct cs on cp.commstructid = cs.commstructid
left join tblcommbatch cb on cp.commbatchid = cb.commbatchid
inner join tblclient c on r.clientid = c.clientid
inner join tblperson p on c.primarypersonid = p.personid
inner join tblagency a on c.agencyid = a.agencyid
inner join tblcommrec cr on cs.commrecid = cr.commrecid
inner join tblentrytype e on r.entrytypeid = e.entrytypeid
left join tblaccount act on r.accountid = act.accountid
left join tblcreditorinstance I on act.currentcreditorinstanceid = I.creditorinstanceid
left join tblcreditor c1 on I.creditorid = c1.creditorid
left join tblcreditor c2 on I.forcreditorid = c2.creditorid
where cb.batchdate >= @startdate
and cb.batchdate < @enddate
and cs.commrecid = @commrecid

union all

select	rp.registerpaymentid [Pymt ID],
		a.name[Agency],
		cr.Abbreviation [Comm Rec],
		c.accountnumber,
		p.firstname + ' ' + p.lastname as [Client Name],
		[Trans Type] =	CASE 
							WHEN r.entrytypeid = 42 THEN '(2%) ' + e.name + ' Pymt'
							WHEN r.entrytypeid = 2 THEN '(8%) ' + e.name + ' Pymt'
							ELSE e.name + ' Pymt'
						END,
		[Cred Name] =	coalesce(c2.[Name], c1.[Name], ' '),
		convert(varchar, rp.paymentdate, 101) as [Pymt Date], 
		rp.amount as [Pymt Amount], 
		cc.commpayid [CP ID], 
		-cc.amount as [Comm Amt],
		cc.[percent] as [Comm %],
		convert(varchar, cb.batchdate, 101) as [Batch Date]
from tblregisterpayment rp 
inner join tblregister r on rp.feeregisterid = r.registerid
inner join tblcommchargeback cc on cc.registerpaymentid = rp.registerpaymentid
inner join tblcommstruct cs on cc.commstructid = cs.commstructid
left join tblcommbatch cb on cc.commbatchid = cb.commbatchid
inner join tblclient c on r.clientid = c.clientid
inner join tblperson p on c.primarypersonid = p.personid
inner join tblagency a on c.agencyid = a.agencyid
inner join tblcommrec cr on cs.commrecid = cr.commrecid
inner join tblentrytype e on r.entrytypeid = e.entrytypeid
left join tblaccount act on r.accountid = act.accountid
left join tblcreditorinstance I on act.currentcreditorinstanceid = I.creditorinstanceid
left join tblcreditor c1 on I.creditorid = c1.creditorid
left join tblcreditor c2 on I.forcreditorid = c2.creditorid
where cb.batchdate >= @startdate
and cb.batchdate < @enddate
and cs.commrecid = @commrecid

SET @sql = 'SELECT * FROM #agencypayments '
IF @OrderBY IS NOT NULL
BEGIN
	SET @sql = @sql + 'Order BY ' + @OrderBy
END

EXEC (@sql)

DROP TABLE #AgencyPayments
GO
