/****** Object:  StoredProcedure [dbo].[stp_ClientImport]    Script Date: 04/13/2009 13:59:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_ClientImport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_ClientImport]
GO
/****** Object:  StoredProcedure [dbo].[stp_ClientImport]    Script Date: 04/13/2009 13:59:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_ClientImport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_ClientImport]
(
	@companyid int,
	@agencyid int,
	@dbname nvarchar(100)
)

AS
/*
	History:
	05/30/08	jhernandez		Return @numclients and @importid. Used to open Shadow
										store accounts.
	07/14/2008	jhope				Added routine to check BankType and assign TrustIDs
										accordingly.
	09/13/2008 jhope				Modified code to accept new header names and added
										additional check on SSN without dashes in string for dup checkin
	04/07/2009 jhope				Modify to handle multiple deposits
*/

declare @numclients int
declare @importid int
declare @importuserid int
declare @importdatetime datetime

set @importuserid = 24
set @importdatetime = getdate()
set @numclients = 0

declare @languageid int
declare @trustid int
declare @enrollmentid int
declare @clientid int
declare @personid int
declare @agencyname varchar (255)
declare @setupfeepercentage money
declare @settlementfeepercentage money
declare @monthlyfee money
declare @monthlyfeeday int
declare @additionalaccountfee money
declare @returnedcheckfee money
declare @overnightdeliveryfee money

BEGIN TRY
-- find and set the default language
select @languageid = languageid from tbllanguage where [default] = 1

-- find and set the default trust
select @trustid = trustid from tbltrust where [default] = 1

select @agencyname = [name] from tblagency where agencyid = @agencyid

set @setupfeepercentage = (select retainerfeepercent from tblagency where agencyid=@agencyid)
set @settlementfeepercentage = (select settlementfeepercent from tblagency where agencyid=@agencyid)
set @monthlyfee = (select maintenancefee from tblagency where agencyid=@agencyid)
set @monthlyfeeday = (select maintenancefeeday from tblagency where agencyid=@agencyid)
set @additionalaccountfee = (select additionalaccountfee from tblagency where agencyid=@agencyid)
set @returnedcheckfee = (select returnedcheckfee from tblagency where agencyid=@agencyid)
set @overnightdeliveryfee = (select overnightfee from tblagency where agencyid=@agencyid)

if @setupfeepercentage is null begin
	select @setupfeepercentage = convert(money, value) from tblproperty where [name] = ''EnrollmentRetainerPercentage''
end
if @settlementfeepercentage is null begin
	select @settlementfeepercentage = convert(money, value) from tblproperty where [name] = ''EnrollmentSettlementPercentage''
end
if @monthlyfee is null begin
	select @monthlyfee = convert(money, value) from tblproperty where [name] = ''EnrollmentMonthlyFee''
end
if @monthlyfeeday is null begin
	select @monthlyfeeday = convert(int, value) from tblproperty where [name] = ''EnrollmentMonthlyFeeDay''
end
if @additionalaccountfee is null begin
	select @additionalaccountfee = convert(money, value) from tblproperty where [name] = ''EnrollmentAddAccountFee''
end
if @returnedcheckfee is null begin
	select @returnedcheckfee = convert(money, value) from tblproperty where [name] = ''EnrollmentReturnedCheckFee''
end
if @overnightdeliveryfee is null begin
	select @overnightdeliveryfee = convert(money, value) from tblproperty where [name] = ''EnrollmentOvernightFee''
end

-- insert import record. *****Change the import file name to match the import file.
insert into tblimport
(
	imported,
	importedby,
	[database],
	[table],
	[description]
)
values
(
	@importdatetime,
	@importuserid,
	''DMS'',
	@dbname,
	''New clients batch from agency '' + @agencyname
)

-- return freshly-inserted import record
set @importid = scope_identity()


-- loop the notes table and setup links
declare @first_name nvarchar (255)
declare @last_name nvarchar (255)
declare @debt_total money
declare @social_security_no nvarchar (255)
declare @date_received smalldatetime

