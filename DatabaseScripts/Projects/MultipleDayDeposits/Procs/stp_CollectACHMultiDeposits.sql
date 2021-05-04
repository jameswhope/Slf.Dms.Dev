IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CollectACHMultiDeposits')
	BEGIN
		DROP  Procedure  stp_CollectACHMultiDeposits
	END

GO

CREATE procedure [dbo].[stp_CollectACHMultiDeposits]
(
	@fordate datetime = null
)

as

set nocount on
set ansi_warnings off

declare @lastdayofmonth bit

declare @clientid int
declare @companyid int
declare @trustid int
declare @acctnum varchar(50)
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
declare @clientdepositid int
declare @registerid int
declare @nacharegisterid int
declare @hold datetime

declare @vtblDeposits table
(
	ClientID int,
	CompanyID int,
	TrustID int,
	AcctNum varchar(50),
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
	TrustIsPersonal bit,
	ClientDepositID int
)
	

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


	INSERT INTO
		@vtblDeposits
	SELECT
		drvDeposits.ClientID,
		drvDeposits.CompanyID,
		drvDeposits.TrustID,
		drvDeposits.AcctNum,
		drvDeposits.Display,
		drvDeposits.RoutingNumber,
		drvDeposits.AccountNumber,
		isnull(drvDeposits.BankType, 'C') as [Type],
		abs(drvDeposits.DepositAmount) as Amount,
		trust.CommRecID as TrustCommRecID,
		trust.Display as TrustDisplay,
		trust.RoutingNumber as TrustRoutingNumber,
		trust.AccountNumber as TrustAccountNumber,
		isnull(trust.[Type], 'C') as TrustType,
		~trust.IsCommercial as TrustIsPersonal,
		drvDeposits.ClientDepositID
	FROM
		(
			SELECT
				c.ClientID,
				c.CompanyID,
				c.TrustID,
				c.AccountNumber as AcctNum,
				p.FirstName + ' ' + p.LastName as Display,
				b.RoutingNumber,
				b.AccountNumber,
				b.BankType,
				d.DepositAmount,
				cr.CommRecID,
				d.ClientDepositID
			FROM
				tblClient as c
				inner join tblClientDepositDay d on d.ClientID = c.ClientID
				inner join tblClientBankAccount b on b.BankAccountID = d.BankAccountID
				inner join tblPerson as p on p.PersonID = c.PrimaryPersonID
				inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
			WHERE
				d.ClientDepositID not in -- exclude deposits with active rules
				(
					SELECT
						ClientDepositID
					FROM
						tblDepositRuleACH
					WHERE
						StartDate <= cast(convert(varchar(10), @fordate, 101) as datetime) and
						(
							EndDate is null
							or EndDate >= cast(convert(varchar(10), @fordate, 101) as datetime)
						)
				) and
				(
					d.DepositDay = day(@fordate) or
					(
						@lastdayofmonth = 1
						and d.DepositDay >= day(@fordate)
					)
				)
				and c.DepositStartDate <= cast(convert(varchar(10), @fordate, 101) as datetime)
				and c.DepositStartDate is not null
				and c.CurrentClientStatusID not in (15, 17, 18)
				and c.MultiDeposit = 1
				and b.RoutingNumber is not null
				and b.AccountNumber is not null
				and len(b.RoutingNumber) > 0
				and len(b.AccountNumber) > 0
				and lower(d.Frequency) = 'month'
				and d.DeletedDate is null
				and lower(d.DepositMethod) = 'ach'
				and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v) 
			UNION ALL

			SELECT
				c.ClientID,
				c.CompanyID,
				c.TrustID,
				c.AccountNumber as AcctNum,
				p.FirstName + ' ' + p.LastName as Display,
				b.RoutingNumber,
				b.AccountNumber,
				b.BankType,
				r.DepositAmount,
				cr.CommRecID,
				r.ClientDepositID
			FROM
				tblDepositRuleACH as r
				inner join tblClientDepositDay d on d.ClientDepositID = r.ClientDepositID
				inner join tblClientBankAccount b on b.BankAccountID = r.BankAccountID
				inner join tblClient as c on c.ClientID = d.ClientID
				inner join tblPerson as p on PersonID = c.PrimaryPersonID
				inner join tblCommRec as cr on cr.CompanyID = c.CompanyID and cr.IsTrust = 1
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
				and c.DepositStartDate <= cast(convert(varchar(10), @fordate, 101) as datetime)
				and c.DepositStartDate is not null
				and c.CurrentClientStatusID not in (15, 17, 18)
				and c.MultiDeposit = 1
				and b.RoutingNumber is not null
				and b.AccountNumber is not null
				and len(b.RoutingNumber) > 0
				and len(b.AccountNumber) > 0
				and lower(d.Frequency) = 'month'
				and d.DeletedDate is null
				and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v) 
				
		) as drvDeposits
		inner join tblCommRec as trust on trust.CommRecID = drvDeposits.CommRecID


	declare cursor_CollectACHDeposits cursor forward_only read_only for
		SELECT
			ClientID,
			CompanyID,
			TrustID,
			AcctNum,
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
			TrustIsPersonal,
			ClientDepositID
		FROM
			@vtblDeposits
		WHERE
			Amount > 0

	open cursor_CollectACHDeposits

	fetch next from cursor_CollectACHDeposits into @clientid, @companyid, @trustid, @acctnum, @display, @routingnumber, @accountnumber, @type, @amount, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal, @clientdepositid

	while @@fetch_status = 0
	begin
		set @registerid = null
		
		-- Each multi-deposit can only be drafted once a month
		SELECT
			@registerid = RegisterID
		FROM
			tblRegister
		WHERE
			ClientID = @clientid
			and ACHMonth = month(@fordate)
			and ACHYear = year(@fordate)
			and ClientDepositID = @clientdepositid

		if @registerid is null
		begin

			if @trustid = 22 begin -- CheckSite
				set @hold = convert(datetime, convert(varchar (50), '1/1/2050', 101)) -- Hold until the deposit clears at CheckSite
			end else begin
				set @hold = convert(datetime, convert(varchar (50), @fordate, 101))
			end

			-- insert an sda deposit transaction (where the trandate and holddate are the process day)
			insert into
				tblregister
				(
					clientid,
					transactiondate,
					amount,
					entrytypeid,
					hold,
					holdby,
					achmonth,
					achyear,
					clientdepositid
				)
			values
				(
					@clientid,
					cast(convert(varchar(50), @fordate, 101) as datetime),
					@amount,
					3,
					@hold,
					24, -- import engine
					month(@fordate),
					year(@fordate),
					@clientdepositid
				)

			set @registerid = scope_identity()


			if @trustid = 22 begin -- CheckSite
				-- write out debit against personal account
				insert into
					tblnacharegister2
					(
						[name],
						accountnumber,
						routingnumber,
						[type],
						amount,
						ispersonal,
						companyid,
						ShadowStoreId,
						RegisterId,
						ClientID,
						Flow
					)
				values
					(
						@display,
						@accountnumber,
						@routingnumber,
						@type,
						@amount,
						1, -- ispersonal
						@companyid,
						@acctnum,
						@registerid,
						@clientid,
						'credit' -- credit the shadow store
					)
			end
			else begin
				-- write out debit against personal account
				insert into
					tblnacharegister
					(
						[name],
						accountnumber,
						routingnumber,
						[type],
						amount,
						ispersonal,
						commrecid,
						companyid,
						clientid,
						registerid
					)
				values
					(
						@display + ' (' + cast(@clientID as varchar(15)) + ')',
						@accountnumber,
						@routingnumber,
						@type,
						-@amount,
						1, -- ispersonal
						@trustcommrecid,
						@companyid,
						@clientid,
						@registerid
					)

				set @nacharegisterid = scope_identity()


				-- insert nacha cabinet records against this registerid
				insert into tblnachacabinet
				(
					nacharegisterid,
					[type],
					typeid,
					TrustID
				)
				values
				(
					@nacharegisterid,
					'RegisterID',
					@registerid,
					@trustid
				)


				-- write out credit for trust account
				insert into tblnacharegister
				(
					[name],
					accountnumber,
					routingnumber,
					[type],
					amount,
					ispersonal,
					commrecid,
					companyid
				)
				values
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

				-- insert nacha cabinet records against this registerid
				insert into tblnachacabinet
				(
					nacharegisterid,
					[type],
					typeid,
					TrustID
				)
				values
				(
					@nacharegisterid,
					'RegisterID',
					@registerid,
					@trustid
				)

			end

			-- rebalance register for client
			-- don't do entire cleanup for client - that will do payments and auto-assign negogiation
			exec stp_DoRegisterRebalanceClient @clientid
		end
		
		fetch next from cursor_CollectACHDeposits into @clientid, @companyid, @trustid, @acctnum, @display, @routingnumber, @accountnumber, @type, @amount, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal, @clientdepositid
	end
	
	close cursor_CollectACHDeposits
	deallocate cursor_CollectACHDeposits


	if (SELECT count(*) FROM tblBankHoliday WHERE cast(convert(varchar(50), [Date], 101) as datetime) = cast(convert(varchar(50), @fordate, 101) as datetime)) > 0 or lower(datename(dw, @fordate)) = 'saturday' or lower(datename(dw, @fordate)) = 'sunday'
		begin
			declare @nextfordate datetime

			print cast(@fordate as nvarchar(25)) + ' is a NO BANK day, gathering next'

			set @nextfordate = dateadd(d, 1, @fordate)

			exec stp_CollectACHMultiDeposits @nextfordate
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
  