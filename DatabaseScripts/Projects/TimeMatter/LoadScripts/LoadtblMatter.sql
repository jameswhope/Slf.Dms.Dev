
-- Definition :	 SQL Script for loading Matter information from TimeMatter database into tblMattter
-- Revision   :  0 ~ 11/30/2009
-- Summary	  :  



IF EXISTS (Select count(MatterId) from dbo.tblMatter) 
BEGIN
print 'table is not empty'

select distinct

--mat_no
--,mat1_01_04
--c.AccountNumber
c.ClientId
,msc.MatterStatusCodeId
,mat_no +'-'+ mat1_01_04 as [MatterNumber]
,DATEADD(day,m.c_date,'12/28/1800') as [MatterDate]
,SUBSTRING(m.memo,0,200) as [MatterMemo]
--,m.status
--,msc.MatterStatusCode
,getdate() as [CreateDateTime]
,1425  as [CreatedBy] --  as your userId
,NULL as [CreditorInstanceId]
,NULL as [AttorneyId]

from TIMEMATTERS.TIMEMATTERS.tm8user.matter m
left join tblClient c on c.AccountNumber=m.mat_no
left join dbo.tblMatterStatusCode msc on msc.MatterStatusCode=m.Status
left join TIMEMATTERS.TIMEMATTERS.tm8user.userid u on u.user_name=m.created_by

where mat1_01_04 <> ''
and ClientId IS NOT NULL
and MatterStatusCodeId is not null


END
ELSE
BEGIN
print 'table is empty'



INSERT INTO dbo.tblMatter
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
)


select distinct

--mat_no
--,mat1_01_04
--c.AccountNumber
c.ClientId
,msc.MatterStatusCodeId
,mat_no +'-'+ mat1_01_04 as [MatterNumber]
,DATEADD(day,m.c_date,'12/28/1800') as [MatterDate]
,SUBSTRING(m.memo,0,200) as [MatterMemo]
--,m.status
--,msc.MatterStatusCode
,getdate() as [CreateDateTime]
,1425  as [CreatedBy] --  as your userId
,NULL as [CreditorInstanceId]
,NULL as [AttorneyId]

from TIMEMATTERS.TIMEMATTERS.tm8user.matter m
left join tblClient c on c.AccountNumber=m.mat_no
left join dbo.tblMatterStatusCode msc on msc.MatterStatusCode=m.Status
left join TIMEMATTERS.TIMEMATTERS.tm8user.userid u on u.user_name=m.created_by

where mat1_01_04 <> ''
and ClientId IS NOT NULL
and MatterStatusCodeId is not null



--join TIMEMATTERS.TIMEMATTERS.tm8user.matter m on m.mat_no = SUBSTRING(f.FormNumber,0,8) 
END 