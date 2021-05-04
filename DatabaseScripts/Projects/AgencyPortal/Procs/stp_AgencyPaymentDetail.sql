-- select dbo.udf_DatePartStart('q', '9/4/2008')
-- select dbo.udf_DatePartName('m', '9/1/08')
-- stp_AgencyPaymentDetail 'other', 'Chargeback', '5/1/08', '10/31/08', 'm', 'Sep-08'

if exists (select * from sysobjects where name = 'stp_AgencyPaymentDetail')
	drop procedure stp_AgencyPaymentDetail
go

create procedure stp_AgencyPaymentDetail
(
	@payment varchar(20),
	@type varchar(20),
	@startdate datetime,
	@enddate datetime,
	@dateperiod char(1),
	@datepartname varchar(20),
	@UserID int,
	@companyid int = -1
)
AS
BEGIN


if @payment = 'first' begin

	select dp.registerpaymentid 
	into #dpt
	from tblregisterpaymentdeposit dp 
	join vw_initialdrafts df on df.registerid = dp.depositregisterid
	join tblclient c on c.clientid = df.clientid
	join tbluserclientaccess uc on uc.userid = @UserID and c.created between uc.clientcreatedfrom and uc.clientcreatedto
	join tblusercompanyaccess uca on uca.userid = uc.userid and (@companyid = -1 or uca.companyid = @companyid)

	if @type = 'Gross Fee Payments' begin

		-- Initial Draft Income
		select cr.display [Recipient], t.displayname [Fee], sum(cp.amount) [Amount]
		from tblcommpay cp
		join tblcommbatch b on b.commbatchid = cp.commbatchid 
			and b.batchdate >= @startDate and b.batchdate < @enddate
			and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
		join #dpt dpi on dpi.registerpaymentid = cp.registerpaymentid
		join tblcommstruct cs on cs.commstructid = cp.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
		join tblcommrec cr on cr.commrecid = cs.commrecid
		join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
		join tblregister r on r.registerid = rp.feeregisterid
		join tblentrytype t on t.entrytypeid = r.entrytypeid
		group by cr.display, t.displayname
		order by cr.display, t.displayname

	end
	else if @type = 'Chargeback' begin

		-- Initial Draft Chargebacks
		select cr.display [Recipient], t.displayname [Fee], sum(cb.amount) [Amount]
		from tblcommchargeback cb
		join tblcommbatch b on b.commbatchid = cb.commbatchid 
			and b.batchdate >= @startDate and b.batchdate < @enddate
			and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
		join #dpt dpi on dpi.registerpaymentid = cb.registerpaymentid
		join tblcommstruct cs on cs.commstructid = cb.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
		join tblcommrec cr on cr.commrecid = cs.commrecid
		join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
		join tblregister r on r.registerid = rp.feeregisterid
		join tblentrytype t on t.entrytypeid = r.entrytypeid
		group by cr.display, t.displayname
		order by cr.display, t.displayname

	end
	else if @type = 'Net Fee Payments' begin

		select Recipient, Fee, sum(Amount) [Amount]
		from (
			-- Initial Draft Income
			select cr.display [Recipient], t.displayname [Fee], cp.Amount
			from tblcommpay cp
			join tblcommbatch b on b.commbatchid = cp.commbatchid 
				and b.batchdate >= @startDate and b.batchdate < @enddate
				and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
			join #dpt dpi on dpi.registerpaymentid = cp.registerpaymentid
			join tblcommstruct cs on cs.commstructid = cp.commstructid
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
			join tblcommrec cr on cr.commrecid = cs.commrecid
			join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
			join tblregister r on r.registerid = rp.feeregisterid
			join tblentrytype t on t.entrytypeid = r.entrytypeid

			union all

			-- Initial Draft Chargebacks
			select cr.display [Recipient], t.displayname [Fee], -cb.Amount
			from tblcommchargeback cb
			join tblcommbatch b on b.commbatchid = cb.commbatchid 
				and b.batchdate >= @startDate and b.batchdate < @enddate
				and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
			join #dpt dpi on dpi.registerpaymentid = cb.registerpaymentid
			join tblcommstruct cs on cs.commstructid = cb.commstructid
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
			join tblcommrec cr on cr.commrecid = cs.commrecid
			join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
			join tblregister r on r.registerid = rp.feeregisterid
			join tblentrytype t on t.entrytypeid = r.entrytypeid

		) dev
		group by Recipient, Fee
		order by Recipient, Fee

	end

	drop table #dpt
