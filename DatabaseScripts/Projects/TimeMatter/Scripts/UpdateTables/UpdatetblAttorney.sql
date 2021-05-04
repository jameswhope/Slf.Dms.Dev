--*** Revision 0 12/30/2009 ****
--*** add EmailAddress field for tblAttorney ****/
--*** 2.11.2010 *****
--*** Add IsInHouse field to tblAttorney 

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblAttorney' AND COLUMN_NAME = 'EmailAddress')
BEGIN
   ALTER TABLE tblAttorney ADD EmailAddress varchar(50)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblAttorney' AND COLUMN_NAME = 'IsInhouse')
BEGIN
   ALTER TABLE tblAttorney ADD IsInhouse bit
END

Update tblAttorney 
Set IsInhouse =1  Where  AttorneyId IN (2,229,470,471) 


select * from tblAttorney  Where  AttorneyId IN (2,229,470,471)

/*** Insert New Attorney ****/
/*** check Attorney information ***/

Select distinct
tmc.org,
tmc.ccode,
tmc.first_name,
--substring(tmc.first_name,1,NULLIF(CHARINDEX(' ', tmc.first_name) - 1, -1)) As FirstName1,
CHARINDEX(' ', tmc.first_name) - 1 as c,
CASE WHEN (CHARINDEX(' ', tmc.first_name) - 1) >0 
	 THEN substring(tmc.first_name,1,NULLIF(CHARINDEX(' ', tmc.first_name) - 1, -1))
	 ELSE tmc.first_name END as FirstName1,	
CASE WHEN (CHARINDEX(' ', tmc.first_name) - 1) >0 
	 THEN SUBSTRING(tmc.first_name, CHARINDEX(' ', tmc.first_name) + 1, LEN(tmc.first_name))
	 ELSE '' END as Middlename,	
tmc.last_name,
a.FirstName,
a.MiddleName,
a.LastName

from TIMEMATTERS.TIMEMATTERS.tm8user.contact tmc
left join tblAttorney1 a on 

a.FirstName=
(CASE WHEN (CHARINDEX(' ', tmc.first_name) - 1) >0 
	 THEN substring(tmc.first_name,1,NULLIF(CHARINDEX(' ', tmc.first_name) - 1, -1))
	 ELSE tmc.first_name END)and
a.LastName=tmc.last_name

where tmc.ccode='LCNL' 
and a.FirstName is NuLL
order by tmc.last_name 


/*** Update Attorney  ****/

Select distinct
tmc.org,
tmc.ccode,
tmc.first_name,
a.AttorneyId,
a.FirstName,
CASE WHEN (CHARINDEX(' ', tmc.first_name) - 1) >0 
	 THEN substring(tmc.first_name,1,NULLIF(CHARINDEX(' ', tmc.first_name) - 1, -1))
	 ELSE tmc.first_name END as FirstName1,	
CHARINDEX(' ', tmc.first_name) - 1 as c,
CASE WHEN (CHARINDEX(' ', tmc.first_name) - 1) >0 
	 THEN SUBSTRING(tmc.first_name, CHARINDEX(' ', tmc.first_name) + 1, LEN(tmc.first_name))
	 ELSE '' END as Middlename,	
a.MiddleName,
tmc.last_name,
a.LastName,
a.Suffix,
tmc.Suffix,
a.EmailAddress,
tmc.con1_03_01,
a.Address1,
a.Address2,
a.City,
tmc.con1_02_05,
a.State,
tmc.con1_02_06,
a.Phone1,
tmc.Phone1,
a.Phone2,
tmc.Phone2,
a.Zip,
tmc.con1_02_07




from TIMEMATTERS.TIMEMATTERS.tm8user.contact tmc
left join tblAttorney1 a on 
a.FirstName=
(CASE WHEN (CHARINDEX(' ', tmc.first_name) - 1) >0 
	 THEN substring(tmc.first_name,1,NULLIF(CHARINDEX(' ', tmc.first_name) - 1, -1))
	 ELSE tmc.first_name END)and
a.LastName=tmc.last_name
where tmc.ccode='LCNL' 
and a.AttorneyId is not null

order by tmc.last_name 

