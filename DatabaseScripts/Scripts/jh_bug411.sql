
-- BUG 411
insert tblCommRecAddress (CommRecID, Contact1, Contact2, Address1, Address2, City, [State], Zipcode, Created, CreatedBy, LastModified, LastModifiedBy)
select CommRecID, '', '', '', '', '', '', '', getdate(), -1, getdate(), -1
from (
	select CommRecID from tblCommRec where CompanyID is not null
) sub
where not exists (select 1 from tblCommRecAddress a where a.CommRecID = sub.CommRecID)

insert tblCommRecPhone (CommRecID, PhoneNumber, Created, CreatedBy, LastModified, LastModifiedBy)
select CommRecID, '', getdate(), -1, getdate(), -1
from (
	select CommRecID from tblCommRec where CompanyID is not null
) sub
where not exists (select 1 from tblCommRecPhone p where p.CommRecID = sub.CommRecID)