end
else if @payment = 'other' begin

	select distinct dp.registerpaymentid 
	into #dpt2
	from tblregisterpaymentdeposit dp 
	left join vw_initialdrafts df on df.registerid = dp.depositregisterid
	join tblregister r on r.registerid = dp.depositregisterid
	join tblclient c on c.clientid = r.clientid
	join tbluserclientaccess uc on uc.userid = @UserID and c.created between uc.clientcreatedfrom and uc.clientcreatedto
	join tblusercompanyaccess uca on uca.userid = uc.userid and (@companyid = -1 or uca.companyid = @companyid)
	where df.registerid is null

	if @type = 'Gross Fee Payments' begin

		-- All Other Payment Income
		select cr.display [Recipient], t.displayname [Fee], sum(cp.amount) [Amount]
		from tblcommpay cp
		join tblcommbatch b on b.commbatchid = cp.commbatchid 
			and b.batchdate >= @startDate and b.batchdate < @enddate
			and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
		join #dpt2 dpi on dpi.registerpaymentid = cp.registerpaymentid
		join tblcommstruct cs on cs.commstructid = cp.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
		join tblcommrec cr on cr.commrecid = cs.commrecid
		join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
		join tblregister r on r.registerid = rp.feeregisterid
		join tblentrytype t on t.entrytypeid = r.entrytypeid
		group by cr.display, t.displayname
		order by cr.display, t.displayname

	end
	else if @type = 'Chargeback' begin

		-- All Other Payment Chargebacks
		select cr.display [Recipient], t.displayname [Fee], sum(cb.amount) [Amount]
		from tblcommchargeback cb
		join tblcommbatch b on b.commbatchid = cb.commbatchid 
			and b.batchdate >= @startDate and b.batchdate < @enddate
			and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
		join #dpt2 dpi on dpi.registerpaymentid = cb.registerpaymentid
		join tblcommstruct cs on cs.commstructid = cb.commstructid
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
		join tblcommrec cr on cr.commrecid = cs.commrecid
		join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
		join tblregister r on r.registerid = rp.feeregisterid
		join tblentrytype t on t.entrytypeid = r.entrytypeid
		group by cr.display, t.displayname
		order by cr.display, t.displayname

	end
	else if @type = 'Net Fee Payments' begin

		select Recipient, Fee, sum(Amount) [Amount]
		from (
			-- All Other Payment Income
			select cr.display [Recipient], t.displayname [Fee], cp.Amount
			from tblcommpay cp
			join tblcommbatch b on b.commbatchid = cp.commbatchid 
				and b.batchdate >= @startDate and b.batchdate < @enddate
				and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
			join #dpt2 dpi on dpi.registerpaymentid = cp.registerpaymentid
			join tblcommstruct cs on cs.commstructid = cp.commstructid
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
			join tblcommrec cr on cr.commrecid = cs.commrecid
			join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
			join tblregister r on r.registerid = rp.feeregisterid
			join tblentrytype t on t.entrytypeid = r.entrytypeid

			union all

			-- All Other Payment Chargebacks
			select cr.display [Recipient], t.displayname [Fee], -cb.Amount
			from tblcommchargeback cb
			join tblcommbatch b on b.commbatchid = cb.commbatchid 
				and b.batchdate >= @startDate and b.batchdate < @enddate
				and dbo.udf_DatePartName(@dateperiod, b.batchdate) = @datepartname
			join #dpt2 dpi on dpi.registerpaymentid = cb.registerpaymentid
			join tblcommstruct cs on cs.commstructid = cb.commstructid
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
			join tblcommrec cr on cr.commrecid = cs.commrecid
			join tblregisterpayment rp on rp.registerpaymentid = dpi.registerpaymentid
			join tblregister r on r.registerid = rp.feeregisterid
			join tblentrytype t on t.entrytypeid = r.entrytypeid

		) dev
		group by Recipient, Fee
		order by Recipient, Fee

	end

	drop table #dpt2
end


END