set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <02 - 27 January 2010>
      Category    : [TimeMatter]
      Type        : {Update}
      Decription  : Get All Notes for the user on the home page
*/
ALTER procedure [dbo].[stp_GetCommunicationForUser]
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
		''Note'' as type,
		t.lastmodified as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		t.[value] as message,
		substring(t.[value], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,		
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		t.noteid as fieldid,
		t.createdby
	from
		tblnote t inner join
		tblclient on t.clientid = tblclient.clientid inner join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.lastmodifiedby = tbllastmodifiedby.userid
	where
		t.lastmodifiedby = ' + @userid
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


