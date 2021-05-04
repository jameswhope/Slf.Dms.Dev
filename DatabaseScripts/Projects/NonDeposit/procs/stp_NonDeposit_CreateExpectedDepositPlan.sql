IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_CreateExpectedDepositPlan')
	BEGIN
		DROP  Procedure  stp_NonDeposit_CreateExpectedDepositPlan
	END

GO

CREATE Procedure stp_NonDeposit_CreateExpectedDepositPlan
@date datetime,
@userid int
AS
begin

-- stp_NonDeposit_CreateExpectedDepositPlan
---- stp_NonDeposit_CreateExpectedDepositPlanACH, stp_NonDeposit_CreateExpectedDepositPlanCheck
-- Run Processes
-- Returns
-- stp_NonDeposit_MatchPlanACH
-- stp_NonDeposit_MapChecksFIFO
-- stp_NonDeposit_MatchBounceCheck
-- Create NonDeposit Matter (Do)) Send the Letter
-- stp_NonDeposit_ReOpenMatterForMissedReplacement 
-- stp_NonDeposit_CloseMattersDue

--ACHs
if (SELECT count(*) FROM tblBankHoliday WHERE cast(convert(varchar(50), [Date], 101) as datetime) = cast(convert(varchar(50), @date, 101) as datetime)) > 0 or lower(datename(dw, @date)) = 'saturday' or lower(datename(dw, @date)) = 'sunday'
	print cast(@date as nvarchar(25)) + ' is a NO BANK day. Skip planned ach record creation for today';
else
	begin
	
		--Do next day while a business day
		Declare @achdate datetime set @achdate = dateadd(d, 1, @date)
		While (1=1)
			begin
				print 'Creating planned ach records for ' + cast(@achdate as nvarchar(25));
				exec stp_NonDeposit_CreateExpectedDepositPlanACH @achdate, @userid
				if (SELECT count(*) FROM tblBankHoliday WHERE cast(convert(varchar(50), [Date], 101) as datetime) = cast(convert(varchar(50), @achdate, 101) as datetime)) > 0 or lower(datename(dw, @achdate)) = 'saturday' or lower(datename(dw, @achdate)) = 'sunday'
					select @achdate = dateadd(d, 1, @achdate)
				else
					break
			end
	end
	
--Checks
	print 'Creating planned Check records for ' + cast(@date as nvarchar(25));
	exec stp_NonDeposit_CreateExpectedDepositPlanCheck @date, @userid

end

GO

 
