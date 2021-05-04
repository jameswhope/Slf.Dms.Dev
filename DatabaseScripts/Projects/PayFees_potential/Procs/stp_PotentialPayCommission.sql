
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PotentialPayCommission')
	BEGIN
		DROP Procedure stp_PotentialPayCommission
	END
GO 

create procedure [dbo].[stp_PotentialPayCommission]
(
	@registerpaymentid int,
	@clientid int
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
declare @clientenrolled datetime
declare @agencyid int
declare @commscenid int
declare @percenttotal money
declare @amounttotal money
declare @amountpaid money
declare @amountleft money
declare @defaultcommscenid int
declare @defaultcommstructid int
declare @percentleft money
declare @parentcommrecid int
declare @CompanyID int
declare @entrytypeid int
declare @retention int


-- get created date for client
select
	@clientenrolled = created,
	@CompanyID = CompanyID,
	@agencyid = agencyid
from
	tblclient
where
	clientid = @clientid

	
select @retention = datediff(m,@clientenrolled,getdate())

if (day(@clientenrolled) > day(getdate())) begin
	set @retention = @retention - 1
end		


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
	end

-- assuming a commission scenario (or default commscen) was found for this client....
if not @commscenid is null
	begin
		set @parentcommrecid = null
		
		select @parentcommrecid = r.commrecid
		from tblclient c 
		join tblcommrec r on r.companyid = c.companyid
		where c.clientid = @clientid and r.istrust = 1 and not c.companyid is null

		-- (3) recursively loop recipients in the structure for this
		--     commission scenario and write out payments
		exec stp_PotentialPayCommissionRec @registerpaymentid, @commscenid, @parentcommrecid, @CompanyID

	end 



-- (4) Check for unused overages -- don't really need to factor this in
select
	@amounttotal = coalesce(amount, 0)
from
	tblpotentialregisterpaymenttmp
where
	registerpaymentid = @registerpaymentid

select
	@amountpaid = coalesce(sum(amount), 0)
from
	#commpaytmp
where
	registerpaymentid = @registerpaymentid

/*if (@amounttotal > 0)
begin
	set @amountleft = @amounttotal - @amountpaid
	set @percentleft = @amountleft / @amounttotal

	if @amountleft > .01 
		begin
			-- due to incomplete scenarios, even the default scenario is incomplete
			select @entrytypeid = r.entrytypeid from tblpotentialregistertmp r join tblpotentialregisterpaymenttmp rp on rp.feeregisterid = r.registerid and rp.registerpaymentid = @registerpaymentid
			
			print 'amount left ' + cast(@amountleft as varchar(10)) + ' commscenid ' + cast(@commscenid as varchar(5)) + ' entrytypeid ' + cast(@entrytypeid as varchar(5)) + ' company ' + cast(@companyid as varchar(5))
		end

end*/
GO
 