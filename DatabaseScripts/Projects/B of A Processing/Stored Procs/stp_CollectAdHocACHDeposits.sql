IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CollectAdHocACHDeposits')
	BEGIN
		DROP  Procedure  stp_CollectAdHocACHDeposits
	END

GO

CREATE Procedure stp_CollectAdHocACHDeposits
(
	@fordate datetime = null
)
as

/*

Modified By:		Jim Hope
Modified Date:	Nov - 2010
Comments:		Added logic to Exclude Woolery clients

*/

set nocount on
set ansi_warnings off

declare @adhocachid int
declare @clientid int
declare @companyid int
declare @trustid int
declare @acctnum varchar(50)
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
declare @hold datetime

declare @vtblAdHocDeposits table
(
	AdHocACHID int,
	ClientID int,
	CompanyID int,
	TrustID int,
	AcctNum varchar(50),
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


BEGIN TRY
	if @fordate is null
		begin
			set @fordate = dateadd(d, 1, getdate())
		end



	INSERT INTO
		@vtblAdHocDeposits
	SELECT
		a.AdHocACHID,
		a.ClientID,
		c.CompanyID,
		c.TrustID,
		c.AccountNumber as [AcctNum],
		ltrim(rtrim(p.FirstName)) + ' ' + ltrim(rtrim(p.LastName)) as [Display],
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
		c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
		and cast(convert(varchar(10), a.DepositDate, 101) as datetime) = cast(convert(varchar(10), @fordate, 101) as datetime)
		and a.RegisterID is null
		and a.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
		and isnull(c.RemittName,'') <> 'Woolery Accountancy'	-- GARY

	declare cursor_CollectAdHocACHDeposits cursor forward_only read_only for
		SELECT
			AdHocACHID,
			ClientID,
			CompanyID,
			TrustID,
			AcctNum,
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

	fetch next from cursor_CollectAdHocACHDeposits into @adhocachid, @clientid, @companyid, @trustid, @acctnum, @display, @routingnumber, @accountnumber, @type, @amount, @initialdraftyn, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal

	while @@fetch_status = 0 
	begin

		if @trustid = 22 begin -- CheckSite
			set @hold = convert(datetime, convert(varchar (50), '1/1/2050', 101)) -- Hold until the deposit clears at CheckSite
		end else begin
			set @hold = convert(datetime, convert(varchar (50), @fordate, 101))
		end

		-- insert an sda deposit transaction (where the trandate and holddate are the process day)
		insert into tblregister
		(
			clientid,
			transactiondate,
			amount,
			entrytypeid,
			hold,
			holdby,
			InitialDraftYN
		)
		values
		(
			@clientid,
			cast(convert(varchar(50), @fordate, 101) as datetime),
			@amount,
			3, -- deposit
			@hold,
			24, -- importengine
			@initialdraftyn
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
					Flow,
					TrustID
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
					'credit', -- credit the shadow store
					isnull(@TrustID, -1)
				)
		end
		else begin
			-- write out debit against personal account
			insert into tblnacharegister
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
				RegisterID
			)
			values
			(
				@display + ' (' + cast(@clientID as varchar(15)) + ')',
				@accountnumber,
				@routingnumber,
				@type,
				-@amount,
				1,
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


		-- update AdHoc ACH with new RegisterID
		update 
			tbladhocach 
		set
			registerid=@registerid
		where
			adhocachid=@adhocachid


		-- rebalance register for client
		-- don't do entire cleanup for client - that will do payments and auto-assign negogiation
		exec stp_DoRegisterRebalanceClient @clientid

		fetch next from cursor_CollectAdHocACHDeposits into @adhocachid, @clientid, @companyid, @trustid, @acctnum, @display, @routingnumber, @accountnumber, @type, @amount, @initialdraftyn, @trustcommrecid, @trustdisplay, @trustroutingnumber, @trustaccountnumber, @trusttype, @trustispersonal
	end

close cursor_CollectAdHocACHDeposits
deallocate cursor_CollectAdHocACHDeposits


if (SELECT count(*) FROM tblBankHoliday WHERE cast(convert(varchar(50), [Date], 101) as datetime) = cast(convert(varchar(50), @fordate, 101) as datetime)) > 0 or lower(datename(dw, @fordate)) = 'saturday' or lower(datename(dw, @fordate)) = 'sunday'
	begin
		declare @nextfordate datetime

		print cast(@fordate as nvarchar(25)) + ' is a NOT A BANKING day, gathering next'

		set @nextfordate = dateadd(d, 1, @fordate)

		exec stp_CollectAdHocACHDeposits @nextfordate
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

