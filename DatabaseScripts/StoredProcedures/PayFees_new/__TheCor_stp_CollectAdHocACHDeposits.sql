/****** Object:  StoredProcedure [dbo].[__TheCor_stp_CollectAdHocACHDeposits]    Script Date: 12/19/2007 14:17:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[__TheCor_stp_CollectAdHocACHDeposits]
	(
		@fordate datetime = null
	)

as

set nocount on
set ansi_warnings off

declare @adhocachid int
declare @clientid int
declare @companyid int
declare @display varchar(100)
declare @routingnumber varchar(9)
declare @accountnumber varchar(50)
declare @type varchar
declare @amount money
declare @initialdraftyn bit
declare @trustcommrecid int
declare @trustdisplay varchar(100)
declare @trustroutingnumber varchar(9)
declare @trustaccountnumber varchar(50)
declare @trusttype varchar
declare @trustispersonal bit

declare @registerid int
declare @nacharegisterid int

BEGIN TRY
	if @fordate is null
	begin
		set @fordate = dateadd(d, 1, getdate())
	end

	declare @vtblAdHocDeposits table
	(
		AdHocACHID int,
		ClientID int,
		CompanyID int,
		Display varchar(100),
		RoutingNumber varchar(9),
		AccountNumber varchar(50),
		[Type] varchar,
		Amount money,
		InitialDraftYN bit,
		TrustCommRecID int,
		TrustDisplay varchar(100),
		TrustRoutingNumber varchar(9),
		TrustAccountNumber varchar(50),
		TrustType varchar,
		TrustIsPersonal bit
	)

	INSERT INTO
		@vtblAdHocDeposits
	SELECT
		a.AdHocACHID,
		a.ClientID,
		c.CompanyID,
		p.FirstName + ' ' + p.LastName as [Display],
		a.BankRoutingNumber as RoutingNumber,
		a.BankAccountNumber as AccountNumber,
		isnull(a.BankType, 'C') as [Type],
		abs(a.DepositAmount) as Amount,
		a.InitialDraftYN,
		cr.CommRecID as TrustCommRecID,
		cr.Display as TrustDisplay,
		cr.RoutingNumber as TrustRoutingNumber,
		cr.AccountNumber as TrustAccountNumber,
		isnull(cr.[Type], 'C') as TrustType,
		~cr.IsCommercial as TrustIsPersonal
	FROM
		tblAdHocACH as a
		inner join tblClient as c on c.ClientID = a.ClientID
		inner join tblPerson as p on p.PersonID = c.PrimaryPersonID
		inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
	WHERE
		c.CurrentClientStatusID not in (15, 17, 18)
		and cast(convert(varchar(10), a.DepositDate, 101) as datetime) = cast(convert(varchar(10), @fordate, 101) as datetime)
		and a.RegisterID is null

	declare cursor_CollectAdHocACHDeposits cursor forward_only read_only for
		SELECT
			AdHocACHID,
			ClientID,
			CompanyID,
			Display,
			RoutingNumber,
			AccountNumber,
			[Type],
			Amount,
			InitialDraftYN,
			TrustCommRecID,
			TrustDisplay,
			TrustRoutingNumber,
			TrustAccountNumber,
			TrustType,
			TrustIsPersonal
		FROM
			@vtblAdHocDeposits

	open cursor_CollectAdHocACHDeposits

	fetch next from cursor_CollectAdHocACHDeposits into @adhocachid, @clientid, @companyid, @display, @routingnumber, @accountnumber, @type, @amount, @initialdraftyn, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal

	while @@fetch_status = 0
	begin
		INSERT INTO
			tblRegister
			(
				ClientID,
				TransactionDate,
				Amount,
				EntryTypeID,
				Hold,
				HoldBy,
				InitialDraftYN
			)
		VALUES
			(
				@clientid,
				cast(convert(varchar(50), @fordate, 101) as datetime),
				@amount,
				3,
				cast(convert(varchar(50), @fordate, 101) as datetime),
				24,
				@initialdraftyn
			)

		set @registerid = scope_identity()

		INSERT INTO
			tblNachaRegister
			(
				[Name],
				AccountNumber,
				RoutingNumber,
				[Type],
				Amount,
				IsPersonal,
				CommRecID,
				CompanyID
			)
		VALUES
			(
				@display + ' (' + cast(@clientID as varchar(15)) + ')',
				@accountnumber,
				@routingnumber,
				@type,
				-@amount,
				1,
				@trustcommrecid,
				@companyid
			)

		set @nacharegisterid = scope_identity()

		INSERT INTO
			tblNachaCabinet
			(
				NachaRegisterID,
				[Type],
				TypeID
			)
		VALUES
			(
				@nacharegisterid,
				'RegisterID',
				@registerid
			)

		INSERT INTO
			tblNachaRegister
			(
				[Name],
				AccountNumber,
				RoutingNumber,
				[Type],
				Amount,
				IsPersonal,
				CommRecID,
				CompanyID
			)
		VALUES
			(
				@trustdisplay,
				@trustaccountnumber,
				@trustroutingnumber,
				@trusttype,
				@amount,
				@trustispersonal,
				@trustcommrecid,
				@companyid
			)

		set @nacharegisterid = scope_identity()

		INSERT INTO
			tblNachaCabinet
			(
				NachaRegisterID,
				[Type],
				TypeID
			)
		VALUES
			(
				@nacharegisterid,
				'RegisterID',
				@registerid
			)

		UPDATE
			tblAdHocACH
		SET
			RegisterID = @registerid
		WHERE
			AdHocACHID = @adhocachid

		fetch next from cursor_CollectAdHocACHDeposits into @adhocachid, @clientid, @companyid, @display, @routingnumber, @accountnumber, @type, @amount, @initialdraftyn, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal
	end

	close cursor_CollectAdHocACHDeposits
	deallocate cursor_CollectAdHocACHDeposits

	if (SELECT count(*) FROM tblBankHoliday WHERE cast(convert(varchar(50), [Date], 101) as datetime) = cast(convert(varchar(50), @fordate, 101) as datetime)) > 0 or lower(datename(dw, @fordate)) = 'saturday' or lower(datename(dw, @fordate)) = 'sunday'
	begin
		declare @nextfordate datetime

		print cast(@fordate as nvarchar(25)) + ' is a NO BANK day, gathering next'

		set @nextfordate = dateadd(d, 1, @fordate)

		exec __TheCor_stp_CollectAdHocACHDeposits @nextfordate
	end
	else
	begin
		print cast(@fordate as nvarchar(25)) + ' is a regular bank day'
	end
END TRY
BEGIN CATCH
	close cursor_CollectAdHocACHDeposits
	deallocate cursor_CollectAdHocACHDeposits

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH