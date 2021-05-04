IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_ActivatePayments')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_ActivatePayments
	END

GO

CREATE Procedure stp_PaymentArrangement_ActivatePayments
@Date datetime,
@UserId int
AS
Begin
	Declare @PmtScheduleId int,
			@SettlementId int,
			@MatterId int,
			@PmtDate datetime,
			@PmtAmount money,
			@Note varchar(max),
			@result bit
			
	Select @result = 0
	
	DECLARE sched_pmts CURSOR FOR
	Select pa.PmtScheduleId, pa.SettlementId, pa.PmtDate, pa.PmtAmount, pa.Matterid
	from
	(select ps.*, s.matterid, [Position] = rank() over (partition by ps.settlementid  order by ps.pmtdate)
	from tblpaymentschedule ps
	join tblsettlements s on s.settlementid = ps.settlementid and s.active = 1
	join tblmatter m on m.matterid = s.matterid and m.matterstatusid not in (2,4) and m.isdeleted = 0
	join tblclient c on c.clientid = s.clientid and c.currentclientstatusid in (14,16)
	left join tblaccount_paymentprocessing acc on acc.paymentprocessingid = ps.paymentprocessingid
	where ps.deleted is null
	and ps.paymentprocessingid is null
	and m.mattersubstatusid in (96) -- P.A. There must be only one P.A. per matter open at a time
	and ps.pmtdate >= cast(convert(varchar(10),@Date,120) as datetime) -- Not greater than today
	and convert(varchar(6),ps.pmtdate,112) = convert(varchar(6),@Date,112) -- Only for the current month
	) pa
	where pa.[Position] = 1
	order by pa.pmtdate
	
	Open sched_pmts

	Fetch Next From sched_pmts Into @PmtScheduleId, @SettlementId, @PmtDate, @PmtAmount, @MatterId

	While @@FETCH_STATUS = 0
	Begin
		select @Note = 'A payment arrangement for matter ' + convert(varchar, @MatterId) + ' has been activated'
		
		Begin Try
			exec stp_PaymentArrangement_ActivateOnePayment @PmtScheduleId, @SettlementId, @PmtDate, @PmtAmount, @Note, @UserId
			print 'Payment Schedule ' + convert(varchar, @PmtScheduleId) + ' added successfully'
		end try
		Begin Catch
			select result = -1
			print 'Payment Schedule ' + convert(varchar, @PmtScheduleId) + ' activation attempt has failed'
		End Catch
		
		Fetch Next From sched_pmts Into @PmtScheduleId, @SettlementId, @PmtDate, @PmtAmount, @MatterId
	End
	Close sched_pmts
	Deallocate sched_pmts

	Return @result
	
End

GO


