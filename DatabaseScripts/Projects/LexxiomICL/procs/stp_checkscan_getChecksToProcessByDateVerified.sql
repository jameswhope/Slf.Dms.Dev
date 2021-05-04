IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_checkscan_getChecksToProcessByDateVerified')
	BEGIN
		DROP  Procedure  stp_checkscan_getChecksToProcessByDateVerified
	END

GO

CREATE Procedure stp_checkscan_getChecksToProcessByDateVerified
(
@verifyDate datetime,
@companyid int

)
as 
BEGIN
	select  
		[rowNum]= ROW_NUMBER() over (order by check21id)
		, c.companyid 
		,nc.* 
		, [amount] = r.amount 
	from 
		tblICLChecks nc 
		inner join tblregister r on nc.registerid= r.registerid 
		inner join tblclient c on c.clientid = nc.clientid
	Where 
		r.bounce is null 
		and r.void is null 
		and nc.processed is null 
		and convert(datetime,convert(varchar,verified,101)) = @verifyDate
		and c.companyid = @companyid
END
GO

GRANT EXEC ON stp_checkscan_getChecksToProcessByDateVerified TO PUBLIC

GO

