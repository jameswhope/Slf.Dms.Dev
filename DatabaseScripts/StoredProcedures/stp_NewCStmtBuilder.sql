/****** Object:  StoredProcedure [dbo].[stp_NewCStmtBuilder]    Script Date: 11/19/2007 15:27:25 ******/
DROP PROCEDURE [dbo].[stp_NewCStmtBuilder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/2/2006
-- Description:	Generates Client statements and Creditor Statements
-- =============================================
CREATE PROCEDURE [dbo].[stp_NewCStmtBuilder] 
-- Add the parameters for the stored procedure here
	@date1 smalldatetime = '12/1/2006', 
	@date2 smalldatetime = '12/15/2006'
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
-- declare variables for procedure here
--declare @date1 smalldatetime
--declare @date2 smalldatetime
--set @date1 = '10/31/2006'
--set @date2 = '12/1/2006'

declare @TDate smalldatetime
declare @T2Date smalldatetime
declare @day1 int
declare @day2 int
declare @AcctNo nvarchar(255)
declare @Name nvarchar(255)
declare @OrigAcctNo nvarchar(255)
declare @Status nvarchar(255)
declare @Balance money
declare @Amount money
declare @Level1Status int
declare @Level2Status int
declare @ClientId int
declare @Clientid2 int
declare @From smalldatetime
declare @To smalldatetime
declare @SDABalance money
declare @PFOBalance money
declare @cid int
    -- Insert statements for procedure here
set @day1 = DATENAME(DAY, @date1)
set @day2 = DATENAME(DAY, @date2)

--set @From = DATENAME(month, dateadd(Month,1,@date1)) +'/'+ CONVERT(VARCHAR, c.depositday) + '/' + CONVERT(VARCHAR,datepart(year, @date1))  --DATEADD(MONTH, -1, @date1)
--set @To = DATENAME(month, dateadd(Month,1,@date2)) +'/'+ CONVERT(VARCHAR, c.depositday) + '/' + CONVERT(VARCHAR,datepart(year, @date2))  --DATEADD(DAY, -1, @date1)

--Lets clean up the tblStatementResults before running
truncate table tblStatementResults

if EXISTS 
	(select * from INFORMATION_SCHEMA.tables where table_name = 'tblStatementPersonal')
	begin
		drop table tblStatementPersonal
	end
	
SELECT  c.clientid,
	c.accountnumber,
	CASE c.companyid WHEN '1' then '816' ELSE '801' END as [BaseCompany],
	p.firstname + ' ' + p.lastname as [Name],
	p.street + ' ' + isnull(p.street2,'') as [Street],
	p.city as [City],
	s.abbreviation as [ST],
	left(p.zipcode,5) as [Zip],
	'month range|last' as [period], /* period is the previous month i.e. 'From 04/01/2006 to 04/30/2006' */
	DATENAME(month, dateadd(Month,1,@date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, @date1)) AS  [DepDate],
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

	(select 'Payee' = case WHEN accountnumber > 6000000 THEN 'The Seideman Law Firm, P.C.'
		ELSE p.firstname + ' ' + p.lastname+ ' Acct # '+c.accountnumber
		END from tblClient c2 where c2.clientid = c.clientid) as Payee,

	'P.O. Box 1800' as [cslocation1],
	'Rancho Cucamonga, CA 91729-1800' as [cslocation2],
	'1-800-914-4832' as [desc1],
	'Monday thru Friday 8:00 am to 5:00 pm PST' as [desc2],
	' ' as desc3
INTO
	tblStatementPersonal
FROM
	tblClient c INNER JOIN
	tblPerson p on c.primarypersonid = p.personid LEFT JOIN
	tblState s on p.stateid = s.stateid
WHERE
	not c.currentclientstatusid in (15,17,18) 
	and not accountnumber is null
	and not accountnumber = ''
	and c.depositday > @day1
	and c.depositday < @day2

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
	print @cid
	exec stp_GetStatementForClient @cid
	fetch next from cursor_statementRes into @cid
end
close cursor_statementRes
deallocate cursor_statementRes
END
GO
