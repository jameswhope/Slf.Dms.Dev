IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_getAllRecordsReadyToProcess')
	BEGIN
		DROP  Procedure  stp_CheckScan_getAllRecordsReadyToProcess
	END

GO


CREATE procedure [stp_CheckScan_getAllRecordsReadyToProcess]
as
begin

select  distinct
[rowNum]= ROW_NUMBER() over (order by check21id)
, p.firstname + ' ' + p.lastname[ClientName] 
, case when p.street2 is null then p.street else p.street + ', ' + p.street2 end + ', ' + p.city + ', ' + s.abbreviation + ' ' + p.zipcode[ClientAddress]
, nc.* 
, [amount] = r.amount 
from tblICLChecks nc 
inner join tblregister r on nc.registerid= r.registerid 
inner join tblclient c on c.clientid = nc.clientid
inner join tblperson p on p.personid = c.primarypersonid
left join tblstate s on s.stateid = p.stateid
Where r.bounce is null and r.void is null and nc.processed is null and nc.deletedate is null
end


GO

GRANT EXEC ON stp_CheckScan_getAllRecordsReadyToProcess TO PUBLIC

GO


