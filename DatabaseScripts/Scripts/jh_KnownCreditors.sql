

if not exists (select 1 from syscolumns where id = object_id('tblCreditor') and name = 'Validated') 
	alter table tblCreditor add Validated bit not null default(0)
go


if exists (select 1 from syscolumns where id = object_id('tblKnownCreditors')) BEGIN


-- clear any creditors that were previously flagged
update tblCreditor set Validated = 0 where Validated = 1

-- cleaning up creditors table
update tblCreditor set Street = replace(Street,'P O ','P.O. ') where Street like 'P O %'
update tblCreditor set City = ltrim(rtrim(City)) where City like ' %' or City like '% '

-- cleaning up known creditors table
update tblKnownCreditors set CreditorAddress1=ltrim(rtrim(CreditorAddress1)), CreditorCity=ltrim(rtrim(CreditorCity))

create table #temp ( ID int, KnownID int )

-- grab a single credtior to flag based on known credtior information
insert #temp (ID,KnownID)
select min(c.CreditorID), k.CreditorID
from tblCreditor c
join tblKnownCreditors k
 on k.CreditorName = c.Name
  and k.CreditorAddress1 = c.Street
  and k.CreditorCity = c.City
 -- and isnull(k.CreditorAddress2,'0') = isnull(c.Street2,'0')
where c.Street is not null
group by c.Name, c.Street, c.City, k.CreditorID

-- flagging known creditors
update tblCreditor
set Validated = 1
from tblCreditor c
join #temp t on t.ID = c.CreditorID
where Validated <> 1

-- linking known credtiors to an original creditor
update tblKnownCreditors
set OrigCreditorID = t.ID
from tblKnownCreditors k
join #temp t on t.KnownID = k.CreditorID
where OrigCreditorID is null

drop table #temp

-- adding the known creditors that did not match to existing creditor records
insert tblCreditor 
	(Name,Street,Street2,City,StateID,Zipcode,Created,CreatedBy,LastModified,LastModifiedBy,Validated)
select 
	CreditorName,CreditorAddress1,CreditorAddress2,CreditorCity,CreditorStateID,
	case when CreditorZipPlus is null then CreditorZip else CreditorZip + '-' + CreditorZipPlus end, 
	getdate(), -1, getdate(), -1, 1
from 
	tblKnownCreditors
where 
	OrigCreditorID is null

-- all records in this table should now be linked to an orig creditor
update tblKnownCreditors
set OrigCreditorID = c.CreditorID
from tblKnownCreditors k
join tblCreditor c
 on c.Name = k.CreditorName
 and c.Street = k.CreditorAddress1
 and isnull(c.Street2,'') = isnull(k.CreditorAddress2,'')
 and c.City = k.CreditorCity
where k.OrigCreditorID is null


END