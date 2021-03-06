/****** Object:  StoredProcedure [dbo].[stp_GetComms]    Script Date: 11/19/2007 15:27:06 ******/
DROP PROCEDURE [dbo].[stp_GetComms]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetComms]
	(
		@clientid int,
		@relationid int = null,
		@relationtypeid int = null,
		@orderby varchar(50)='bylastnamE asc',
		@clientonly bit=0
	)

as


create table #tmpNotes
(
	noteid int,
	subject varchar(255),
	[value] varchar(5000),
	[by] varchar(255),
	bylastname varchar(255),
	[date] datetime,
	usertype varchar(255),
	color varchar(50)
)

insert into #tmpNotes
(
	noteid,
	subject,
	[value],
	[by],
	bylastname,
	[date],
	usertype,
	color
)
exec stp_getnotes2 @clientid,@relationid,@relationtypeid,'u.lastname asc',@clientonly

create table #tmpPhoneCalls
(
	phonecallid int,
	personid int,
	userid int,
	clientid int,
	phonenumber varchar(50),
	direction bit,
	subject varchar(255),
	body varchar(5000),
	starttime datetime,
	endtime datetime,
	person varchar(255),
	personlastname varchar(255),
	[by] varchar(255), 
	bylastname varchar(255),
	createdbyname varchar(255),
	lastmodifiedbyname varchar(255),
	usertype varchar(255),
	color varchar(50)
)

insert into #tmpPhoneCalls
(
	phonecallid,
	personid,
	userid,
	clientid,
	phonenumber,
	direction,
	subject,
	body,
	starttime,
	endtime,
	person,
	personlastname,
	[by], 
	bylastname,
	createdbyname,
	lastmodifiedbyname,
	usertype,
	color
)
exec stp_getphonecalls2 @clientid,@relationid,@relationtypeid,'u.lastname asc',@clientonly

exec('
select 
	0 as CommType,
	NoteID as PK,
	Subject,
	[Value],
	[By],
	ByLastName,
	[Date] as Date1,
	[Date] as Date2,
	UserType,
	Color
from 
	#tmpnotes

union

select
	1 as CommType,
	PhoneCallID as PK,
	Subject,
	Body as [Value],
	[By],
	ByLastName,
	StartTime as Date1,
	EndTime as Date2,
	UserType,
	Color,
	Person,
	PersonLastName,
	Direction
	
order by
	' + @orderby
)
drop table #tmpnotes
drop table #tmpphonecalls
GO
