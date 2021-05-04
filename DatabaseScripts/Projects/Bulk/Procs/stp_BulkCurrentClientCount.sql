if exists (select * from sysobjects where name = 'stp_BulkCurrentClientCount')
	drop procedure stp_BulkCurrentClientCount
go

create procedure stp_BulkCurrentClientCount
(
	@criteria text
)
as
begin
/*
	History:
	jhernandez		04/22/08		Created. Returns number of accounts not currently in a bulk list.
									Based on criteria assigned to an entity(user).
*/

exec('
select count(*) 
from vwNegotiationDistributionSource
where ' + @criteria + '
 and AccountID not in (select AccountID from tblBulkListXref)
')

end