if exists (select * from sysobjects where name = '__TheCor_stp_PayCommission')
	drop procedure __TheCor_stp_PayCommission
go

create procedure [dbo].[__TheCor_stp_PayCommission]
(
	@registerpaymentid int,
	@clientid int = null,
	@companyid int = null,
	@enrolled datetime = null,
	@agencyid int = null
)

as

set nocount on
set ansi_warnings off

BEGIN TRY
	declare @commscenid int
	declare @amounttotal money
	declare @amountpaid money
	declare @amountremaining money
	declare @percentremaining money
	declare @defaultcommscenid int
	declare @entrytypeid int
	declare @paymentamount money

	if @clientid is null
	begin
		SELECT
			@clientid = c.ClientID,
			@companyid = c.CompanyID,
			@enrolled = c.Created,
			@agencyid = c.AgencyID
		FROM
			tblRegisterPayment as rp
			inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
			inner join tblClient as c on c.ClientID = r.ClientID
		WHERE
			rp.RegisterPaymentID = @registerpaymentid
	end

	if @agencyid is not null
	begin
		SELECT
			@entrytypeid = r.EntryTypeID,
			@paymentamount = isnull(rp.Amount, 0)
		FROM
			tblRegisterPayment as rp
			inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		WHERE
			rp.RegisterPaymentID = @registerpaymentid

		SELECT
			@defaultcommscenid = CommScenID
		FROM
			tblCommScen
		WHERE
			[default] = 1

		SELECT
			@commscenid = CommScenID
		FROM
			tblCommScen
		WHERE
			AgencyID = @agencyid
			and StartDate <= @enrolled and
			(
				EndDate is null
				or EndDate >= cast(convert(char(10), @enrolled, 101) as datetime)
			)

		if @commscenid is null
		begin
			set @commscenid = @defaultcommscenid
		end

		if @commscenid is not null
		begin
			print 'Pay Commission For Scenario: ' + cast(@commscenid as nvarchar(10))

			exec __TheCor_stp_PayCommissionRec @registerpaymentid, @commscenid, @companyid, @entrytypeid, @paymentamount
		end
	end

	SELECT
		@amounttotal = isnull(rp.Amount, 0),
		@amountpaid = isnull(sum(cp.Amount), 0)
	FROM
		tblRegisterPayment as rp
		left join tblCommPay as cp on cp.RegisterPaymentID = rp.RegisterPaymentID
	WHERE
		rp.RegisterPaymentID = @registerpaymentid
	GROUP BY
		rp.Amount

	if @amounttotal = 0
	begin
		print 'Error: Divide by Zero! Client: ' + cast(@clientid as nvarchar(25))
	end
	else
	begin
		set @amountremaining = @amounttotal - @amountpaid
		set @percentremaining = @amountremaining / @amounttotal

		if @amountremaining > 0
		begin
			declare @percenttotal money

			SELECT
				@percenttotal = isnull(sum(cf.[Percent]), 0)
			FROM
				tblCommFee as cf
				inner join tblCommStruct as cs on cs.CommStructID = cf.CommStructID
			WHERE
				cf.EntryTypeID = @entrytypeid
				and cs.CommScenID = @commscenid
				and cs.CompanyID = @companyid
				and cf.IsPercent = 1

			--  If the total percent used is 100, then all overages should be small (penny or two)
			--  and should be assigned to the last recipient.
			if @percenttotal = 1
			begin
				UPDATE
					tblCommPay
				SET
					Amount = Amount + @amountremaining
				WHERE
					CommPayID =
						(
							SELECT TOP 1
								isnull(CommPayID, -1)
							FROM
								tblCommPay
							WHERE
								RegisterPaymentID = @registerpaymentid
							ORDER BY
								CommPayID desc
						)

				print 'Disbursing Remaining ' + cast(@amountremaining as nvarchar(10)) + ' To Last CommRec'
			end
			else
			begin
				-- If the total percent used is not equal to 100, then any overage is planned and
				-- should go to the default commission structure
				if @defaultcommscenid is not null and @entrytypeid is not null
				begin
					declare @defaultcommstructid int

					SELECT
						@defaultcommstructid = cs.CommStructID
					FROM
						tblCommFee as cf
						inner join tblCommStruct as cs on cs.CommStructID = cf.CommStructID
					WHERE
						cs.CommScenID = @defaultcommscenid
						and cf.EntryTypeID = @entrytypeid
						and cs.CompanyID = @companyid

					if @defaultcommstructid is not null
					begin
						INSERT INTO
							tblCommPay
							(
								RegisterPaymentID,
								CommStructID,
								[Percent],
								Amount
							)
						VALUES
							(
								@registerpaymentid,
								@defaultcommstructid,
								@percentremaining,
								@amountremaining
							)
					end

					print 'Disbursing Remaining ' + cast(@amountremaining as nvarchar(10)) + ' To Default'
				end
			end
		end
	end

	print ''
END TRY
BEGIN CATCH
	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH