IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_checkscan_getChecksToProcessByRegisterIDs')
	BEGIN
		DROP  Procedure  stp_checkscan_getChecksToProcessByRegisterIDs
	END

GO

CREATE Procedure stp_checkscan_getChecksToProcessByRegisterIDs
(
@regIDS varchar(max),
@companyid int
)
as 
BEGIN
	--declare @regIDS varchar(max)
	--declare @companyid int
	
	--set @companyid = 3
	--set @regIDS = '2260244,2260245'

	declare @ssql varchar(max)

	set @ssql = 'select [rowNum]= ROW_NUMBER() over (order by check21id), c.companyid,nc.*,[amount] = r.amount '
	set @ssql = @ssql + 'from tblICLChecks nc inner join tblregister r on nc.registerid= r.registerid '
	set @ssql = @ssql + 'inner join tblclient c on c.clientid = nc.clientid '
	set @ssql = @ssql + 'Where r.bounce is null and r.void is null and nc.processed is null '
	set @ssql = @ssql + 'and r.registerid in (' + @regIDS + ')'
	set @ssql = @ssql + 'and c.companyid = ' + cast(@companyid as varchar)
	
	exec (@ssql)
END

GO


GRANT EXEC ON stp_checkscan_getChecksToProcessByRegisterIDs TO PUBLIC

GO


