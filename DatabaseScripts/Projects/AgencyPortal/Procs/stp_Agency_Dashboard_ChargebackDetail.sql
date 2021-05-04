IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Agency_Dashboard_ChargebackDetail')
	BEGIN
		DROP  Procedure  stp_Agency_Dashboard_ChargebackDetail
	END

GO


CREATE procedure [dbo].[stp_Agency_Dashboard_ChargebackDetail]
(
	@payment varchar(20),
	@userid int,
	@startdate datetime,
	@enddate datetime,
	@dateperiod char(1),
	@datepartname varchar(20),
	@companyid int = -1
)
as
BEGIN
/*

USAGE:
stp_Agency_Dashboard_ChargebackDetail 'first',375,'11/1/2008','11/30/2008','m','Nov-08'
stp_Agency_Dashboard_ChargebackDetail 'other',375,'11/1/2008','11/30/2008','m','Nov-08'

DEVELOPMENT:
	declare @userid int
	declare @startdate datetime
	declare @enddate datetime
	declare @dateperiod char(1)
	declare @datepartname varchar(20)

	set @userid = 375
	set @startdate = '11/1/2008'
	set @enddate = '11/30/2008'
	set @dateperiod = 'm'
	set @datepartname = 'Nov-08'
*/

	
	if @payment = 'first' 
		begin
			select dp.registerpaymentid 
			into #tempRegPayments
			from tblregisterpaymentdeposit dp 
			join vw_initialdrafts df on df.registerid = dp.depositregisterid
			join tblregister r on r.registerid = dp.depositregisterid
			join tblclient c on c.clientid = r.clientid
			join tbluserclientaccess uc on uc.userid = @UserID and c.created between uc.clientcreatedfrom and uc.clientcreatedto
			join tblusercompanyaccess uca on uca.userid = uc.userid and (@companyid = -1 or uca.companyid = @companyid)

			select cr.display [Recipient], t.displayname [Fee]
			, case when vr.reason is null or vr.reason = '' then 'Not Known' else vr.reason end [Chargeback Reason]
			,sum(cb.amount) [Amount],p.firstname + ' ' + p.lastname [Client Name]
			from tblcommchargeback cb
			join tblcommbatch b on b.commbatchid = cb.commbatchid 
			and b.batchdate >= @startDate and b.batchdate < @enddate
			and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
			join #tempRegPayments dpi on dpi.registerpaymentid = cb.registerpaymentid
			join tblcommstruct cs on cs.commstructid = cb.commstructid
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
			join tblcommrec cr on cr.commrecid = cs.commrecid
			join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
			join tblregister r on r.registerid = rp.feeregisterid
			join tblperson p on p.clientid = r.clientid and p.relationship = 'Prime'
			join tblclient c on c.clientid = r.clientid
			join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto
			join tblentrytype t on t.entrytypeid = r.entrytypeid
			LEFT OUTER JOIN (SELECT Value, Amount, Reason FROM dbo.tblTransactionAudit WHERE (Type = N'register')) AS vr ON r.RegisterId = vr.Value 
			group by cr.display, t.displayname, case when vr.reason is null or vr.reason = '' then 'Not Known' else vr.reason end,p.firstname + ' ' + p.lastname
			order by cr.display, t.displayname

			drop table #tempRegPayments
		END
	if @payment = 'other' 
		BEGIN
			select distinct dp.registerpaymentid 
			into #tempRegPayments2
			from tblregisterpaymentdeposit dp 
			left join vw_initialdrafts df on df.registerid = dp.depositregisterid
			join tblregister r on r.registerid = dp.depositregisterid
			join tblclient c on c.clientid = r.clientid
			join tbluserclientaccess uc on uc.userid = @UserID and c.created between uc.clientcreatedfrom and uc.clientcreatedto
			join tblusercompanyaccess uca on uca.userid = uc.userid and (@companyid = -1 or uca.companyid = @companyid)
			where df.registerid is null

			select cr.display [Recipient], t.displayname [Fee]
			, case when vr.reason is null or vr.reason = '' then 'Not Known' else vr.reason end [Chargeback Reason]
			,sum(cb.amount) [Amount],p.firstname + ' ' + p.lastname [Client Name]
			from tblcommchargeback cb
			join tblcommbatch b on b.commbatchid = cb.commbatchid 
			and b.batchdate >= @startDate and b.batchdate < @enddate
			and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
			join #tempRegPayments2 dpi on dpi.registerpaymentid = cb.registerpaymentid
			join tblcommstruct cs on cs.commstructid = cb.commstructid
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
			join tblcommrec cr on cr.commrecid = cs.commrecid
			join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
			join tblregister r on r.registerid = rp.feeregisterid
			join tblperson p on p.clientid = r.clientid and p.relationship = 'Prime'
			join tblclient c on c.clientid = r.clientid
			join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto
			join tblentrytype t on t.entrytypeid = r.entrytypeid
			LEFT OUTER JOIN (SELECT Value, Amount, Reason FROM dbo.tblTransactionAudit WHERE (Type = N'register')) AS vr ON r.RegisterId = vr.Value 
			group by cr.display, t.displayname, case when vr.reason is null or vr.reason = '' then 'Not Known' else vr.reason end,p.firstname + ' ' + p.lastname
			order by cr.display, t.displayname

			drop table #tempRegPayments2
		END

	
END




GRANT EXEC ON stp_Agency_Dashboard_ChargebackDetail TO PUBLIC


