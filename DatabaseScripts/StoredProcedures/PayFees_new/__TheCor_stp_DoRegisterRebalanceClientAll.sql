/****** Object:  StoredProcedure [dbo].[__TheCor_stp_DoRegisterRebalanceClientAll]    Script Date: 12/19/2007 14:18:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[__TheCor_stp_DoRegisterRebalanceClientAll]
	(
		@index bit = 0
	)

as

set nocount on
set ansi_warnings off

declare @clientid int
declare @oldclientid int

declare @date datetime
declare @type varchar(10)
declare @id int
declare @amount money
declare @bounceorvoid bit
declare @fee bit
declare @adjustment bit

declare @lastbalance money set @lastbalance = 0
declare @sdabalance money set @sdabalance = 0
declare @pfobalance money set @pfobalance = 0

BEGIN TRY
	if @index = 1
	begin
		CREATE INDEX idx_DoRegisterRebalanceClientAll ON tblClient (ClientID, SDABalance, PFOBalance)
		CREATE INDEX idx_DoRegisterRebalanceClientAll ON tblEntryType (EntryTypeID, Fee)
		CREATE INDEX idx_DoRegisterRebalanceClientAll ON tblRegister (RegisterID, ClientID, Amount, OriginalAmount, Bounce, Void, AdjustedRegisterID, TransactionDate, Balance, SDABalance, PFOBalance)
		CREATE INDEX idx_DoRegisterRebalanceClientAll ON tblRegisterPayment (RegisterPaymentID, FeeRegisterID, Amount, Bounced, Voided, PaymentDate, SDABalance, PFOBalance)
	end

	declare @vtblTransactions table
	(
		ClientID int not null,
		Date datetime not null,
		[Type] varchar(10) not null,
		ID int not null,
		Amount money not null,
		BounceOrVoid bit not null,
		Fee bit null,
		Adjustment bit null
	)

	INSERT INTO
		@vtblTransactions
	SELECT
		c.ClientID,
		drvTransactions.Date,
		drvTransactions.[Type],
		drvTransactions.ID,
		drvTransactions.Amount,
		drvTransactions.BounceOrVoid,
		drvTransactions.Fee,
		drvTransactions.Adjustment
	FROM
		(
			SELECT
				r.ClientID,
				r.TransactionDate as Date,
				'register' as [Type],
				r.RegisterID as ID,
				(
					CASE
						WHEN
							r.OriginalAmount is null
						THEN
							r.Amount
						ELSE
							r.OriginalAmount
					END
				) as Amount,
				(
					CASE
						WHEN
							r.Bounce is null
							and r.Void is null
						THEN
							0
						ELSE
							1
					END
				) as BounceOrVoid,
				et.Fee,
				(
					CASE
						WHEN
							r.AdjustedRegisterID is null
						THEN
							0
						ELSE
							1
					END
				) as Adjustment
			FROM
				tblRegister as r
				inner join tblEntryType as et on et.EntryTypeID = r.EntryTypeID

			UNION ALL

			SELECT
				r.ClientID,
				rp.PaymentDate as Date,
				'payment' as [Type],
				rp.RegisterPaymentID as ID,
				rp.Amount,
				(
					CASE
						WHEN
							rp.Bounced = 0
							and rp.Voided = 0
						THEN
							0
						ELSE
							1
					END
				) as BounceOrVoid,
				null as Fee,
				null as Adjustment
			FROM
				tblRegisterPayment as rp
				inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		) as drvTransactions
		inner join tblClient as c on c.ClientID = drvTransactions.ClientID
	WHERE
		c.CurrentClientStatusID not in (15, 17, 18)

	declare cursor_DoRegisterRebalanceClientAll cursor forward_only read_only for
		SELECT
			ClientID,
			Date,
			[Type],
			ID,
			Amount,
			BounceOrVoid,
			Fee,
			Adjustment
		FROM
			@vtblTransactions
		ORDER BY
			ClientID,
			Date,
			[Type] desc,
			ID

	open cursor_DoRegisterRebalanceClientAll

	fetch next from cursor_DoRegisterRebalanceClientAll into @clientid, @date, @type, @id, @amount, @bounceorvoid, @fee, @adjustment

	set @oldclientid = @clientid

	while @@fetch_status = 0
	begin
		if not @clientid = @oldclientid
		begin
			update
				tblClient
			set
				SDABalance = @sdabalance,
				PFOBalance = @pfobalance
			where
				ClientID = @oldclientid

			print 'Client: ' + cast(@clientid as nvarchar(10))

			set @oldclientid = @clientid

			set @lastbalance = 0
			set @sdabalance = 0
			set @pfobalance = 0
		end

		if @type = 'register'
		begin
			if @bounceorvoid = 0
			begin
				set @lastbalance = @lastbalance + @amount

				if @fee = 1 or @adjustment = 1
				begin
					set @pfobalance = @pfobalance - @amount
				end
				else
				begin
					set @sdabalance = @sdabalance + @amount
				end

				update
					tblRegister
				set
					Balance = @lastbalance,
					SDABalance = @sdabalance,
					PFOBalance = @pfobalance
				where
					RegisterID = @id
			end
		end
		else
		begin
			if @bounceorvoid = 0
			begin
				set @sdabalance = @sdabalance - @amount
				set @pfobalance = @pfobalance - @amount
			end

			update
				tblRegisterPayment
			set
				SDABalance = @sdabalance,
				PFOBalance = @pfobalance
			where
				RegisterPaymentID = @id
		end

		fetch next from cursor_DoRegisterRebalanceClientAll into @clientid, @date, @type, @id, @amount, @bounceorvoid, @fee, @adjustment
	end

	close cursor_DoRegisterRebalanceClientAll
	deallocate cursor_DoRegisterRebalanceClientAll

	if @index = 1
	begin
		DROP INDEX tblClient.idx_DoRegisterRebalanceClientAll
		DROP INDEX tblEntryType.idx_DoRegisterRebalanceClientAll
		DROP INDEX tblRegister.idx_DoRegisterRebalanceClientAll
		DROP INDEX tblRegisterPayment.idx_DoRegisterRebalanceClientAll
	end
END TRY
BEGIN CATCH
	print 'Client: ' + cast(@clientid as nvarchar(10)) + ' - Type: ' + @type + ' - ID: ' + cast(@id as nvarchar(10))

	close cursor_DoRegisterRebalanceClientAll
	deallocate cursor_DoRegisterRebalanceClientAll

	if @index = 1
	begin
		DROP INDEX tblClient.idx_DoRegisterRebalanceClientAll
		DROP INDEX tblEntryType.idx_DoRegisterRebalanceClientAll
		DROP INDEX tblRegister.idx_DoRegisterRebalanceClientAll
		DROP INDEX tblRegisterPayment.idx_DoRegisterRebalanceClientAll
	end

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH