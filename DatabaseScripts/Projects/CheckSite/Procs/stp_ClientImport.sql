/****** Object:  StoredProcedure [dbo].[stp_ClientImport]    Script Date: 07/15/2008 15:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stp_ClientImport]
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
	07/14/2008	jhope			Added routine to check BankType and assign TrustIDs
								accordingly.
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
	select @setupfeepercentage = convert(money, value) from tblproperty where [name] = 'EnrollmentRetainerPercentage'
end
if @settlementfeepercentage is null begin
	select @settlementfeepercentage = convert(money, value) from tblproperty where [name] = 'EnrollmentSettlementPercentage'
end
if @monthlyfee is null begin
	select @monthlyfee = convert(money, value) from tblproperty where [name] = 'EnrollmentMonthlyFee'
end
if @monthlyfeeday is null begin
	select @monthlyfeeday = convert(int, value) from tblproperty where [name] = 'EnrollmentMonthlyFeeDay'
end
if @additionalaccountfee is null begin
	select @additionalaccountfee = convert(money, value) from tblproperty where [name] = 'EnrollmentAddAccountFee'
end
if @returnedcheckfee is null begin
	select @returnedcheckfee = convert(money, value) from tblproperty where [name] = 'EnrollmentReturnedCheckFee'
end
if @overnightdeliveryfee is null begin
	select @overnightdeliveryfee = convert(money, value) from tblproperty where [name] = 'EnrollmentOvernightFee'
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
	'DMS',
	@dbname,
	'New clients batch from agency ' + @agencyname
)

-- return freshly-inserted import record
set @importid = scope_identity()


-- loop the notes table and setup links
declare @first_name nvarchar (255)
declare @last_name nvarchar (255)
declare @debt_total money
declare @payment money
declare @payment_type nvarchar (255)
declare @social_security_no nvarchar (255)
declare @date_received smalldatetime

-- other saved "extra" fields
declare @lead_number nvarchar(255)
declare @date_sent smalldatetime
declare @pull_date smalldatetime
declare @missing_info nvarchar (255)
declare @DraftDate smalldatetime
declare @DraftAmount money
declare @BankRoutingNo nvarchar(50)
declare @BankAccountNo nvarchar(50)
declare @BankName nvarchar(50)
declare @AgentName nvarchar(150)
declare @InitialAgencyPercent money
declare @scenario int
declare @BankingType char(2)

/* Change the cursor to the import file if you are going to add scenarioid which is commented out also add to tblclient insert @scenario - CommScenID*/
--exec ('declare cursor_a cursor for select [First Name],[Last Name],[Debt Total],[Payment Amount],[Payment Type],[Social Security No#],[Date Received], [Lead Number], [Date Sent], [Pull Date], [Missing Info], [Draft Date], [Draft Amount], [Bank Routing No], [Bank Account No], [Bank Name], [Agent Name], cast((cast(Retainer as int) * 1.0)/ 100 as decimal(5,2)) as [Retainer], [Fee Structure] from DMSIMPORT..' + @dbname)
exec ('declare cursor_a cursor for select [First Name],[Last Name],[Debt Total],[Payment Amount],[Payment Type],[Social Security No#],[Date Received], [Lead Number], [Date Sent], [Pull Date], [Missing Info], [Draft Date], [Draft Amount], [Bank Routing No], [Bank Account No], [Bank Name], [Agent Name], cast((cast(Retainer as int) * 1.0)/ 100 as decimal(5,2)) as [Retainer], [Banking Type] from DMSIMPORT..' + @dbname)
open cursor_a

--fetch next from cursor_a into @first_name, @last_name, @debt_total, @payment, @payment_type, @social_security_no, @date_received, @lead_number, @date_sent, @pull_date, @missing_info, @DraftDate, @DraftAmount, @BankRoutingNo, @BankAccountNo, @BankName, @AgentName, @setupfeepercentage, @BankingType @scenario
fetch next from cursor_a into @first_name, @last_name, @debt_total, @payment, @payment_type, @social_security_no, @date_received, @lead_number, @date_sent, @pull_date, @missing_info, @DraftDate, @DraftAmount, @BankRoutingNo, @BankAccountNo, @BankName, @AgentName, @setupfeepercentage, @BankingType
while @@fetch_status = 0
	begin
		-- Set the Initial Agency Percent to null
		set @InitialAgencyPercent = NULL
		
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
		--Seideman or Palmer only no matter what they are trustid's of 20
		if @CompanyID < 3
			begin
				set @trustid = 20
			end

		--All other attorneys, make it an absolute not an else
		if @CompanyID > 2
			begin
			set @trustid = 22
			
			--Old processing relied on spread sheet data
			--if @BankingType is null
				--begin
					-- find and set the default trust to Colonial
					--select @trustid = trustid from tbltrust where [default] = 1
				--end
			--if @BankingType is not null
				--begin
					--select  @trustid = trustid from tbltrust where flag = @BankingType 
				--end
			--if @trustid is null
				--begin
					--select @trustid = trustid from tbltrust where [default] = 1
				--end
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
			@first_name + ' ' + @last_name,
			@debt_total,
			1,
			1,
			'MAIL',
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
			AgentName
		)
		values
		(
			@enrollmentid,
			@trustid,
			@payment_type,
			@payment,
			@BankName,
			@BankRoutingNo,
			@BankAccountNo,
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
			@AgentName
		)

		-- return new client id
		set @clientid = scope_identity()

		-- add extra fields
		insert into tblagencyextrafields01
		(
			clientid,
			leadnumber,
			datesent,
			datereceived,
			seidemanpulldate,
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
			@pull_date,
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
			'Prime',
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
		if @DraftDate is not null and @BankRoutingNo is not null and @BankAccountNo is not null and @DraftAmount is not null
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
					@BankName,
					@BankRoutingNo,
					@BankAccountNo,
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
		--trustid = (select top 1 trustid from tbltrust where [default] = 1), 'Belongs under set below
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
		fetch next from cursor_a into @first_name, @last_name, @debt_total, @payment, @payment_type, @social_security_no, @date_received, @lead_number, @date_sent, @pull_date, @missing_info, @DraftDate, @DraftAmount, @BankRoutingNo, @BankAccountNo, @BankName, @AgentName, @setupfeepercentage, @BankingType
	end

close cursor_a
deallocate cursor_a

select cast(@numclients as nvarchar(5)) + ' Clients Imported Successfully!', @numclients, @importid

END TRY
BEGIN CATCH
	select ERROR_MESSAGE()
END CATCH

