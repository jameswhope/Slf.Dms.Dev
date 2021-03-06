/****** Object:  StoredProcedure [dbo].[__TheCor_stp_CollectACHDeposits]    Script Date: 12/19/2007 14:17:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[__TheCor_stp_CollectACHDeposits]
	(
		@fordate datetime = null
	)

as

set nocount on
set ansi_warnings off

declare @lastdayofmonth bit

declare @clientid int
declare @companyid int
declare @display varchar(100)
declare @routingnumber varchar(9)
declare @accountnumber varchar(50)
declare @type varchar
declare @amount money
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

	if @fordate = dateadd(dd, -(day(dateadd(mm, 1, @fordate))), dateadd(mm, 1, @fordate))
	begin
		set @lastdayofmonth = 1
	end
	else
	begin
		set @lastdayofmonth = 0
	end

	declare @vtblDeposits table
	(
		ClientID int,
		CompanyID int,
		Display varchar(100),
		RoutingNumber varchar(9),
		AccountNumber varchar(50),
		[Type] varchar,
		Amount money,
		TrustCommRecID int,
		TrustDisplay varchar(100),
		TrustRoutingNumber varchar(9),
		TrustAccountNumber varchar(50),
		TrustType varchar,
		TrustIsPersonal bit
	)

	INSERT INTO
		@vtblDeposits
	SELECT
		drvDeposits.ClientID,
		drvDeposits.CompanyID,
		drvDeposits.Display,
		drvDeposits.BankRoutingNumber as RoutingNumber,
		drvDeposits.BankAccountNumber as AccountNumber,
		isnull(drvDeposits.BankType, 'C') as [Type],
		abs(drvDeposits.DepositAmount) as Amount,
		trust.CommRecID as TrustCommRecID,
		trust.Display as TrustDisplay,
		trust.RoutingNumber as TrustRoutingNumber,
		trust.AccountNumber as TrustAccountNumber,
		isnull(trust.[Type], 'C') as TrustType,
		~trust.IsCommercial as TrustIsPersonal
	FROM
		(
			SELECT
				c.ClientID,
				c.CompanyID,
				p.FirstName + ' ' + p.LastName as Display,
				c.BankRoutingNumber,
				c.BankAccountNumber,
				c.BankType,
				c.DepositAmount,
				cr.CommRecID
			FROM
				tblClient as c
				inner join tblPerson as p on p.PersonID = c.PrimaryPersonID
				inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
			WHERE
				c.ClientID not in
				(
					SELECT
						ClientID
					FROM
						tblRuleACH
					WHERE
						StartDate <= cast(convert(varchar(10), @fordate, 101) as datetime) and
						(
							EndDate is null
							or EndDate >= cast(convert(varchar(10), @fordate, 101) as datetime)
						)
				) and
				(
					c.DepositDay = day(@fordate) or
					(
						@lastdayofmonth = 1
						and c.DepositDay >= day(@fordate)
					)
				)
				and c.DepositStartDate <= cast(convert(varchar(10), @fordate, 101) as datetime)
				and c.CurrentClientStatusID not in (15, 17, 18)
				and lower(c.DepositMethod) = 'ach'
				and c.DepositDay is not null
				and c.DepositDay > 0
				and c.BankRoutingNumber is not null
				and c.BankAccountNumber is not null
				and len(c.BankRoutingNumber) > 0
				and len(c.BankAccountNumber) > 0
				and c.DepositStartDate is not null

			UNION ALL

			SELECT
				c.ClientID,
				c.CompanyID,
				p.FirstName + ' ' + p.LastName as Display,
				r.BankRoutingNumber,
				r.BankAccountNumber,
				r.BankType,
				r.DepositAmount,
				cr.CommRecID
			FROM
				tblRuleACH as r
				inner join tblClient as c on c.ClientID = r.ClientID
				inner join tblPerson as p on PersonID = c.PrimaryPersonID
				inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
			WHERE
				r.RuleACHID in
				(
					SELECT
						min(RuleACHID)
					FROM
						tblRuleACH
					WHERE
						StartDate <= cast(convert(varchar(10), @fordate, 101) as datetime) and
						(
							EndDate is null
							or EndDate >= cast(convert(varchar(10), @fordate, 101) as datetime)
						) and
						(
							r.DepositDay = day(@fordate) or
							(
								@lastdayofmonth = 1
								and r.DepositDay >= day(@fordate)
							)
						)
					GROUP BY
						ClientID
				)
				and c.DepositStartDate <= cast(convert(varchar(10), @fordate, 101) as datetime)
				and c.CurrentClientStatusID not in (15, 17, 18)
				and lower(c.DepositMethod) = 'ach'
				and c.DepositDay is not null
				and c.DepositDay > 0
				and c.BankRoutingNumber is not null
				and c.BankAccountNumber is not null
				and len(c.BankRoutingNumber) > 0
				and len(c.BankAccountNumber) > 0
				and c.DepositStartDate is not null
		) as drvDeposits
		inner join tblCommRec as trust on trust.CommRecID = drvDeposits.CommRecID

	declare cursor_CollectACHDeposits cursor forward_only read_only for
		SELECT
			ClientID,
			CompanyID,
			Display,
			RoutingNumber,
			AccountNumber,
			[Type],
			Amount,
			TrustCommRecID,
			TrustDisplay,
			TrustRoutingNumber,
			TrustAccountNumber,
			TrustType,
			TrustIsPersonal
		FROM
			@vtblDeposits
		WHERE
			Amount > 0

	open cursor_CollectACHDeposits

	fetch next from cursor_CollectACHDeposits into @clientid, @companyid, @display, @routingnumber, @accountnumber, @type, @amount, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal

	while @@fetch_status = 0
	begin
		set @registerid = null

		SELECT
			@registerid = RegisterID
		FROM
			tblRegister
		WHERE
			ClientID = @clientid
			and ACHMonth = month(@fordate)
			and ACHYear = year(@fordate)

		if @registerid is null
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
					ACHMonth,
					ACHYear
				)
			VALUES
				(
					@clientid,
					cast(convert(varchar(50), @fordate, 101) as datetime),
					@amount,
					3,
					cast(convert(varchar(50), @fordate, 101) as datetime),
					24,
					month(@fordate),
					year(@fordate)
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
		end

		fetch next from cursor_CollectACHDeposits into @clientid, @companyid, @display, @routingnumber, @accountnumber, @type, @amount, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal
	end

	close cursor_CollectACHDeposits
	deallocate cursor_CollectACHDeposits

	if (SELECT count(*) FROM tblBankHoliday WHERE cast(convert(varchar(50), [Date], 101) as datetime) = cast(convert(varchar(50), @fordate, 101) as datetime)) > 0 or lower(datename(dw, @fordate)) = 'saturday' or lower(datename(dw, @fordate)) = 'sunday'
	begin
		declare @nextfordate datetime

		print cast(@fordate as nvarchar(25)) + ' is a NO BANK day, gathering next'

		set @nextfordate = dateadd(d, 1, @fordate)

		exec __TheCor_stp_CollectACHDeposits @nextfordate
	end
	else
	begin
		print cast(@fordate as nvarchar(25)) + ' is a regular bank day'
	end
END TRY
BEGIN CATCH
	close cursor_CollectACHDeposits
	deallocate cursor_CollectACHDeposits

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH