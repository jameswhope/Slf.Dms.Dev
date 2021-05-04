


-- 03.12.2010 

-- Script to load data from tblMatter phone record into tblPhoneCall

INSERT INTO  dbo.tblPhoneCallTest
(
PersonID
,UserID
,PhoneNumber
,Direction
,Subject
,Body
,StartTime
,EndTime
,Created
,CreatedBy
,LastModified
,LastModifiedBy
,ClientID
,UserGroupId
)

select 

--m.mat_no 
--,m.mat1_01_04,
c.PrimaryPersonId as [PersonId] -- Primary person of the Client
,u.UserId as [UserId]   -- UserId create 
,ph.AreaCode+'-'+ph.Number as [PhoneNumber] -- Phone Number of the Primary person
,CASE WHEN p.in_out='I' THEN 0
	  WHEN p.in_out='O' THEN 1 END as [Direction]    -- Direction of the Call
,p.Subject [Subject]
,p.Memo [Body]
--,p.date [PhoneDate]
,dateadd(s, (p.time - 1)/100, dateadd(d, p.date, '12-28-1800'))  as [PhoneStartTime]
--,(p.time-1)/100 [PhoneStartTime]
--,p.EndTime [PhoneEndTime]
,dateadd(s, (p.Endtime - 1)/100, dateadd(d, p.date, '12-28-1800'))  as [PhoneEndTime]
,dateadd(s, (p.c_time - 1)/100, dateadd(d, p.c_date, '12-28-1800')) as [Created]
,u.UserId as [CreatedBy]
--,p.created_by as CreatedBy
--,uid.first_name 
--,uid.last_name
,dateadd(s, (p.m_time - 1)/100, dateadd(d, p.m_date, '12-28-1800')) as lastModified
--,p.staff as lastModifiedBy 
,u2.UserId as [LastModifiedBy]
, c.ClientId as ClientId
, u.UserGroupId as UserGroupId

from TIMEMATTERS.TIMEMATTERS.tm8user.phone p
join TIMEMATTERS.TIMEMATTERS.tm8user.matter m  on p.mat_id=m.sysid
left join TIMEMATTERS.TIMEMATTERS.tm8user.userid uid on uid.staff=p.created_by --[CreatedBy]
left join TIMEMATTERS.TIMEMATTERS.tm8user.userid uid2 on uid2.staff=p.staff --[lastModifiedBy]
left join tblClient c on c.AccountNumber = m.mat_no
--left join 
--(Select TOP 1 c1.ClientId,ph1.PhoneTypeId,ph1.AreaCode,ph1.Number,ph1.Extension,pt1.Name
--from 
--dbo.tblClient c1 
--left join tblPerson per1 on per1.PersonId= c1.PrimaryPersonId
--left join tblPersonPhone pp1 on pp1.PersonId = per1.PersonId
--left join tblPhone ph1 on ph1.PhoneId=pp1.PhoneId
--left join tblPhoneType pt1 on pt1.PhoneTypeId = ph1.PhoneTypeId
--where c1.ClientId= 84443
--
--)ClientPhone on ClientPhone.ClientId=c.ClientId
left join tblPerson per on per.PersonId= c.PrimaryPersonId
left join tblPersonPhone pp on pp.PersonId = per.PersonId
left join tblPhone ph on ph.PhoneId=pp.PhoneId
left join tblUser u on u.firstname=uid.first_name and u.lastname = uid.last_name and u.Locked=0 and u.Temporary=0
left join tblUser u2 on u2.firstname=uid2.first_name and u2.lastname = uid2.last_name and u2.Locked=0 and u2.Temporary=0

where c.ClientId=67901

--where sysid='A666B99430E26846'
--
--select * from  TIMEMATTERS.tm8user.rec_phone where mat_id='A666B99430E26846'
--
--select mat_id,* from  TIMEMATTERS.tm8user.phone where mat_id='A666B99430E26846'