select 


m.sysid as[tmid],
NULL as [MatterId],
c.ClientId as [ClientId],
NULL as [MatterStatusCodeId],
NULL as [MaterNumber],
DATEADD(day,m.c_date,'12/28/1800')  as [MatterDate],
SUBSTRING(m.memo,0,200)  as [MatterMemo],
NULL as [CreatedDateTime],
NULL as [CreatedBy],
m.created_by as [created_by],
NULL as [CreditorInstanceId],
NULL as [AttorneyId],
m.mat1_01_07 as[AttorneyFullName],
m.mat1_03_01 as[AttorneyFullname2],
CASE when m.archive =1  then 1 
	 when m.archive =0  then  0 end as [Archieve],
1  as [ActiveFlag],
1 as [MatterTypeId],
0 as [IsDeleted],
NULL as [MatterStatusId],
m.Status as [tmsubtatus],
NULL as [MatterSubStatusId]
--n.[desc] as [Notes]

from TIMEMATTER.tm8user.matter m
left join DMS_Test.dbo.tblClient c on c.AccountNumber=m.mat_no
--left join TIMEMATTERS.TIMEMATTERS.tm8user.notes n on n.mat_id=m.sysid


--where mat1_01_04 <> ''


