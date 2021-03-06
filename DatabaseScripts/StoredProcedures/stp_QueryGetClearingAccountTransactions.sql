/****** Object:  StoredProcedure [dbo].[stp_QueryGetClearingAccountTransactions]    Script Date: 11/19/2007 15:27:33 ******/
DROP PROCEDURE [dbo].[stp_QueryGetClearingAccountTransactions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetClearingAccountTransactions]
	(
		@CommRecId int,
		@CommScenIds varchar(255),
		@date1 datetime=null,
		@date2 datetime=null,
		@where varchar (8000) = '',
		@period varchar (100) = '',
		@orderby varchar(8000) = ''
	)

as

if not @orderby is null and not @orderby=''
	set @orderby = @orderby + ' , '

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

declare @CompanyName varchar(50)
set @CompanyName=(SELECT [Display] FROM tblCommRec WHERE CommRecId=@CommRecId)

exec('
SELECT
	tblRegister.RegisterId,
	tblClient.AccountNumber,
	(SELECT Top 1 Created FROM tblRoadmap WHERE ClientId=tblClient.ClientId AND ClientStatusId=5) as HireDate,
	''' + @CompanyName + ''' as MyCompanyName,
	tblPrimaryPerson.FirstName,
	tblPrimaryPerson.LastName,
	tblEntryType.[Name] as FeeCategory,
	''' + @period + ''' as Period,
	-tblRegister.Amount as Amount

FROM 
	tblRegister INNER JOIN
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	tblPerson tblPrimaryPerson ON tblClient.PrimaryPersonId=tblPrimaryPerson.PersonId INNER JOIN
	tblAgency ON tblClient.AgencyId=tblAgency.AgencyId
WHERE
	( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
	( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
	(tblEntryType.EntryTypeId in (7,11,12,14,15,20,27) OR
	tblEntryType.Fee=1)  AND
	tblClient.AgencyId in (SELECT AgencyId FROM tblCommScen WHERE CommScenId 
			IN (' + @CommScenIds + ')) ' + @where + 
	' ORDER BY ' + @orderby + ' tblClient.ClientId ASC' 
)
GO
