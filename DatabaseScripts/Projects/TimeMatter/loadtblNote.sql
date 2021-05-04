----   03.16.2010 
----   Load tblNotes from TIMEMATTERS  
----   total rows : 44590 rows 


select top 100

 m.sysid
,n.sysid
,n.[desc] as [Subject]
,n.[memo] as [Value]
,dateadd(s, (n.c_time - 1)/100, dateadd(d, n.c_date, '12-28-1800'))  as [Created]
,n.created_by as [Createdby]
,dateadd(s, (n.m_time - 1)/100, dateadd(d, m.c_date, '12-28-1800'))  as [LastModified]
,NULL as [LastModifiedby]
,NULL as [OldTable]
,NULL as [OldId]
,c.ClientId as [ClientId]
,NULL as [UserGroupId]
,NULL as [Deleted]
,NULL as [Deletedby]
,0 as [IsPrivate]
,*


from TIMEMATTERS.TIMEMATTERs.tm8user.matter m
join TIMEMATTERS.TIMEMATTERS.tm8user.notes n on n.mat_id= m.sysid
left join dbo.tblClient c on c.AccountNumber=m.mat_no

 