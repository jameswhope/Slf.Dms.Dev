if exists (select * from sysobjects where name = '__TheCor_stp_PayFeeForClient')
	drop procedure __TheCor_stp_PayFeeForClient
go

create procedure [dbo].[__TheCor_stp_PayFeeForClient]
(
	@clientid int
)

as

set nocount on
set ansi_warnings off

BEGIN TRY
	declare @total int
	declare @count int

	declare @nomoneyclientid int

	declare @companyid int
	declare @enrolled datetime
	declare @registerid int
	declare @feeremaining money
	declare @agencyid int

	declare @deposittotal money
	declare @depositused money
	declare @nonfeedebits money
	declare @depositavailable money

	declare @vtblPayFees table
	(
		ClientID int,
		CompanyID int,
		Enrolled datetime,
		RegisterID int,
		FeeRemaining money,
		AgencyID int
	)

	INSERT INTO
		@vtblPayFees
	SELECT
		c.ClientID,
		c.CompanyID,
		c.Created,
		r.RegisterID,
		isnull(abs(r.Amount), 0) - isnull(sum(rp.Amount), 0) as FeeRemaining,
		c.AgencyID
	FROM
		tblClient as c
		inner join tblRegister as r on r.ClientID = c.ClientID
		inner join tblEntryType as et on r.EntryTypeID = et.EntryTypeID
		left join tblRegisterPayment as rp on rp.FeeRegisterID = r.RegisterID and rp.Voided = 0 and rp.Bounced = 0
	WHERE
		r.Amount < 0
		and et.Fee = 1
		and r.IsFullyPaid = 0
		and r.Void is null
		and r.Bounce is null
		and c.ClientID = @clientid
	GROUP BY
		r.RegisterID,
		c.CompanyID,
		c.Created,
		r.Amount,
		c.AgencyID,
		et.[Order],
		r.TransactionDate,
		c.ClientID
	ORDER BY
		c.ClientID desc,
		et.[Order],
		r.TransactionDate

	set @nomoneyclientid = 0

	SELECT
		@total = count(*)
	FROM
		@vtblPayFees
	WHERE
		FeeRemaining > 0

	set @count = 1

	print 'Total Entries: ' + cast(@total as nvarchar(10))
	print ''
	print ''

	declare cursor_PayFeeForClient cursor fast_forward read_only for
		SELECT
			ClientID,
			CompanyID,
			Enrolled,
			RegisterID,
			FeeRemaining,
			AgencyID
		FROM
			@vtblPayFees
		WHERE
			FeeRemaining > 0

	open cursor_PayFeeForClient

	fetch next from cursor_PayFeeForClient into @clientid, @companyid, @enrolled, @registerid, @feeremaining, @agencyid

	while @@fetch_status = 0
	begin
		if not @nomoneyclientid = @clientid
		begin
			print 'Client: ' + cast(@clientid as nvarchar(15)) + '  Fee: ' + cast(@registerid as nvarchar(15))
			exec @nomoneyclientid = __TheCor_stp_PayFee @registerid, @clientid, @companyid, @feeremaining, @enrolled, @agencyid
		end

--		print 'Count: ' + cast(@count as nvarchar(10))
--		print ''

		set @count = @count + 1

		fetch next from cursor_PayFeeForClient into @clientid, @companyid, @enrolled, @registerid, @feeremaining, @agencyid
	end

	close cursor_PayFeeForClient
	deallocate cursor_PayFeeForClient
END TRY
BEGIN CATCH
	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)

	close cursor_PayFeeForClient
	deallocate cursor_PayFeeForClient
END CATCH