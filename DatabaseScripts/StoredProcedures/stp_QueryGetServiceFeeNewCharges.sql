/****** Object:  StoredProcedure [dbo].[stp_QueryGetServiceFeeNewCharges]    Script Date: 11/19/2007 15:27:34 ******/
DROP PROCEDURE [dbo].[stp_QueryGetServiceFeeNewCharges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetServiceFeeNewCharges]
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
	set @orderby= 'ORDER BY '+@orderby 

declare @CompanyName varchar(50)
set @CompanyName=(SELECT [Display] FROM tblCommRec WHERE CommRecId=@CommRecId)

exec('
SELECT
	tblRegister.RegisterId,
	tblClient.ClientID,
	tblClient.AccountNumber,
	(SELECT Top 1 Created FROM tblRoadmap WHERE ClientId=tblClient.ClientId AND ClientStatusId=5) as HireDate,
	tblAgency.Name as CompanyName,
	''' + @CompanyName + ''' as MyCompanyName,
	tblPrimaryPerson.FirstName,
	tblPrimaryPerson.LastName,
	tblEntryType.[Name] as FeeCategory,
	''' + @period + ''' as Period,
	tblCommFeeCharge.FixedAmount as Amount,
	tblRegister.TransactionDate

FROM 
	tblRegister INNER JOIN
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	tblPerson tblPrimaryPerson ON tblClient.PrimaryPersonId=tblPrimaryPerson.PersonId INNER JOIN
	tblAgency ON tblClient.AgencyId=tblAgency.AgencyId INNER JOIN
	tblCommFeeCharge ON tblRegister.EntryTypeId=tblCommFeeCharge.EntryTypeId 
		AND tblCommFeeCharge.CommRecId=' + @CommRecId + '
	
WHERE
	( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
	( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
	tblClient.AgencyId in (SELECT AgencyId FROM tblCommScen WHERE CommScenId 
			IN (' + @CommScenIds + ')) ' + @where + 
	' ' + @orderby + ' '
)
GO