--MultiDeposit variables all new
DECLARE @1stBankAccountId int
DECLARE @2ndBankAccountId int
DECLARE @3rdBankAccountId int
DECLARE @4thBankAccountId int
DECLARE @1stClientDepositId int
DECLARE @DraftRoutingNo nvarchar(9)
DECLARE @DraftAccountNo nvarchar(50)
DECLARE @DraftBankName nvarchar(255)
DECLARE @DraftDepositMethod nvarchar(50)
DECLARE @DraftCheckingSavings nvarchar(1)
DECLARE @1stCheckingSavings nvarchar(1)
DECLARE @1stDepositMethod nvarchar(50)
DECLARE @1stDepositDate smalldatetime
DECLARE @1stDepositDay int
DECLARE @1stDepositAmount money
DECLARE @2ndDepositDay int
DECLARE @2ndDepositAmount money
DECLARE @2ndRoutingNo nvarchar(9)
DECLARE @2ndAccountNo nvarchar(50)
DECLARE @2ndBankName nvarchar(255)
DECLARE @2ndDepositMethod nvarchar(50)
DECLARE @2ndCheckingSavings nvarchar(1)
DECLARE @3rdDepositDay int
DECLARE @3rdDepositAmount money
DECLARE @3rdRoutingNo nvarchar(9)
DECLARE @3rdAccountNo nvarchar(50)
DECLARE @3rdBankName nvarchar(255)
DECLARE @3rdDepositMethod nvarchar(50)
DECLARE @3rdCheckingSavings nvarchar(1)
DECLARE @4thDepositDay int
DECLARE @4thDepositAmount money
DECLARE @4thRoutingNo nvarchar(9)
DECLARE @4thAccountNo nvarchar(50)
DECLARE @4thBankName nvarchar(255)
DECLARE @4thDepositMethod nvarchar(50)
DECLARE @4thCheckingSavings nvarchar(1)
DECLARE @DuplicateBankAccount int

-- other saved "extra" fields
declare @lead_number nvarchar(255)
declare @date_sent smalldatetime
declare @missing_info nvarchar (255)
declare @DraftDate smalldatetime
declare @DraftAmount money
declare @1stBankRoutingNo nvarchar(50)
declare @1stBankAccountNo nvarchar(50)
declare @1stBankName nvarchar(50)
declare @AgentName nvarchar(150)
declare @InitialAgencyPercent money
declare @scenario int
DECLARE @comments nvarchar(255)
declare @BankingType char(3)

