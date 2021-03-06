set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <01 - 27 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription  : Get All Emails for the user on the home page
*/
CREATE procedure [dbo].[stp_GetEmailsCommunicationForUser]
(
	@returntop varchar (50) = '100 percent',
	@userid int,
	@shortvalue int = 150
)

as

--create our results table
create table #tblResults
([type] varchar(20),
[date] datetime,
clientid int,
[client] varchar(255),
message varchar(5000),
shortmessage varchar(5000),
[lastmodifiedby] varchar(255),
[createdby] varchar(255),
fieldid int,
userid int
)


exec
(

'insert into #tblResults
	select
		''email'' as type,
		t.CreatedDate as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		t.[MailSubject] as message,
		substring(t.[MailSubject], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,		
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		t.EMailLogID as fieldid,
		t.CreatedBy
	from
		tblEmailRelayLog t inner join
		tblclient on t.clientid = tblclient.clientid inner join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.createdby = tbllastmodifiedby.userid
	where
		t.CreatedBy = ' + @userid	
)


if @returntop='100 percent' begin
	select
		* 
	from 
		#tblResults 
	where 
		userid=isnull(@userid,userid)
	order by 
		date desc, 
		fieldid desc
end else begin
	declare @amt int
	set @amt=convert(int,@returntop)
	set rowcount @amt
	select 
		* 
	from 
		#tblResults 
	where 
		userid=isnull(@userid,userid)
	order by 
		date desc, 
		fieldid desc
end

drop table #tblResults


