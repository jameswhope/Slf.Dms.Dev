ALTER procedure [dbo].[stp_PayCommission]
(
	@registerpaymentid int
)
as


-------------------------------------------------------------------------------------------------------
-- LOGIC FOR COMMISSION PAYMENT:
-- (1) Find client for this payment
-- (2) Find commission scenario for client.  If commission scenario is not found, use
--     the default commission scenario
-- (3) In order (RLTD), loop through recipient recursively and fire off commissions to be paid
-- (4) After looping and handing out commissions, check to make sure that there isn't a small
--     overage left to be assigned
--     (a) find and fill the entrytypeid of this payment
--     (b) find and fill total percent for this commscen and fee type
--     (c) If the total percent used is 100, then all overages should be small (penny or two)
--         and should be assigned to the last recipient.
--     (d) If the total percent used is not equal to 100, then any overage is planned and
--         should go to the default commission structure
-------------------------------------------------------------------------------------------------------


-- discretionary variables
declare @clientid int
declare @clientenrolled datetime
declare @agencyid int
declare @commscenid int

declare @percenttotal money
declare @amounttotal money
declare @amountpaid money
declare @amountleft money
declare @lastcommpayid int

declare @defaultcommscenid int
declare @defaultcommstructid int
declare @entrytypeid int
declare @percentleft money
declare @parentcommrecid int
declare @CompanyID int
declare @retention int


-- (1) get client
select
	@clientid = clientid
from
	tblregisterpayment inner join
	tblregister on tblregisterpayment.feeregisterid = tblregister.registerid
where
	tblregisterpayment.registerpaymentid = @registerpaymentid


-- get created date for client
select
	@clientenrolled = created,
	@CompanyID = CompanyID,
	@agencyid = agencyid
from
	tblclient
where
	clientid = @clientid	


-- assuming a client was found...
if not @clientid is null
	begin
	
		select @retention = datediff(m,@clientenrolled,getdate())

		if (day(@clientenrolled) > day(getdate())) begin
			set @retention = @retention - 1
		end	

		-- assuming an agency was found for this client...
		if not @agencyid is null
			begin

				-- (2) get commission scenario
				select
					@commscenid = commscenid
				from
					tblcommscen
				where
					agencyid = @agencyid and
					startdate <= @clientenrolled and
					(
						enddate is null or
						enddate >= cast(convert(char(10), @clientenrolled, 101) as datetime)
					) and
					@retention between retentionfrom and retentionto

				-- get default commission scenario if there is no commscen found for this client
				if @commscenid is null
					begin
						select
							@commscenid = commscenid
						from
							tblcommscen
						where
							[default] = 1
							
						-- Log
						insert tblDefaultScenarioLog (ClientID,ClientEnrolled,AgencyID,RegisterPaymentID) values (@clientid,@clientenrolled,@agencyid,@registerpaymentid)
					end

				-- assuming a commission scenario (or default commscen) was found for this client....
				if not @commscenid is null
					begin
						set @parentcommrecid = null
						
						select @parentcommrecid = r.commrecid
						from tblclient c 
						inner join tblcommrec r on r.companyid = c.companyid
						where c.clientid = @clientid and r.istrust = 1 and not c.companyid is null

						-- (3) recursively loop recipients in the structure for this
						--     commission scenario and write out payments
						exec stp_PayCommissionRec @registerpaymentid, @commscenid, @parentcommrecid, @CompanyID

					end -- comm scen exists
			end -- agency exists
	end -- client exists


-- (4) Check for unused overages
select
	@amounttotal = coalesce(amount, 0)
from
	tblregisterpayment
where
	registerpaymentid = @registerpaymentid

select
	@amountpaid = coalesce(sum(amount), 0)
from
	tblcommpay
where
	registerpaymentid = @registerpaymentid

if (@amounttotal = 0)
begin
	declare @cmdtxt varchar(255)
	set @cmdtxt = 'echo ' + cast(getdate() as nvarchar(25)) + ' Error: Divide by Zero! Client: ' + cast(@clientid as nvarchar(25)) + ' >> \\Nas01\process\Service_Logs\PayFee_Log.log'
	exec master..xp_cmdshell @cmdtxt
	print 'Error: Divide by zero!'
end
else
begin
	set @amountleft = @amounttotal - @amountpaid
	set @percentleft = @amountleft / @amounttotal


	if @amountleft > 0
		begin

			-- (4.a) find and fill the entrytypeid of this payment
			select
				@entrytypeid = tblregister.entrytypeid
			from
				tblregisterpayment inner join
				tblregister on tblregisterpayment.feeregisterid = tblregister.registerid
			where
				tblregisterpayment.registerpaymentid = @registerpaymentid


			-- (4.b) find and fill total percent for this commscen and fee type
			select
				@percenttotal = isnull(sum(cf.[percent]), 0)
			from
				tblcommfee cf 
				join tblcommstruct cs on cf.commstructid = cs.commstructid
			where
				cf.entrytypeid = @entrytypeid
				and cs.commscenid = @commscenid
				and cs.companyid = @companyid


			-- (4.c) determine if total percent is 100% - meaning all should have gone to recipients
			if @percenttotal = 1
				begin

					-- if any positive amount is left, give it to the last recipient for this payment
					select top 1
						@lastcommpayid = commpayid
					from
						tblcommpay
					where
						registerpaymentid = @registerpaymentid
					order by
						commpayid desc

					update
						tblcommpay
					set
						amount = amount + @amountleft
					where
						commpayid = @lastcommpayid

				end
			else -- (4.d)
				begin

					-- find and fill the default comm scenario
					select
						@defaultcommscenid = commscenid
					from
						tblcommscen
					where
						[default] = 1

					if not @defaultcommscenid is null and not @entrytypeid is null
						begin

							-- linking from the default commscen, grab the first commstruct that has the same fee type of this payment
							select
								@defaultcommstructid = tblcommstruct.commstructid
							from
								tblcommfee
								join tblcommstruct on tblcommfee.commstructid = tblcommstruct.commstructid
								join tblcommscen on tblcommstruct.commscenid = tblcommscen.commscenid
							where
								tblcommscen.commscenid = @defaultcommscenid
								and tblcommfee.entrytypeid = @entrytypeid
								and tblcommstruct.companyid = @companyid


							if not @defaultcommstructid is null
								begin

									-- write out payment
									insert into tblcommpay
									(
										registerpaymentid,
										commstructid,
										[percent],
										amount
									)
									values
									(
										@registerpaymentid,
										@defaultcommstructid,
										@percentleft,
										@amountleft
									)
								end

					end -- @defaultcommstructid is null
				end -- not @percenttotal = 100
		end -- amountleft > 0

end
GO
