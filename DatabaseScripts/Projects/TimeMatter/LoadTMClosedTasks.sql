-- 3.18.2010 load tblTask  expected 81079 only Completed Tasks


INSERT INTO tblTask
(
ParentTaskID
,TaskTypeID
,Description
,AssignedTo
,Due
,Resolved
,ResolvedBy
,TaskResolutionID
,Created
,CreatedBy
,LastModified
,LastModifiedBy
,DueDateZoneDisplay
,AssignedToGroupId
,TimeBlock
,sysid
)


select distinct

--t.sysid,
--t.mat_id,
NULL as ParentTaskId,
NULL as TaskTypeId, -- AdHoc Task
t.[desc] as [Desc]
,CASE WHEN t.staff= 'DS2'  THEN 700
	  WHEN t.staff ='KPK' THEN 387
	   WHEN t.staff ='LAT' THEN 711
		WHEN t.staff ='LFP' THEN 1335
		WHEN t.staff ='SMB' THEN 1417
	    ELSE 0 END as [AsssignedTo]
,dateadd(s, (t.c_time - 1)/100, dateadd(d, t.date, '12-28-1800')) as [Due],
dateadd(s, (t.m_time - 1)/100, dateadd(d, t.m_date, '12-28-1800'))  as ResolvedDate,
1425 as ResolvedBy,
1  as  [TaskResolutionId],
dateadd(s, (t.c_time - 1)/100, dateadd(d, t.c_date, '12-28-1800')) as [Created],
CASE WHEN tx.UserId is null then 1425 ELSE tx.UserId  END as CreatedBy,
dateadd(s, (t.m_time - 1)/100, dateadd(d, t.m_date, '12-28-1800')) as [LastModified],
1454 as LastModifiedBy
,NULL as DueDateTimeZone
,CASE WHEN t.staff= 'WEST'      THEN 30
	  WHEN t.staff ='EAST' THEN 37
		WHEN t.staff IN('DFU','DS2','KPK','LAT','LFP', 'PB','PBE','PBW','RFU','SLC') THEN 39
	WHEN t.staff IN('LS','TBC','TBD') THEN 36
	ELSE 36 END as [AsssignedToGroupId]
,NULL as TimeBlock
,t.sysid


from TIMEMATTERS.TIMEMATTERS.tm8user.todo t
left join dbo.tblTMUserXref tx on tx.init  = t.created_by
where ccode = 'DONE' 
-- staff NOT IN('PB','PBE','PBW','TBC')