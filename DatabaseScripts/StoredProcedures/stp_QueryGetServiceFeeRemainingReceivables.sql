/****** Object:  StoredProcedure [dbo].[stp_QueryGetServiceFeeRemainingReceivables]    Script Date: 11/19/2007 15:27:35 ******/
DROP PROCEDURE [dbo].[stp_QueryGetServiceFeeRemainingReceivables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetServiceFeeRemainingReceivables]
	(
		@CommRecId int,
		@CommScenIds varchar(255),
		@date1 datetime=null,
		@date2 datetime=null,
		@where varchar (8000) = '',
		@orderby varchar (8000) = '',
		@period varchar (100) = ''
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

if not @orderby is null and not @orderby=''
	set @orderby= @orderby + ' , '

declare @CompanyName varchar(50)
set @CompanyName=(SELECT [Display] FROM tblCommRec WHERE CommRecId=@CommRecId)

create table #tmp(
	RegisterId int,
	ClientId int,
	AccountNumber varchar(255),
	HireDate datetime,
	CompanyName varchar(255),
	FirstName varchar(255),
	LastName varchar(255),
	FeeCategory varchar(255),
	OriginalBalance money,
	TotalPayments money,
	Rate money
)


print ('executing query - ' + CONVERT(CHAR(19), CURRENT_TIMESTAMP, 25))
exec('
INSERT INTO
	#tmp
SELECT 
	tblRegister.RegisterID,
	tblClient.ClientId,
	tblClient.AccountNumber,
	tblHireDate.HireDate,
	tblAgency.Name as CompanyName,
	tblPrimaryPerson.FirstName,
	tblPrimaryPerson.LastName,
	tblEntryType.[Name] as FeeCategory,
	-tblRegister.Amount as OriginalBalance,
	(SELECT 
		case when SUM(b.Amount) is null then 0 else sum(b.amount) end
	FROM 
		tblRegisterPayment b
	WHERE 
		b.FeeRegisterId=tblRegister.RegisterId
	) as TotalPayments,
	tblCommFee.[Percent] as Rate
FROM
	tblRegister INNER JOIN 
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	(SELECT distinct ClientId,Created as HireDate FROM tblRoadmap WHERE ClientStatusId=5) tblHireDate ON tblClient.ClientId=tblHireDate.ClientId INNER JOIN
	tblPerson tblPrimaryPerson ON tblClient.PrimaryPersonId=tblPrimaryPerson.PersonId INNER JOIN
	tblAgency ON tblClient.AgencyId=tblAgency.AgencyId INNER JOIN
	tblCommScen ON tblClient.AgencyId=tblCommScen.AgencyId AND tblHireDate.HireDate > tblCommScen.StartDate AND (tblHireDate.HireDate<tblCommScen.EndDate OR tblCommScen.EndDate is null) INNER JOIN
	tblCommStruct ON tblCommScen.CommScenId=tblCommStruct.CommScenId INNER JOIN
	tblCommFee ON (tblRegister.EntryTypeId=tblCommFee.EntryTypeId AND tblCommFee.CommStructId=tblCommStruct.CommStructId)
WHERE
	( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
	( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
	tblCommStruct.CommScenId in (' + @CommScenIds + ') AND
	tblCommStruct.CommRecId=' + @CommRecId + ' AND
	tblEntryType.Fee=1 ' + @where
)

print ('query done. selecting - ' + CONVERT(CHAR(19), CURRENT_TIMESTAMP, 25))

select
	@CompanyName as MyCompanyName,
	@period as Period,
	RegisterId,
	ClientId,
	AccountNumber,
	HireDate,
	CompanyName,
	FirstName,
	LastName,
	FeeCategory,
	OriginalBalance,
	TotalPayments,
	OriginalBalance-TotalPayments as RemainingBalance,
	Rate,
	(OriginalBalance-TotalPayments)*Rate as RemainingReceivables,
	(SELECT MAX(TransactionDate) FROM tblRegister WHERE EntryTypeId=3 and ClientId=#tmp.ClientId) as LastDepositDate
from
	#tmp
where
	((OriginalBalance-TotalPayments)*Rate) > 0

drop table #tmp
print ('finished - ' + CONVERT(CHAR(19), CURRENT_TIMESTAMP, 25))
GO
