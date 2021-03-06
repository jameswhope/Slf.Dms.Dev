if exists (select * from sysobjects where name = '__TheCor_stp_PayFee')
	drop procedure __TheCor_stp_PayFee
go

create procedure [dbo].[__TheCor_stp_PayFee]
(
	@registerid int,
	@clientid int = null,
	@companyid int = null,
	@feeremaining money = null,
	@enrolled datetime = null,
	@agencyid int = null
)

as

set nocount on
set ansi_warnings off

--BEGIN TRANSACTION
BEGIN TRY
	declare @deposittotal money
	declare @depositused money
	declare @nonfeedebits money
	declare @depositavailable money

	if @clientid is null
	begin
		SELECT
			@clientid = r.ClientID,
			@companyid = c.CompanyID,
			@feeremaining = isnull(abs(r.Amount), 0) - isnull(sum(rp.Amount), 0)
		FROM
			tblRegister as r
			inner join tblRegisterPayment as rp on rp.FeeRegisterID = r.RegisterID and rp.Voided = 0 and rp.Bounced = 0
			inner join tblClient as c on c.ClientID = r.ClientID
		WHERE
			r.RegisterID = @registerid
		GROUP BY
			r.ClientID,
			c.CompanyID,
			r.Amount
	end

	SELECT
		@deposittotal = isnull(sum(Amount), 0)
	FROM
		tblRegister
	WHERE
		Amount > 0 and
		ClientID = @clientid and
		(
			Hold is null
			or Hold <= getdate()
			or [Clear] <= getdate()
		)
		and Bounce is null
		and Void is null
		and AdjustedRegisterID is null

	if @deposittotal = 0
	begin
		return @clientid
	end

	SELECT
		@depositused = isnull(sum(rpd.Amount), 0)
	FROM
		tblRegister as r
		inner join tblRegisterPaymentDeposit as rpd on rpd.DepositRegisterID = r.RegisterID
	WHERE
		rpd.Bounced = 0
		and rpd.Voided = 0
		and r.ClientID = @clientid

	SELECT
		@nonfeedebits = isnull(sum(abs(r.Amount)), 0)
	FROM
		tblRegister as r inner join
		tblEntryType as et on r.EntryTypeID = et.EntryTypeID
	WHERE
		r.ClientID = @clientid and
		r.Amount < 0 and
		et.Fee = 0 and
		r.Void is null and
		r.Bounce is null and
		r.AdjustedRegisterID is null

	set @depositavailable = @deposittotal - @depositused - @nonfeedebits

	print 'Fee: ' + cast(@feeremaining as nvarchar(15))
	print 'Deposit Available: ' + cast(@depositavailable as nvarchar(15))

	if @depositavailable > 0
	begin
		if @feeremaining <= @depositavailable
		begin
			exec __TheCor_stp_PayFeeAmount @registerid, @feeremaining, @clientid, @companyid, @enrolled, @agencyid

			UPDATE
				tblRegister
			SET
				IsFullyPaid = 1
			WHERE
				RegisterID = @registerid
		end
		else
		begin
			exec __TheCor_stp_PayFeeAmount @registerid, @depositavailable, @clientid, @companyid, @enrolled, @agencyid
		end
	end
	else
	begin
--		COMMIT TRANSACTION

		RETURN @clientid
	end

END TRY
BEGIN CATCH
--	ROLLBACK TRANSACTION

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH

--COMMIT TRANSACTION

RETURN 0