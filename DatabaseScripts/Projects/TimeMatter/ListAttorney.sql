
SELECT 

a.AttorneyId,
(CASE When a.middlename is null then a.firstname+' '+a.lastName
	 WHEN a.middlename =''  then a.firstname+' '+a.lastName
     ELSE a.firstname+' '+a.lastname
END) as AttyName,
a.Firstname,
a.Lastname,
---sysid,
--archive,
--first_name,
--middle_init,
--last_name,
con1_02_04 as [Address1],
a.Address1,
NULL as [Address2],
a.Address2,
con1_02_05 as [City],
a.City,
con1_02_06 as [State],
a.State,
con1_02_07 as [Zip],
a.Zip,
c.phone1,
a.phone1,
c.phone2,
a.Phone2,
con1_02_08 as [Fax],
a.Fax,
a.UserId as [UserId],
dateadd(s, (c.c_time - 1)/100, dateadd(d, c.c_date, '12-28-1800')) as [CreatedDateTime],
NULL as [CreatedDatetime],
created_by as [CreatedBy],
dateadd(s, (c.m_time - 1)/100, dateadd(d, c.m_date, '12-28-1800')) as [LastModifiedDate],
NULL as [LastModifiedBy],
NULL as [SigPath],
con1_03_01 as [EmailAddress],
a.EmailAddress,
0 as [IsInhouse],
NULL as [EmailAddress2],
NULL as [EmailAddress3],
con1_05_04 as [LawFirm],
con1_05_03 as [FirmId],
* 

from tblAttorney a  
left join TIMEMATTERS.TIMEMATTERS.tm8user.contact c
on 
(CASE When a.middlename is null then a.firstname+' '+a.lastName
	 WHEN a.middlename =''  then a.firstname+' '+a.lastName
     ELSE a.firstname+' '+a.lastname
END) = (CASE When c.middle_init is null then c.first_name+' '+c.last_name
	 WHEN c.middle_init =''  then c.first_name+' '+c.last_name
     ELSE c.first_name+' '+c.last_name
END)


where ccode ='LCNL'
and archive = 0
