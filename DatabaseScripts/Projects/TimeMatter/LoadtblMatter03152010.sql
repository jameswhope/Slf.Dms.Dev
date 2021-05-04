--03.15.2010 LoadtbLMatter

INSERT INTO tblMatter1
(
ClientId
,MatterStatusCodeId
,MatterNumber
,MatterDate
,MatterMemo
,CreatedDateTime
,CreatedBy
,CreditorInstanceId
,AttorneyId
,MatterTypeId
,IsDeleted
,MatterStatusId
,MatterSubStatusId
)

--03.15.2010 LoadtbLMatter

select 

--m.sysid as[tmid],
--m.mat_no
--,m.mat1_01_04
--m.mat_no+m.mat1_01_04,
--NULL as [MatterId], -- autopopulate
(c.ClientId) as [ClientId]
, (CASE WHEN m.Status IN('No Rep','FDCPA-SA','None','Closed','AALC','AALC Closed','CH','LD w.o/PREJUDICE','LD w/PREJUDICE','LFAC-DWOP','Completed') THEN 13 -- 13 is none
	  WHEN m.Status IN('CHASE-P/A','Consultation','HC Sent to LC','LFAC','PCHC','PCHCR','Pending','Pro Bono','Pro Per') Then 16
	  WHEN m.Status IN('Post Judgment') then 18
	  When m.Status IN('Placed') then 17
	  When m.Status IN('DLS') then 7
	  when m.Status IN('LC DLS') then 9
	  when m.Status IN('LC REP') then 10
	 ELSE NULL END) as [MatterStatusCodeId]
,0 as [MaterNumber] -- at first 0 then update with MatterId  
,dateadd(s, (m.c_time - 1)/100, dateadd(d, m.c_date, '12-28-1800'))  as [MatterDate]
,SUBSTRING(m.memo,0,200)  as [MatterMemo]
,dateadd(s, (m.c_time - 1)/100, dateadd(d, m.c_date, '12-28-1800')) as [CreatedDateTime]
--,m.created_by as [created_by]
--,dateadd(s, (m.m_time - 1)/100, dateadd(d, m.m_date, '12-28-1800')) as lastModified
,CASE WHEN m.created_by ='' then 1
	  when tmuid.first_name is null then 1
	  ELSE u2.UserId
	  END as [CreatedBy]
--,m.staff as [LastModifiedBy]
--, tmuid.first_name
--, tmuid.last_name
,CASE WHEN dbo.udf_GetlatestCI(c.ClientId,m.mat1_01_04)=''  Then NULL
	  ELSE dbo.udf_GetlatestCI(c.ClientId,m.mat1_01_04) END as [CreditorInstanceId]
,NULL as [AttorneyId]
--,m.mat1_01_07 as[AttorneyFullName]
--,m.mat1_03_01 as[AttorneyFullname2]
,1 as [MatterTypeId]
,0 as [IsDeleted]
,
CASE WHEN m.Status IN('No Rep','FDCPA-SA','None','Closed','AALC','AALC Closed','CH','LD w.o/PREJUDICE','LD w/PREJUDICE','LFAC-DWOP','Completed') THEN 2 -- Closed
	 WHEN m.Status IN('PCHCR','PCHC','Pending','Post Judgment',
						'Pro Bono','Placed','DLS','HC Sent to LC','LC DLS'
						,'LC REP','Pro Per','Consultation','LFAC','CHASE-P/A') THEN 1
	 ELSE NULL END as [MatterStatusId]
--,m.Status as [tmsubtatus]
,CASE WHEN m.Status IN('No Rep','FDCPA-SA','None','Closed','AALC','AALC Closed','CH','LD w.o/PREJUDICE','LD w/PREJUDICE','LFAC-DWOP','Completed') THEN 13 -- 13 is none
	  WHEN m.Status IN('CHASE-P/A','Consultation','HC Sent to LC','LFAC','PCHC','PCHCR','Pending','Pro Bono','Pro Per') Then 16
	  WHEN m.Status IN('Post Judgment') then 18
	  When m.Status IN('Placed') then 17
	  When m.Status IN('DLS') then 7
	  when m.Status IN('LC DLS') then 9
	  when m.Status IN('LC REP') then 10
	 ELSE NULL END as [MatterSubStatusId]

from TIMEMATTERS.TIMEMATTERs.tm8user.matter m
left join DMS_QA.dbo.tblClient c on c.AccountNumber=m.mat_no
left join (
select distinct staff, first_name,middle_init,last_name from  TIMEMATTERS.TIMEMATTERS.tm8user.userid 
where staff <>'' and first_name <> 'Court'

) tmuid on tmuid.staff=m.created_by  --[CreatedBy]

left join tblUser u2 on u2.firstname=tmuid.first_name and u2.lastname = tmuid.last_name 

where m.archive =0
and  mat1_01_04 <> ''
and mat1_01_04 NOT LIKE '%[^0-9]%'
and m.mat_no+m.mat1_01_04  NOT IN
(
'60134821001'
,'60235619976'
,'60279054209'
,'60426477981'
,'60504113593'
,'60554243478'
,'60562649766'
,'60577640426'
,'60636633532'
,'60655346173'
,'60667963892'
,'60699404697'
,'60731159981'
,'60771496790'
,'60795018106'
,'60820429550'
,'60842946833'
)
-- This only for DMS_QA as the data is bad
and c.ClientId is not null
