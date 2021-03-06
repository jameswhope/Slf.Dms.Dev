USE [DMS_LIPPY]
GO
/****** Object:  StoredProcedure [dbo].[stp_ClientStatementBuilder]    Script Date: 08/14/2007 11:51:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jim Hope
-- Create date: 03/16/2007
-- Modified date: 08/14/2007
-- Description:	Stored Proc to generate tables for client statements
-- =============================================
--ALTER PROCEDURE [dbo].[stp_ClientStatementBuilder] 
	--@date1 smalldatetime = NULL, 
	--@days int = 15,
	--@CompanyID int = -1,
	--@AccountNumber int = -1
--AS
	BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- interfering with SELECT statements.
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	-- If running as a script use this, otherwise 
	-- use @date1 as the parameter that needs to be passed.
	declare @date1 smalldatetime
	declare @days int
	declare @CompanyID int
	declare @AccountNumber int
	
	set @date1 = NULL
	set @days = 15
	set @CompanyID = -1
	set @AccountNumber = -1

    -- These are variables for the process
	declare @date2 smalldatetime
	declare @day1 int
	declare @day2 int
	declare @EOM int
	declare @RealDays int
	declare @AcctNo nvarchar(255)
	declare @Name nvarchar(255)
	declare @OrigAcctNo nvarchar(255)
	declare @Status nvarchar(255)
	declare @Balance money
	declare @Amount money
	declare @From smalldatetime
	declare @To smalldatetime
	declare @SDABalance money
	declare @PFOBalance money
	declare @cid int
	declare @cslocation2 as nvarchar(255)
	declare @PmtDate1 smalldatetime
	declare @PmtDate2 smalldatetime
	declare @DepositDate as nvarchar(50)
	declare @DateDiff int

	if @date1 is null
		begin
			set @date1 = getdate()
			set @DateDiff = datepart(day, @date1)
			if datepart(day, @date1) <= 15
				begin
					set @date1 = dateadd(day, -(@DateDiff - 1), @date1)
				end
			if datepart(day, @date1) >= 16
				begin
					set @DateDiff = @DateDiff - 15
					set @date1 = dateadd(day, - @DateDiff, @date1)
				end
		end

-- Statements for procedure follow
	set @day1 = datepart(day,@date1)
	set @day2 = datepart(day,@date2)

	-- Determine the To and From dates
	set @EOM = DAY(DATEADD(DAY,-1,DATEADD(MONTH,1,DATEADD(DAY,1-DAY(@date1),@date1))))
	if datepart(day, @date1) >= 15
		begin
			set @RealDays = @EOM - datepart(day, @date1)
		end
	else
		begin
			set @RealDays = @days - 1
		end

	set @date2 = dateadd(day, @realdays, @date1)
	
	-- Determine the To and From dates
	-- Start with Feb
if datepart(day, @date1) >= 15
		begin
			set @RealDays = @EOM - datepart(day, @date1)
		end
	else
		begin
			set @RealDays = @days - 1
		end

	set @date2 = dateadd(day, @realdays, @date1)
	
	-- Calculate date 2 from the count of days
	if datepart(day, @date1) = 1
		begin
		set @day1 = 16
		set @day2 = @eom
		end
	else
		begin
		set @day1 = 1
		set @day2 = 15
		end
		
	if @day1 = 1 and @eom = 31
		begin
			set @PmtDate1 = dateadd(day, 2 + (@eom - @realdays), @date1)
			set @PmtDate2 = dateadd(day, @EOM, @date1)
		end
	if @day1 = 16 and @eom = 31
		begin
			set @PmtDate1 = dateadd(day, 15, @date1)
			set @PmtDate2 = dateadd(day, 15, @PmtDate1)
		end

	if @day1 = 1 and @eom = 30
		begin
			set @PmtDate1 = dateadd(day, 1 + (@eom - @realdays), @date1)
			set @PmtDate2 = dateadd(day, @EOM, @date1)
		end
	if @day1 = 16 and @eom = 30
		begin
			set @PmtDate1 = dateadd(day, 15, @date1)
			set @PmtDate2 = dateadd(day, 14, @PmtDate1)
		end

	if @day1 = 1 and @eom = 28
		begin
			set @PmtDate1 = dateadd(day, (@eom - @realdays)-1, @date1)
			set @PmtDate2 = dateadd(day, @EOM, @date1)
		end
	if @day1 = 16 and @eom = 28
		begin
			set @PmtDate1 = dateadd(day, 15, @date1)
			set @PmtDate2 = dateadd(day, 12, @PmtDate1)
		end

if datepart(month, @date1) = 2
	begin
		if datename(day, @date2) = 28
			begin
				set @From = dateadd(month, -1, @date2)
				set @From = dateadd(day, - @realdays + 1, @From)
				set @To = dateadd(day,0, @date1)
			end
		else
			begin
				set @From = dateadd(month, -1, @date1)
				set @To = dateadd(day,-1,@date1)
			end
	end

if datepart(month, @date1) in (1,3,5,7,8,10,12)
	begin
		if datename(day, @date2) = 31
			begin
				set @From = dateadd(month, -1, @date1)
				set @From = dateadd(day, 1, @From)
				set @To = dateadd(day,0, @date1)
			end
		else
			begin
				set @From = dateadd(month, -1, @date1)
				set @To = dateadd(day,-1,@date1)
			end
	end

if datepart(month, @date1) in (4,6,9,11)
	begin
		if datename(day, @date2) = 30
			begin
				set @From = dateadd(month, -1, @date1)
				set @From = dateadd(day, 1, @From)
				set @To = @date1
			end
		else
			begin
				set @From = dateadd(month, -1, @date1)
				set @To = dateadd(day,-1,@date1)
			end
	end
	
--Lets clean up the tblStatementResults before running

truncate table tblStatementResults

if EXISTS 
	(select * from INFORMATION_SCHEMA.tables where table_name = 'tblStatementPersonal')
	begin
		drop table tblStatementPersonal
	end

-- OK get the clients to process based on companyid, accountno or all

-- First is there a company id to process for? If so the account number should be -1
if @CompanyID > -1 and @AccountNumber <= -1
	begin
		SELECT  c.clientid,
			c.accountnumber,
			c.companyid as [BaseCompany],
			p.firstname + ' ' + p.lastname as [Name],
			p.street + ' ' + isnull(p.street2,'') as [Street],
			p.city as [City],
			s.abbreviation as [ST],
			left(p.zipcode,5) as [Zip],
			convert(varchar, @From, 101) + ' To ' + convert(varchar, @To, 101) as [period],
			case datepart(day, @date1) when 15 then DATENAME(Month,dateadd(month, 1, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) else DATENAME(Month,dateadd(month, 0, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) end AS  [DepDate],
			c.depositamount as [DepAmt],
		-ISNULL((
				select 
					sum(amount) 
				from 
					tblRegister INNER JOIN
					tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
				where 
					tblRegister.Clientid=c.ClientId AND
					tblEntryType.Fee=1)
			,0)
			-
			ISNULL((
				select 
					sum(tblregisterpayment.amount) 
				from 
					tblRegisterPayment INNER JOIN
					tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
				where 
					tblRegister.Clientid=c.ClientId)
			,0) as PFOBalance,
			CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
			CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
			co.Name as [Payee],
			ca.address1 as [cslocation1],
			(ca.city + ', ' + ca.state + ' ' + ca.zipcode) as [cslocation2],
			cp.PhoneNumber  as [desc1],
			co.BillingMessage as [desc2],
			' ' as [desc3]

into tblStatementPersonal

		 from tblClient c INNER JOIN
			tblPerson p on c.primarypersonid = p.personid LEFT JOIN
			tblState s on p.stateid = s.stateid inner join
			tblCompany co on co.companyid = c.companyid inner join 
			tblCompanyAddresses ca on c.companyid = ca.companyid inner join
			tblcompanyphones cp on c.companyid = cp.companyid
		WHERE
			not c.currentclientstatusid in (15, 17, 18) 
			and not c.accountnumber is null
			and not c.accountnumber = ''
			and c.depositday >= @day1
			and c.depositday <= @day2
			and ca.addresstypeid = 3
			and cp.phonetype = 46
			and co.CompanyID = @CompanyID
	end

-- If neither the account number
if @CompanyID <= -1 and @AccountNumber <= -1
	begin
		SELECT  c.clientid,
			c.accountnumber,
			c.companyid as [BaseCompany],
			p.firstname + ' ' + p.lastname as [Name],
			p.street + ' ' + isnull(p.street2,'') as [Street],
			p.city as [City],
			s.abbreviation as [ST],
			left(p.zipcode,5) as [Zip],
			convert(varchar, @From, 101) + ' To ' + convert(varchar, @To, 101) as [period],
			case datepart(day, @date1) when 15 then DATENAME(Month,dateadd(month, 1, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) else DATENAME(Month,dateadd(month, 0, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) end AS  [DepDate],
			c.depositamount as [DepAmt],
		-ISNULL((
				select 
					sum(amount) 
				from 
					tblRegister INNER JOIN
					tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
				where 
					tblRegister.Clientid=c.ClientId AND
					tblEntryType.Fee=1)
			,0)
			-
			ISNULL((
				select 
					sum(tblregisterpayment.amount) 
				from 
					tblRegisterPayment INNER JOIN
					tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
				where 
					tblRegister.Clientid=c.ClientId)
			,0) as PFOBalance,
			CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
			CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
			co.Name as [Payee],
			ca.address1 as [cslocation1],
			(ca.city + ', ' + ca.state + ' ' + ca.zipcode) as [cslocation2],
			cp.PhoneNumber  as [desc1],
			co.BillingMessage as [desc2],
			' ' as [desc3]

into tblStatementPersonal

		 from tblClient c INNER JOIN
			tblPerson p on c.primarypersonid = p.personid LEFT JOIN
			tblState s on p.stateid = s.stateid inner join
			tblCompany co on co.companyid = c.companyid inner join 
			tblCompanyAddresses ca on c.companyid = ca.companyid inner join
			tblcompanyphones cp on c.companyid = cp.companyid
		WHERE
			not c.currentclientstatusid in (15, 17, 18) 
			and not c.accountnumber is null
			and not c.accountnumber = ''
			and c.depositday >= @day1
			and c.depositday <= @day2
			and ca.addresstypeid = 3
			and cp.phonetype = 46
	end

if @AccountNumber > -1 and @CompanyID <= -1
	begin
		SELECT  c.clientid,
			c.accountnumber,
			c.companyid as [BaseCompany],
			p.firstname + ' ' + p.lastname as [Name],
			p.street + ' ' + isnull(p.street2,'') as [Street],
			p.city as [City],
			s.abbreviation as [ST],
			left(p.zipcode,5) as [Zip],
			convert(varchar, @From, 101) + ' To ' + convert(varchar, @To, 101) as [period],
			case datepart(day, @date1) when 15 then DATENAME(Month,dateadd(month, 1, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) else DATENAME(Month,dateadd(month, 0, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) end AS  [DepDate],
			c.depositamount as [DepAmt],
		-ISNULL((
				select 
					sum(amount) 
				from 
					tblRegister INNER JOIN
					tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
				where 
					tblRegister.Clientid=c.ClientId AND
					tblEntryType.Fee=1)
			,0)
			-
			ISNULL((
				select 
					sum(tblregisterpayment.amount) 
				from 
					tblRegisterPayment INNER JOIN
					tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
				where 
					tblRegister.Clientid=c.ClientId)
			,0) as PFOBalance,
			CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
			CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
			co.Name as [Payee],
			ca.address1 as [cslocation1],
			(ca.city + ', ' + ca.state + ' ' + ca.zipcode) as [cslocation2],
			cp.PhoneNumber  as [desc1],
			co.BillingMessage as [desc2],
			' ' as [desc3]

into tblStatementPersonal

		 from tblClient c INNER JOIN
			tblPerson p on c.primarypersonid = p.personid LEFT JOIN
			tblState s on p.stateid = s.stateid inner join
			tblCompany co on co.companyid = c.companyid inner join 
			tblCompanyAddresses ca on c.companyid = ca.companyid inner join
			tblcompanyphones cp on c.companyid = cp.companyid
		WHERE
			not c.currentclientstatusid in (15, 17, 18) 
			and not c.accountnumber is null
			and not c.accountnumber = ''
			and c.depositday >= @day1
			and c.depositday <= @day2
			and ca.addresstypeid = 3
			and cp.phonetype = 46
			and c.AccountNumber = @AccountNumber
	end

--Table Creditor

if EXISTS 
	(select * from INFORMATION_SCHEMA.tables where table_name = 'tblStatementCreditor')
	begin
		drop table tblStatementCreditor
	end
	
	create table tblStatementCreditor
		(
			Acct_No nvarchar(255),
			Cred_Name nvarchar(255),
			Orig_Acct_No nvarchar(255),
			Status nvarchar(255),
			Balance money
		)

declare cursor_Creditor cursor for

SELECT 
	c.accountnumber [ClntAcctNo],
	cr.name [Cred. Name],
	ciOrig.accountnumber [Acct #],
	isnull(s.code, '') [Status],
	ciOrig.amount [Balance]
FROM 
	tblAccount a
	INNER JOIN tblClient c on a.clientid = c.clientid
	INNER JOIN tblCreditorInstance ciOrig on ciOrig.CreditorInstanceID=
		(SELECT 
			TOP 1 CreditorInstanceId 
		FROM 
			tblCreditorInstance 
		WHERE 
			AccountID=a.AccountID 
		ORDER BY 
			Acquired ASC)
	INNER JOIN tblCreditor cr on ciOrig.creditorid = cr.creditorid
	LEFT OUTER JOIN tblAccountStatus s on a.accountStatusID = s.accountstatusid
WHERE
	c.clientid in (select clientid from tblStatementPersonal)

open cursor_Creditor

fetch next from cursor_Creditor into @AcctNo, @Name, @OrigAcctNo, @Status, @Balance

	while @@fetch_status = 0
	begin
		insert into tblStatementCreditor
		(
			Acct_No,
			Cred_Name,
			Orig_Acct_No,
			Status,
			Balance
		)
		Values
		(
			@AcctNo,
			@Name,
			@OrigAcctNo,
			@Status,
			@Balance
		)
		fetch next from cursor_Creditor into @AcctNo, @Name, @OrigAcctNo, @Status, @Balance
	end

--close up this cursor
close cursor_Creditor
deallocate cursor_Creditor

--Results table for the statements

declare cursor_statementRes cursor for
select ClientID
from tblStatementPersonal

open cursor_statementRes

fetch next from cursor_statementRes into @cid
while @@fetch_status = 0
begin
	--print @cid
	exec stp_GetStatementForClient @cid
	fetch next from cursor_statementRes into @cid
end
close cursor_statementRes
deallocate cursor_statementRes
END


