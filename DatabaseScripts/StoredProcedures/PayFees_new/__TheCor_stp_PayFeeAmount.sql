if exists (select * from sysobjects where name = '__TheCor_stp_PayFeeAmount')
	drop procedure __TheCor_stp_PayFeeAmount
go

create procedure [dbo].[__TheCor_stp_PayFeeAmount]
(
	@registerid int,
	@amount money,
	@clientid int = null,
	@companyid int = null,
	@enrolled datetime = null,
	@agencyid int = null
)

as

set nocount on
set ansi_warnings off

BEGIN TRY
	declare @registerpaymentid int
	declare @depositneeded money

	declare @depositid int
	declare @depositremaining money

	if @clientid is null
	begin
		SELECT
			@clientid = ClientID
		FROM
			tblRegister
		WHERE
			RegisterID = @registerid
	end

	INSERT INTO
		tblRegisterPayment
		(
			PaymentDate,
			FeeRegisterID,
			Amount
		)
	VALUES
		(
			getdate(),
			@registerid,
			@amount
		)

	set @registerpaymentid = scope_identity()

	set @depositneeded = @amount

	print 'Deposit Needed: ' + cast(@depositneeded as nvarchar(15))

	while @depositneeded > 0
	begin
		set @depositid = null

		SELECT TOP 1
			@depositid = RegisterID
		FROM
			tblRegister
		WHERE
			IsFullyPaid = 0
			and Void is null
			and Bounce is null
			and ClientID = @clientid
			and AdjustedRegisterID is null
			and Amount > 0 and
			(
				Hold is null
				or Hold <= getdate()
				or [Clear] >= getdate()
			)
		ORDER BY
			TransactionDate,
			RegisterID

		if @depositid is not null
		begin
			set @depositremaining = 0

			SELECT
				@depositremaining = isnull(r.Amount, 0) - isnull(sum(rpd.Amount), 0)
			FROM
				tblRegister as r
				left join tblRegisterPaymentDeposit as rpd on rpd.DepositRegisterID = r.RegisterID and rpd.Voided = 0 and rpd.Bounced = 0
			WHERE
				r.RegisterID = @depositid
			GROUP BY
				r.Amount

			print 'Deposit Remaining: ' + cast(@depositremaining as nvarchar(15))

			if @depositremaining <= @depositneeded
			begin
				INSERT INTO
					tblRegisterPaymentDeposit
					(
						RegisterPaymentID,
						DepositRegisterID,
						Amount
					)
				VALUES
					(
						@registerpaymentid,
						@depositid,
						@depositremaining
					)

				set @depositneeded = @depositneeded - @depositremaining

				UPDATE
					tblRegister
				SET
					IsFullyPaid = 1
				WHERE
					RegisterID = @depositid

				print 'Payed: ' + cast(@depositremaining as nvarchar(15))
			end
			else
			begin
				INSERT INTO
					tblRegisterPaymentDeposit
					(
						RegisterPaymentID,
						DepositRegisterID,
						Amount
					)
				VALUES
					(
						@registerpaymentid,
						@depositid,
						@depositneeded
					)

				print 'Payed: ' + cast(@depositneeded as nvarchar(15))

				set @depositneeded = 0
			end
		end
		else
		begin
			print 'Break - no available deposit!'

			break
		end

		print 'Deposit Needed: ' + cast(@depositneeded as nvarchar(15))
	end

	exec __TheCor_stp_PayCommission @registerpaymentid, @clientid, @companyid, @enrolled, @agencyid
END TRY
BEGIN CATCH
	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH