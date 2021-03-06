/****** Object:  StoredProcedure [dbo].[stp_QueryGetDemographics]    Script Date: 11/19/2007 15:27:34 ******/
/* Modified by JHope 5/29/2009 added Co App */
DROP PROCEDURE [dbo].[stp_QueryGetDemographics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetDemographics]
	(
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

if not @orderby is null and not @orderby=''
	set @orderby= ' order by '+@orderby 

exec('
select 

	tblclient.clientid ,
	tblperson.firstname,
	tblperson.lastname,
	(select TOP 1 firstname FROM tblperson WHERE clientid = tblclient.clientid AND relationship <> ''Prime'') + '' '' +  (select TOP 1 lastname FROM tblperson WHERE clientid = tblclient.clientid AND relationship <> ''Prime'') [CoApp],
	tblperson.city,
	tblstate.name as state,
	tblstate.stateid,
	tbllanguage.name as language,
	tbllanguage.languageid,
	tblclientstatus.name as status,
	tblperson.ssn,
	tblclient.depositmethod,
	tblclient.depositamount,
	tblperson.gender,
	tblclient.created,
	tblperson.zipcode,
	tblclient.accountnumber,
	tblperson.street,
	tblperson.emailaddress,
	c.name [company],
	(select top 1 ''('' + areacode + '') '' + left(number,3) + ''-'' + right(number,4) from tblphone p join tblpersonphone pp on pp.phoneid = p.phoneid where p.phonetypeid = 27 and pp.personid = tblperson.personid) [homephone],
	(select top 1 ''('' + areacode + '') '' + left(number,3) + ''-'' + right(number,4) from tblphone p join tblpersonphone pp on pp.phoneid = p.phoneid where p.phonetypeid = 21 and pp.personid = tblperson.personid) [workphone],
	(select top 1 ''('' + areacode + '') '' + left(number,3) + ''-'' + right(number,4) from tblphone p join tblpersonphone pp on pp.phoneid = p.phoneid where p.phonetypeid = 31 and pp.personid = tblperson.personid) [cellphone]
from
	tblclient inner join	
	tblperson on tblperson.personid=tblclient.primarypersonid inner join
	tblstate on tblperson.stateid=tblstate.stateid inner join
	tblclientstatus on tblclient.currentclientstatusid=tblclientstatus.clientstatusid inner join
	tbllanguage on tblperson.languageid=tbllanguage.languageid inner join
	tblcompany c on c.companyid = tblclient.companyid

 where 1=1 ' +  @where + @orderby 
)
GO
