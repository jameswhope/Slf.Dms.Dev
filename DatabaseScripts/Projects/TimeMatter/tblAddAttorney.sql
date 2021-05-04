



--SELECT 
--
--a.AttorneyId,
--(CASE When a.middlename is null then a.firstname+' '+a.lastName
--	 WHEN a.middlename =''  then a.firstname+' '+a.lastName
--     ELSE a.firstname+' '+a.lastname
--END) as AttyName,
--a.Firstname,
--a.Lastname,
-----sysid,
----archive,
----first_name,
----middle_init,
----last_name,
--con1_02_04 as [Address1],
--a.Address1,
--NULL as [Address2],
--a.Address2,
--con1_02_05 as [City],
--a.City,
--con1_02_06 as [State],
--a.State,
--con1_02_07 as [Zip],
--a.Zip,
--c.phone1,
--a.phone1,
--c.phone2,
--a.Phone2,
--con1_02_08 as [Fax],
--a.Fax,
--a.UserId as [UserId],
--dateadd(s, (c.c_time - 1)/100, dateadd(d, c.c_date, '12-28-1800')) as [CreatedDateTime],
--NULL as [CreatedDatetime],
--created_by as [CreatedBy],
--dateadd(s, (c.m_time - 1)/100, dateadd(d, c.m_date, '12-28-1800')) as [LastModifiedDate],
--NULL as [LastModifiedBy],
--NULL as [SigPath],
--con1_03_01 as [EmailAddress],
--a.EmailAddress,
--0 as [IsInhouse],
--NULL as [EmailAddress2],
--NULL as [EmailAddress3],
--con1_05_04 as [LawFirm],
--con1_05_03 as [FirmId],
--* 


INSERT INTO tblAttorney1
(
FirstName,
MiddleName,
LastName,
Address1,
City,
State,
Zip,
Phone1,
Phone2,
Fax,
UserID,
Created,
CreatedBy,
LastModified,
LastModifiedBy,
EmailAddress

)


Select 

--a.AttorneyId,
--c.sysid,
--(CASE When c.middle_init is null then c.first_name+' '+c.last_name
----	 WHEN c.middle_init =''  then c.first_name+' '+c.last_name
--     ELSE c.first_name+' '+c.last_name
--END),
c.first_name,
c.middle_init,
c.last_name,
c.con1_02_04 as address,
c.con1_02_05 as City,
c.con1_02_06 as State,
c.con1_02_07 as Zip,
--c.Address2,
c.con1_02_08 as Phone1,
c.con1_02_09 as Phone2,
NULl as Fax,
1 as [UserId],
dateadd(s, (c.c_time - 1)/100, dateadd(d, c.c_date, '12-28-1800')) as [CreatedDateTime],
1 as [UserId],
dateadd(s, (c.m_time - 1)/100, dateadd(d, c.m_date, '12-28-1800')) as [LastModifiedDate],
1 as [LastMofidiedBy],
SUBSTRING(c.con1_03_01,0,50) as EmailAddress


from TIMEMATTERS.TIMEMATTERS.tm8user.contact c
left join  tblAttorney1 a  
on 
(CASE When a.middlename is null then a.firstname+' '+a.lastName
	 WHEN a.middlename =''  then a.firstname+' '+a.lastName
     ELSE a.firstname+' '+a.lastname
END) = (CASE When c.middle_init is null then c.first_name+' '+c.last_name
	 WHEN c.middle_init =''  then c.first_name+' '+c.last_name
     ELSE c.first_name+' '+c.last_name
END)


where c.ccode ='LCNL'
and c.archive = 0
and a.AttorneyId is  null

