IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'SearchCreditor')
	BEGIN
		DROP  Procedure  SearchCreditor
	END

GO

Create Procedure SearchCreditor
@CreditorName varchar(255) = '%',
@Address varchar(max) = '%' ,
@GroupName varchar(255) = '%',
@Phone varchar(max) = '%',
@CreditorGroupId int = null
AS
Begin
Select c.creditorid as [CreditorId], 
	isnull(c.Validated ,0) as [Validated],
	c.name as [CreditorName], 
	isnull(c.creditorAddressTypeId,0) as [CreditorAddressTypeId],
	isnull(c.Street,'') [Street], 
	isnull(c.Street2, '') [Street2],
	isnull(c.city,'') [City],
	isnull(c.stateid,0) [StateId],
	case when c.stateid is null then '' else ' ' + (Select abbreviation from tblstate where stateid = c.stateid ) end [State],
	isnull(zipCode, '') [ZipCode],  
	isnull(g.CreditorGroupId,0) as [CreditorGroupId], 
	g.name as [CreditorGroup],
	Phones = (select distinct isnull(p.areacode,'') + isnull(p.number,'') + ', ' 
				from tblcreditorphone cp
				inner join tblphone p on p.phoneid = cp.phoneid
				where cp.creditorid = c.creditorid
				and p.phonetypeid in (21,23)
				For XML Path(''))
from tblCreditor c 
left join tblCreditorGroup g on g.creditorGroupId = c.creditorgroupid  
Where (isnull(@CreditorGroupId,0) = 0 or @CreditorGroupId = c.creditorgroupid)
and 
isnull(c.Name,'') like @CreditorName
and 
isnull(c.Street,'') + 
case when c.Street2 is null then '' else ' ' + c.Street2 end + 
case when c.city is null then '' else ' ' + c.City end + 
case when c.stateid is null then '' else ' ' + (Select abbreviation from tblstate where stateid = c.stateid ) end + 
case when c.ZipCode is null then '' else ' ' + c.ZipCode end like  @Address
and isnull(g.name,'') like @GroupName
and coalesce((select distinct isnull(p.areacode,'') + isnull(p.number,'') + ', '
from tblcreditorphone cp
inner join tblphone p on p.phoneid = cp.phoneid
where cp.creditorid = c.creditorid
and p.phonetypeid in (21,23)
For XML Path('')),'') like @phone
Order By c.name

End

Go