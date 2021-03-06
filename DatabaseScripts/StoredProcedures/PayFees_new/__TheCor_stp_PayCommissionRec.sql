if exists (select * from sysobjects where name = '__TheCor_stp_PayCommissionRec')
	drop procedure __TheCor_stp_PayCommissionRec
go

create procedure [dbo].[__TheCor_stp_PayCommissionRec]
(
	@registerpaymentid int,
	@commscenid int,
	@companyid int,
	@entrytypeid int,
	@paymentamount money,
	@parentcommrecid int = null
)

as

set nocount on
set ansi_warnings off

BEGIN TRY
	declare @commfeeid int
	declare @commstructid int
	declare @commrecid int
	declare @value money
	declare @ispercent bit

	declare @amountremaining money

	declare @amount money
	declare @amountpaid money
	declare @nonpercentamount money
	declare @percent money

	declare @paidsumcertain money

	if @parentcommrecid is null
	begin
		-- Get the root CommRec, most of the time this should be the trust account
		select 
			@parentcommrecid = ParentCommRecID
		from 
			tblCommStruct
		where
			CommScenId = @commscenid
			and CompanyID = @companyid
			and ParentCommRecID not in (select distinct CommRecID from tblCommStruct where CommScenId = @commscenid and CompanyID = @companyid)
	end

	declare @vtblCommStruct table
	(
		CommFeeID int,
		CommStructID int,
		CommRecID int,
		[Value] money,
		IsPercent bit,
		CommFeeOrder int
	)

	INSERT INTO
		@vtblCommStruct
	SELECT
		cf.CommFeeID,
		cs.CommStructID,
		cs.CommRecID,
		cf.[Percent],
		cf.IsPercent,
		cf.[Order] as CommFeeOrder
	FROM
		tblCommStruct as cs
		left join tblCommFee as cf on cf.CommStructID = cs.CommStructID and cf.EntryTypeID = @entrytypeid
	WHERE
		cs.CompanyID = @companyid
		and cs.ParentCommRecID = @parentcommrecid
		and cs.CommScenID = @commscenid

	set @nonpercentamount = 0

	SELECT
		@nonpercentamount = isnull(sum(cf.[Percent]), 0)
	FROM
		tblCommStruct as cs
		inner join tblCommFee as cf on cf.CommStructID = cs.CommStructID
	WHERE
		cs.CompanyID = @companyid
		and cs.CommScenID = @commscenid
		and cf.EntryTypeID = @entrytypeid
		and cf.IsPercent = 0

	declare cursor_PayCommissionRec cursor local fast_forward read_only for
		SELECT
			CommFeeID,
			CommStructID,
			CommRecID,
			[Value],
			IsPercent
		FROM
			@vtblCommStruct
		ORDER BY
			CommFeeOrder,
			IsPercent

	open cursor_PayCommissionRec

	fetch next from cursor_PayCommissionRec into @commfeeid, @commstructid, @commrecid, @value, @ispercent

	while @@fetch_status = 0
	begin
		if @value is not null
		begin
			if @ispercent = 1
			begin
				set @amount = round((@paymentamount - @nonpercentamount) * @value, 2)
				set @percent = @value
			end
			else
			begin
				set @paidsumcertain = 0

				SELECT
					@paidsumcertain = isnull(sum(cp.Amount), 0)
				FROM
					tblCommPay as cp
					inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
					inner join tblRegisterPayment as rp2 on rp2.FeeRegisterID = rp.FeeRegisterID
				WHERE
					cp.CommFeeID = @commfeeid
					and rp2.RegisterPaymentID = @registerpaymentid

				set @amount = round(@value - @paidsumcertain, 2)
				set @percent = round(@amount / @paymentamount, 4)
			end

			SELECT
				@amountpaid = isnull(sum(Amount), 0)
			FROM
				tblCommPay
			WHERE
				RegisterPaymentID = @registerpaymentid

			set @amountremaining = @paymentamount - @amountpaid

			if @amountremaining < @amount
			begin
				if @amountremaining > 0
				begin
					print 'Error: Paying ' + cast(@amountremaining as nvarchar(10)) + ' Instead Of ' + cast(@amount as nvarchar(10))
				end

				set @amount = @amountremaining
			end

			if @amount > 0
			begin
				INSERT INTO
					tblCommPay
					(
						RegisterPaymentID,
						CommStructID,
						[Percent],
						Amount,
						CommFeeID
					)
				VALUES
					(
						@registerpaymentid,
						@commstructid,
						@percent,
						@amount,
						@commfeeid
					)

				print 'Commission: $' + cast(round(@amount, 2) as nvarchar(10)) + ' To ' + cast(@commrecid as nvarchar(10))
			end
		end

		exec __TheCor_stp_PayCommissionRec @registerpaymentid, @commscenid, @companyid, @entrytypeid, @paymentamount, @commrecid

		fetch next from cursor_PayCommissionRec into @commfeeid, @commstructid, @commrecid, @value, @ispercent
	end

	close cursor_PayCommissionRec
	deallocate cursor_PayCommissionRec
END TRY
BEGIN CATCH
	close cursor_PayCommissionRec
	deallocate cursor_PayCommissionRec

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH