/****** Object:  StoredProcedure [dbo].[stp_Query_DuplicatesDetail]    Script Date: 11/19/2007 15:27:33 ******/
DROP PROCEDURE [dbo].[stp_Query_DuplicatesDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_Query_DuplicatesDetail] 
(
	@ClientIDs varchar (50)=''
)

as

create table #clientids(clientid int)
exec('insert into #clientids select clientid from tblclient where clientid in (' + @clientids + ')')


select 
	p.personid,
	p.firstname,
	p.lastname,
	p.ssn,
	p.gender,
	p.dateofbirth,
	l.[name] as [language],
	p.street,
	p.street2,
	p.city,
	s.[name] as state,
	s.stateid as stateid,
	p.zipcode,
	c.*,
	c.trustid,
	c.accountnumber,
	c.depositmethod,
	c.depositday,
	c.depositamount,
	c.bankname,
	c.bankroutingnumber,
	c.bankcity,
	bs.[name] as bankstate,
	bs.stateid as bankstateid,
	c.monthlyfee,
	c.monthlyfeeday,
	c.monthlyfeestartdate
from 
	tblclient c inner join 
	tblperson p on c.primarypersonid=p.personid left outer join
	tbllanguage l on p.languageid=l.languageid left outer join
	tblstate s on p.stateid=s.stateid left outer join
	tbltrust t on c.trustid=t.trustid left outer join
	tblstate bs on c.bankstateid=bs.stateid
where
	c.clientid in (select clientid from #clientids)


select 
	p.clientid,
	p.personid,
	p.firstname,
	p.lastname,
	p.ssn,
	p.gender,
	p.dateofbirth,
	l.[name] as [language],
	p.street,
	p.street2,
	p.city,
	s.[name] as state,
	p.zipcode
from 
	tblclient c inner join 
	tblperson p on c.clientid=p.clientid left outer join
	tbllanguage l on p.languageid=l.languageid left outer join
	tblstate s on p.stateid=s.stateid 
where
	c.clientid in (select clientid from #clientids)
	and not p.personid=c.primarypersonid

select
	c.name,
	a.*
from
	tblaccount a inner join
	tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid inner join
	tblcreditor c on ci.creditorid=c.creditorid
where
	clientid in (select clientid from #clientids)

select
	n.*
from
	tblnote n 
where
	n.clientid in (select clientid from #clientids)

select
	pc.*
from
	tblphonecall pc 
where
	pc.personid in 
		(select personid from tblperson where clientid in 
			(select clientid from #clientids)
		)

select
	*,
	et.name as entrytype
from
	tblregister t inner join
	tblentrytype et on t.entrytypeid=et.entrytypeid
where
	clientid in (select clientid from #clientids)

drop table #clientids
GO
