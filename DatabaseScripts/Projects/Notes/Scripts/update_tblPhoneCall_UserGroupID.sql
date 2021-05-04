 
update tblPhoneCall 
set UserGroupID = u.UserGroupID
from tblPhoneCall p
join tblUser u on u.UserID = p.LastModifiedBy
where p.UserGroupID is null 