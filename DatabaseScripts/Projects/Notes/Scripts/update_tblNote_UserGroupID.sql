 
update tblNote 
set UserGroupID = u.UserGroupID
from tblNote n
join tblUser u on u.UserID = n.LastModifiedBy
where n.UserGroupID is null