/* Change the cursor to the import file if you are going to add scenarioid which is commented out also add to tblclient insert @scenario - CommScenID*/
--exec (''declare cursor_a cursor for select [First Name],[Last Name],[Debt Total],[Payment Amount],[Payment Type],[Social Security No#],[Date Received], [Lead Number], [Date Sent], [Pull Date], [Missing Info], [1st Draft Date], [1st Draft Amount], [1st Bank Routing No], [Bank Account No], [Bank Name], [Agent Name], cast((cast(Retainer as int) * 1.0)/ 100 as decimal(5,2)) as [Retainer], [Fee Structure] from DMSIMPORT..'' + @dbname)
exec (''declare cursor_a cursor for select [lead number], [Date Sent], [Date Received], [First Name], [Last Name], [Social Security No#], [1st Deposit Date], [1st Deposit Amount], [1st Bank Routing No], [1st Bank Account No], [1st Bank Name], [1st Deposit Method], [1st Checking Savings], [2nd Deposit Day], [2nd Deposit Amount], [2nd Bank Routing No], [2nd Bank Account No], [2nd Bank Name], [2nd Deposit Method], [2nd Checking Savings], [3rd Deposit Day], [3rd Deposit Amount], [3rd Bank Routing No], [3rd Bank Account No], [3rd Bank Name], [3rd Deposit Method], [3rd Checking Savings], [4th Deposit Day], [4th Deposit Amount], [4th Bank Routing No], [4th Bank Account No], [4th Bank Name], [4th Deposit Method], [4th Checking Savings], [Debt Total], [Missing Info], [Comments], [1st Draft Date], [1st Draft Amount], [1st Draft Routing No], [1st Draft Account No], [1st Draft Bank Name], [Draft Deposit Method], [Draft Checking Savings], [Agent Name], cast((cast(Retainer as int) * 1.0)/ 100 as decimal(5,2)) as [Retainer], [Banking Type] from DMSIMPORT..'' + @dbname)
open cursor_a

--fetch next from cursor_a into @lead_number, @date_sent, @date_received, @payment, @payment_type, @social_security_no, @date_received, @lead_number, @date_sent, @pull_date, @missing_info, @DraftDate, @DraftAmount, @BankRoutingNo, @BankAccountNo, @BankName, @AgentName, @setupfeepercentage, @BankingType @scenario
fetch next from cursor_a into @lead_number, @date_sent, @date_received, @first_name, @last_name, @social_security_no, @1stDepositDate, @1stDepositAmount, @1stBankRoutingNo, @1stBankAccountNo, @1stBankName, @1stDepositMethod, @1stCheckingSavings, @2ndDepositDay, @2ndDepositAmount, @2ndRoutingNo, @2ndAccountNo, @2ndBankName, @2ndDepositMethod, @2ndCheckingSavings, @3rdDepositDay, @3rdDepositAmount, @3rdRoutingNo, @3rdAccountNo, @3rdBankName, @3rdDepositMethod, @3rdCheckingSavings, @4thDepositDay, @4thDepositAmount, @4thRoutingNo, @4thAccountNo, @4thBankName, @4thDepositMethod, @4thCheckingSavings, @debt_total, @missing_info, @comments, @DraftDate, @DraftAmount, @DraftRoutingNo, @DraftAccountNo, @DraftBankName, @DraftDepositMethod, @DraftCheckingSavings, @agentname, @setupfeepercentage, @BankingType
while @@fetch_status = 0
	begin
		-- Set the Initial Agency Percent to null
		set @InitialAgencyPercent = NULL
		
		-- Set the first deposit day
		SET @1stDepositDay = datepart(day, @1stDepositDate)
		
		-- Set the default deposit methods if none exist
		IF @1stCheckingSavings IS NULL 
				BEGIN
					SET @1stCheckingSavings = ''C''
				END 
		IF @2ndCheckingSavings IS NULL 
				BEGIN
					SET @2ndCheckingSavings = ''C''
				END 
		IF @3rdCheckingSavings IS NULL 
				BEGIN
					SET @3rdCheckingSavings = ''C''
				END 
		IF @4thCheckingSavings IS NULL 
				BEGIN
					SET @4thCheckingSavings = ''C''
				END 
		IF @DraftCheckingSavings IS NULL 
				BEGIN
					SET @DraftCheckingSavings = ''C''
				END 
				
		-- Set the proper entry for SetupFeePercentage
		if @setupfeepercentage is not null
			begin
				if @setupfeepercentage = 10
					begin
						set @setupfeepercentage = 0.10
						set @InitialAgencyPercent = .02
					end
				if @setupfeepercentage = .10
					begin
						set @setupfeepercentage = 0.10
						set @InitialAgencyPercent = .02
					end
				if @setupfeepercentage = 0.10
					begin
						set @setupfeepercentage = 0.10
						set @InitialAgencyPercent = .02
					end
			end
		if @setupfeepercentage is null
			begin
				set @setupfeepercentage = 0.00
			end

		--********Banking type for trustID for client
--Seideman or Palmer only no matter what they are trustid''s of 20
if @CompanyID < 3
	begin
		set @trustid = 20
	end
--All other attorneys, make it an absolute not an else
if @CompanyID > 2
 	begin
		set @trustid = 22
	end  

		-- insert new enrollment
		insert into tblenrollment
		(
			[name],
			totalunsecureddebt,
			qualified,
			[committed],
			deliverymethod,
			agencyid,
			companyid,
			created,
			createdby
		)
		values
		(
			@first_name + '' '' + @last_name,
			@debt_total,
			1,
			1,
			''MAIL'',
			@agencyid,
			@companyid,
			coalesce(@date_received, @importdatetime),
			@importuserid
		)

		-- return new enrollment id
		set @enrollmentid = scope_identity()

		-- insert new client with this enrollment
		insert into tblclient
		(
			enrollmentid,
			trustid,
			depositmethod,
			depositamount,
			BankName,
			BankRoutingNumber,
			BankAccountNumber,
			setupfeepercentage,
			settlementfeepercentage,
			monthlyfee,
			monthlyfeeday,
			additionalaccountfee,
			returnedcheckfee,
			overnightdeliveryfee,
			agencyid,
			companyid,
			created,
			createdby,
			lastmodified,
			lastmodifiedby,
			importid,
			InitialDraftDate,
			InitialDraftAmount,
			AgentName,
			MultiDeposit
		)
		values
		(
			@enrollmentid,
			@trustid,
			@1stDepositMethod,
			@1stDepositAmount,
			@1stBankName,
			@1stBankRoutingNo,
			@1stBankAccountNo,
			@setupfeepercentage,
			@settlementfeepercentage,
			@monthlyfee,
			@monthlyfeeday,
			@additionalaccountfee,
			@returnedcheckfee,
			@overnightdeliveryfee,
			@agencyid,
			@companyid,
			coalesce(@date_received, @importdatetime),
			@importuserid,
			coalesce(@date_received, @importdatetime),
			@importuserid,
			@importid,
			@DraftDate,
			@DraftAmount,
			@AgentName,
			1
		)
		-- return new client id
		set @clientid = scope_identity()

		--Add primary Bank info to multi deposit from 1st deposit stuff
		IF @1stBankRoutingNo IS NOT NULL
			BEGIN 
				INSERT INTO tblClientBankAccount
				(
					ClientID,
					RoutingNumber,
					AccountNumber,
					BankType,
					Created,
					CreatedBy,
					LastModified,
					LastModifiedBy,
					PrimaryAccount
				)
				VALUES 
				(
					@ClientID,
					@1stBankRoutingNo,
					@1stBankAccountNo,
					@1stCheckingSavings,
					getdate(),
					24,
					getdate(),
					24,
					1
				)
				--return the new bank account id
				SET @1stBankAccountId = scope_identity()
			END 

		--Add 1st deposit day to the mix
		IF @1stDepositDay IS NOT NULL 
			BEGIN 
				INSERT INTO tblClientDepositDay
				(
					ClientID,
					Frequency,
					DepositDay,
					Occurrence,
					DepositAmount,
					Created,
					CreatedBy,
					LastModified,
					LastModifiedBy,
					BankAccountId,
					DepositMethod
				)
					VALUES 
				(
					@ClientID,
					''month'',
					@1stDepositDay,
					'' '',
					@1stDepositAmount,
					getdate(),
					24,
					getdate(),
					24,
					@1stBankAccountId,
					@1stCheckingSavings
				)	
				--return the new client deposit id
				SET @1stClientDepositId = scope_identity()
				SET @1stBankAccountId = NULL 
			END 

		SET @DuplicateBankAccount = NULL 
		--check the 2nd payment bank info for duplication if not add account to client bank account
		SET @DuplicateBankAccount = (SELECT TOP 1 BankAccountId 
		FROM tblClientBankAccount 
		WHERE  ClientID = @ClientID
	     AND (RoutingNumber+AccountNumber = @2ndRoutingNo + @2ndAccountNo))

		IF @DuplicateBankAccount IS NULL AND @2ndRoutingNo IS NOT NULL
			BEGIN
						--Add 2nd Bank info to multi deposit from draft deposit stuff. 
						INSERT INTO tblClientBankAccount
						(
							ClientID,
							RoutingNumber,
							AccountNumber,
							BankType,
							Created,
							CreatedBy,
							LastModified,
							LastModifiedBy
						)
						VALUES 
						(
							@ClientID,
							@2ndRoutingNo,
							@2ndAccountNo,
							@2ndCheckingSavings,
							getdate(),
							24,
							getdate(),
							24
						)
				SET @2ndBankAccountId = scope_identity()
			END

		IF @2ndDepositDay IS NOT NULL
			BEGIN
					--Add 2nd deposit day to the mix
					INSERT INTO tblClientDepositDay
					(
						ClientID,
						Frequency,
						DepositDay,
						Occurrence,
						DepositAmount,
						Created,
						CreatedBy,
						LastModified,
						LastModifiedBy,
						BankAccountId,
						DepositMethod
					)
						VALUES 
					(
						@ClientID,
						''month'',
						@2ndDepositDay,
						'' '',
						@2ndDepositAmount,
						getdate(),
						24,
						getdate(),
						24,
						CASE WHEN @DuplicateBankAccount IS NOT NULL THEN @DuplicateBankAccount ELSE @2ndBankAccountID END,
						@2ndDepositMethod
					)
				END 

		SET @2ndBankAccountId = NULL
		SET @DuplicateBankAccount = NULL 
		--check the 3rd payment bank info for duplication if not add account to client bank account
		SET @DuplicateBankAccount = (SELECT TOP 1 BankAccountId 
		FROM tblClientBankAccount 
		WHERE  ClientID = @ClientID
	     AND ((RoutingNumber+AccountNumber = @3rdRoutingNo + @3rdAccountNo)
		OR (@2ndRoutingNo + @2ndAccountNo = @3rdRoutingNo + @3rdAccountNo)))

		IF @DuplicateBankAccount IS NULL AND @3rdRoutingNo IS NOT NULL
			BEGIN 
						--Add 3rd Bank info to multi deposit from draft deposit stuff. 
						INSERT INTO tblClientBankAccount
						(
							ClientID,
							RoutingNumber,
							AccountNumber,
							BankType,
							Created,
							CreatedBy,
							LastModified,
							LastModifiedBy
						)
						VALUES 
						(
							@ClientID,
							@3rdRoutingNo,
							@3rdAccountNo,
							@3rdCheckingSavings,
							getdate(),
							24,
							getdate(),
							24
						)
				SET @3rdBankAccountId = scope_identity()
			END

		IF @3rdDepositDay IS NOT NULL
			BEGIN
					--Add 3rd deposit day to the mix
					INSERT INTO tblClientDepositDay
					(
						ClientID,
						Frequency,
						DepositDay,
						Occurrence,
						DepositAmount,
						Created,
						CreatedBy,
						LastModified,
						LastModifiedBy,
						BankAccountId,
						DepositMethod
					)
						VALUES 
					(
						@ClientID,
						''month'',
						@3rdDepositDay,
						'' '',
						@3rdDepositAmount,
						getdate(),
						24,
						getdate(),
						24,
						CASE WHEN @DuplicateBankAccount IS NOT NULL THEN @DuplicateBankAccount ELSE @3rdBankAccountID END,
						@3rdDepositMethod
					)
				END
				
		SET @3rdBankAccountId =	null
		SET @DuplicateBankAccount = NULL 
		--check the 4th payment bank info for duplication if not add account to client bank account
		SET @DuplicateBankAccount = (SELECT TOP 1 BankAccountId 
		FROM tblClientBankAccount 
		WHERE  ClientID = @ClientID
	     AND ((RoutingNumber+AccountNumber = @4thRoutingNo + @4thAccountNo)
		OR (@2ndRoutingNo + @2ndAccountNo = @4thRoutingNo + @4thAccountNo)
		OR (@3rdRoutingNo + @3rdAccountNo = @4thRoutingNo + @4thAccountNo)))

		IF @DuplicateBankAccount IS NULL AND @4thRoutingNo IS NOT NULL
			BEGIN 
						--Add 4th Bank info to multi deposit from draft deposit stuff. 
						INSERT INTO tblClientBankAccount
						(
							ClientID,
							RoutingNumber,
							AccountNumber,
							BankType,
							Created,
							CreatedBy,
							LastModified,
							LastModifiedBy
						)
						VALUES 
						(
							@ClientID,
							@4thRoutingNo,
							@4thAccountNo,
							@4thCheckingSavings,
							getdate(),
							24,
							getdate(),
							24
						)
				SET @4thBankAccountId = scope_identity()
			END 
		IF @4thDepositDay IS NOT NULL 
			BEGIN 
					--Add 4th deposit day to the mix
					INSERT INTO tblClientDepositDay
					(
						ClientID,
						Frequency,
						DepositDay,
						Occurrence,
						DepositAmount,
						Created,
						CreatedBy,
						LastModified,
						LastModifiedBy,
						BankAccountId,
						DepositMethod
					)
						VALUES 
					(
						@ClientID,
						''month'',
						@4thDepositDay,
						'' '',
						@4thDepositAmount,
						getdate(),
						24,
						getdate(),
						24,
						CASE WHEN @DuplicateBankAccount IS NOT NULL THEN @DuplicateBankAccount ELSE @4thBankAccountID END,
						@4thDepositMethod
					)	
				END

		SET @4thBankAccountId = NULL 
		SET @DuplicateBankAccount = NULL 
		--check the Initial draft bank info for duplicate if not add account to client bank account
		SET @DuplicateBankAccount = (SELECT TOP 1 BankAccountId 
		FROM tblClientBankAccount 
		WHERE  ClientID = @ClientID
	     AND ((RoutingNumber+AccountNumber = @4thRoutingNo + @4thAccountNo)
		OR (@2ndRoutingNo + @2ndAccountNo = @4thRoutingNo + @4thAccountNo)
		OR (@3rdRoutingNo + @3rdAccountNo = @4thRoutingNo + @4thAccountNo)
		OR (@4thRoutingNo + @4thAccountNo = @DraftRoutingNo + @DraftAccountNo)))

		IF @DuplicateBankAccount IS NULL AND @DraftRoutingNo IS NOT NULL
			BEGIN 
						--Add Draft Bank info to multi deposit from draft deposit stuff. Don''t add deposit day it''s a one time only deposit
						INSERT INTO tblClientBAnkAccount
						(
							ClientID,
							RoutingNumber,
							AccountNumber,
							BankType,
							Created,
							CreatedBy,
							LastModified,
							LastModifiedBy
						)
						VALUES 
						(
							@ClientID,
							@DraftRoutingNo,
							@DraftAccountNo,
							@DraftDepositMethod,
							getdate(),
							24,
							getdate(),
							24
						)
				END 

		-- add extra fields
		insert into tblagencyextrafields01
		(
			clientid,
			leadnumber,
			datesent,
			datereceived,
			debttotal,
			missinginfo,
			created,
			createdby,
			lastmodified,
			lastmodifiedby
		)
		values
		(
			@clientid,
			@lead_number,
			@date_sent,
			@date_received,
			@debt_total,
			@missing_info,
			coalesce(@date_received, @importdatetime),
			@importuserid,
			coalesce(@date_received, @importdatetime),
			@importuserid
		)

		-- update enrollment to have assigned client
		update
			tblenrollment
		set
			clientid = @clientid
		where
			enrollmentid = @enrollmentid

		-- insert the new primary applicant
		insert into tblperson
		(
			clientid,
			firstname,
			lastname,
			ssn,
			languageid,
			relationship,
			canauthorize,
			created,
			createdby,
			lastmodified,
			lastmodifiedby
		)
		values
		(
			@clientid,
			@first_name,
			@last_name,
			@social_security_no,
			@languageid,
			''Prime'',
			1,
			coalesce(@date_received, @importdatetime),
			@importuserid,
			coalesce(@date_received, @importdatetime),
			@importuserid
		)

		-- return new person id
		set @personid = scope_identity()

		-- set this person as primary on client
		update
			tblclient
		set
			primarypersonid = @personid
		where
			clientid = @clientid

		-- load search records for this client
		exec stp_LoadClientSearch @clientid

		-- insert "started enrollment" roadmap status for this client
		insert into tblroadmap
		(
			clientid,
			clientstatusid,
			created,
			createdby,
			lastmodified,
			lastmodifiedby
		)
		select
			clientid,
			2, -- clientstatusid: started enrollment
			coalesce(@date_received, @importdatetime),
			@importuserid,
			coalesce(@date_received, @importdatetime),
			@importuserid
		from
			tblclient
		where
			clientid = @clientid

		-- insert "completed enrollment" roadmap status for this clients
		insert into tblroadmap
		(
			parentroadmapid,
			clientid,
			clientstatusid,
			created,
			createdby,
			lastmodified,
			lastmodifiedby
		)
		select
			(select roadmapid from tblroadmap where clientid = tblclient.clientid and clientstatusid = 2) as parentroadmapid,
			clientid,
			5, -- clientstatusid: completed enrollment
			coalesce(@date_received, @importdatetime),
			@importuserid,
			coalesce(@date_received, @importdatetime),
			@importuserid
		from
			tblclient
		where
			clientid = @clientid

		-- insert "waiting for lsa and deposit" roadmap status for this clients
		insert into tblroadmap
		(
			parentroadmapid,
			clientid,
			clientstatusid,
			created,
			createdby,
			lastmodified,
			lastmodifiedby
		)
		select
			(select roadmapid from tblroadmap where clientid = tblclient.clientid and clientstatusid = 5) as parentroadmapid,
			clientid,
			6, -- clientstatusid: waiting for lsa and deposit
			coalesce(@date_received, @importdatetime),
			@importuserid,
			coalesce(@date_received, @importdatetime),
			@importuserid
		from
			tblclient
		where
			clientid = @clientid

		-- insert Ad-Hoc ACH payment for first draft, if any
		if @DraftDate is not null and @DraftRoutingNo is not null and @DraftAccountNo is not null and @DraftAmount is not NULL AND @DraftBankName IS NOT NULL 
			begin
				insert into tblAdHocACH
				(
					ClientID,
					DepositDate,
					DepositAmount,
					BankName,
					BankRoutingNumber,
					BankAccountNumber,
					Created,
					CreatedBy,
					LastModified,
					LastModifiedBy,
					InitialDraftYN
				)
				values
				(
					@ClientID,
					@DraftDate,
					@DraftAmount,
					@DraftBankName,
					@DraftRoutingNo,
					@DraftAccountNo,
					coalesce(@date_received, @importdatetime),
					@importuserid,
					coalesce(@date_received, @importdatetime),
					@importuserid,
					1
				)
		end

		--Assign account numbers to all new clients and percent if necessary

		declare @newAccountNumber varchar(50)

		--exec @newAccountNumber = stp_GetAccountNumber
		--trustid = (select top 1 trustid from tbltrust where [default] = 1), ''Belongs under set below
		DECLARE @tblTempAccount Table(AccountNum int)
        
            INSERT INTO @tblTempAccount
				exec stp_GetAccountNumber
            SELECT @newAccountNumber = AccountNum FROM @tblTempAccount
			
		update 
			tblclient 
		set 
			accountnumber = @newAccountNumber,
			trustid = @trustid,
			initialagencypercent = @InitialAgencyPercent
		where 
			clientid = @clientid

		set @numclients = @numclients + 1

		--fetch next from cursor_a into @first_name, @last_name, @debt_total, @payment, @payment_type, @social_security_no, @date_received, @lead_number, @date_sent, @pull_date, @missing_info, @DraftDate, @DraftAmount, @BankRoutingNo, @BankAccountNo, @BankName, @AgentName, @setupfeepercentage, @BankingType, @scenario
		fetch next from cursor_a into @lead_number, @date_sent, @date_received, @first_name, @last_name, @social_security_no, @1stDepositDate, @1stDepositAmount, @1stBankRoutingNo, @1stBankAccountNo, @1stBankName, @1stDepositMethod, @1stCheckingSavings, @2ndDepositDay, @2ndDepositAmount, @2ndRoutingNo, @2ndAccountNo, @2ndBankName, @2ndDepositMethod, @2ndCheckingSavings, @3rdDepositDay, @3rdDepositAmount, @3rdRoutingNo, @3rdAccountNo, @3rdBankName, @3rdDepositMethod, @3rdCheckingSavings, @4thDepositDay, @4thDepositAmount, @4thRoutingNo, @4thAccountNo, @4thBankName, @4thDepositMethod, @4thCheckingSavings, @debt_total, @missing_info, @comments, @DraftDate, @DraftAmount, @DraftRoutingNo, @DraftAccountNo, @DraftBankName, @DraftDepositMethod, @DraftCheckingSavings, @agentname, @setupfeepercentage, @BankingType
	end

CLOSE cursor_a
DEALLOCATE cursor_a

select cast(@numclients as nvarchar(5)) + '' Clients Imported Successfully!'', @numclients, @importid

END TRY
BEGIN CATCH
	select ERROR_MESSAGE()
END CATCH' 
END
GO
