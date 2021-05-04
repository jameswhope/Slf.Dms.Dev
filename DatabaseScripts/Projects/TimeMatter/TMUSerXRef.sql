

Select 

s.first,
s.middle,
s.last,
--s.INIT,
CASE WHEN INIT IN('105') THEN 1152
	 WHEN INIT IN('193') THEN 851
	 WHEN INIT IN('172') THEN 1118
	 WHEN INIT IN('176') THEN 1221

     ELSE u.UserId END as UserId,
u.firstname+u.lastname,
s.first+s.middle+s.last,
u.Locked,
u.Temporary

from TIMEMATTERS.TIMEMATTERS.tm8user.staff s
left join tblUser u on 
(u.firstname+' '+u.lastname) =s.first+' '+s.last 
--(CASE WHEN middle=''  Then  s.first+' '+s.last 
--	 WHEN middle is null  Then  s.first+' '+s.last 
--	 ELSE s.first+s.middle+s.last END)
and u.Locked =0 and Temporary=0
where u.UserId is not null
