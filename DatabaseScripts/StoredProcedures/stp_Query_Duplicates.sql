/****** Object:  StoredProcedure [dbo].[stp_Query_Duplicates]    Script Date: 11/19/2007 15:27:32 ******/
DROP PROCEDURE [dbo].[stp_Query_Duplicates]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[stp_Query_Duplicates] 
(
	@Select varchar (8000)='',
	@Group varchar (8000)='',
	@Join varchar (8000)='',
	@Value varchar (8000)='',
	@where varchar (8000)= '1=1'
)

as

CREATE TABLE #Duplicates
(
	ClientID int,
	AccountNumber varchar(255),
	ClientStatusID int,
	ClientStatusName varchar(255),
	AgencyID int,
	AgencyName varchar(255),
	AgencyAbbreviation varchar (255),
	Notes int,
	PhoneCalls int,
	Accounts int,
	Registers int,
	Balance money,
	Created datetime,
	CompletedDE bit,	
	CompletedUW bit,

	PersonID int,
	FirstName varchar (255),
	LastName varchar (255),
	SSN varchar(50),
	Gender varchar(1),
	Street varchar (255),
	Street2 varchar (255),
	City varchar (255),
	StateID int,
	StateAbbreviation varchar (255),
	StateName varchar (255),
	ZipCode varchar (255),

	RowIndex varchar(999)
)
--soundex
INSERT INTO
	#Duplicates
EXEC
('
SELECT
	c.ClientID,
	c.AccountNumber,
	cs.ClientStatusID,
	cs.code as ClientStatusName,
	c.AgencyID,
	a.name as AgencyName,
	a.code as AgencyAbbreviation,
	counts.Notes,
	counts.PhoneCalls,
	counts.accounts,
	counts.Registers,
	counts.Balance,
	c.Created,
	convert(bit,(case when c.vwderesolved is null then 0 else 1 end)) as CompletedDE,	
	convert(bit,(case when c.vwuwresolved is null then 0 else 1 end)) as CompletedUW,

	p.PersonID,
	p.FirstName,
	p.LastName,
	p.SSN,
	p.Gender,
	p.Street,
	p.Street2,
	p.City,
	p.StateID,
	s.abbreviation as StateAbbreviation,
	s.name as StateName,
	p.ZipCode,

	(' + @Value + ') AS RowIndex
FROM
	tblclient c left outer join
	tblperson p on c.primarypersonid=p.personid left outer join
	tblstate s on p.stateid=s.stateid left outer join
	tblclientstatus cs on c.currentclientstatusid=cs.clientstatusid left outer join
	tblagency a on c.agencyid=a.agencyid left outer join
	(
		select
			c.clientid,
			(select count(noteid) from tblnote where clientid=c.clientid) as notes,
			(select count(phonecallid) from tblphonecall where personid=p.personid) as phonecalls,
			(select count(accountid) from tblaccount where clientid=c.clientid) as accounts,
			(select count(registerid) from tblregister where clientid=c.clientid) as registers,
			(select top 1 isnull(balance,0) from tblregister where clientid=c.clientid order by transactiondate desc, registerid desc) as balance
		from
			tblclient c inner join
			tblperson p on c.primarypersonid=p.personid
	) as counts on c.clientid=counts.clientid inner join
	(
		SELECT
			' + @Select + '
		FROM
			tblclient nc left outer join
			tblperson np on nc.primarypersonid=np.personid
		GROUP BY
			' + @Group + '
		HAVING
			COUNT(*) > 1
	) as tmp ' + @Join + '
WHERE
	' + @where + '
	
ORDER BY
	rowindex
')

SELECT * FROM #Duplicates

select 
	keyid1 as clientid1,
	keyid2 as clientid2
from 
	tblduplicateexclude
where
	[table]='tblClient'
	and (
		keyid1 in (select clientid from #duplicates)
		or keyid2 in (select clientid from #duplicates)
	)
DROP TABLE #Duplicates
GO
